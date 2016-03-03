//------------------------------------------------------------------------
//  ARCHIVE Handling - ZIP files
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2009-2011 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "main.h"

#include <zlib.h>

#include <list>

#include "lib_util.h"
#include "lib_zip.h"


#define LOCAL_CRC_OFFSET   (7*2)
#define LOCAL_NAME_OFFSET  (15*2)


#define ZIPF_MAX_PATH  200

#define ZIPF_BUFFER  4096

static FILE *r_zip_fp;
static FILE *w_zip_fp;


typedef struct
{
	raw_zip_central_header_t  hdr;

	// TODO: use a string pointer instead
	char name[ZIPF_MAX_PATH];

	int data_offset;  // where the data actually begins
}
zip_central_entry_t;


typedef struct
{
	raw_zip_local_header_t  hdr;

	// TODO: use a string pointer instead
	char name[ZIPF_MAX_PATH];
}
zip_local_entry_t;


class zip_read_state_c
{
public:
	int entry;

	zip_central_entry_t *E;

	z_stream Z;

	byte in_buffer[ZIPF_BUFFER];

	// the chunk of the file currently in 'in_buffer'
	int in_position;
	int in_length;

	// current offset : the place the last ReadData() reached
	// NOTE: only used when decompressing
	int cur_offset;

	// prevent some needless fseeks while decompressing
	bool have_seeked;

public:
	zip_read_state_c(int _entry, zip_central_entry_t *_E) :
		entry(_entry), E(_E), in_length(0), cur_offset(0),
		have_seeked(false)
	{
		in_position = E->data_offset;

		/* setup zlib stuff, even if we don't use it */

		// use Zlib's default allocator
		Z.zalloc = Z_NULL;
		Z.zfree  = Z_NULL;

		// no data yet
		Z.next_in  = in_buffer;
		Z.avail_in = in_length;

		inflateInit2(&Z, -15);  // window bits + no header
	}

	~zip_read_state_c()
	{
		inflateEnd(&Z);
	}

	void Reset()
	{
		in_position = E->data_offset;
		in_length   = 0;

		cur_offset  = 0;
		have_seeked = false;

		// no data yet
		Z.next_in  = in_buffer;
		Z.avail_in = in_length;

		inflateReset(&Z);
	}

	int in_Remaining() const
	{
		return E->data_offset + E->hdr.compress_size - in_position;
	}

	bool Fill()
	{
		// buffer should not be full already
		SYS_ASSERT(in_length < ZIPF_BUFFER);

		int remaining = in_Remaining();

		// this is assured by EOF check in ZIPF_ReadData() body
		SYS_ASSERT(remaining > 0);

		int want = MIN(remaining, ZIPF_BUFFER - in_length);

		if (! have_seeked)
		{
			if (fseek(r_zip_fp, in_position + in_length, SEEK_SET) != 0)
				return false;

			have_seeked = true;
		}

		if (fread(in_buffer + in_length, want, 1, r_zip_fp) != 1)
			return false;

		in_length  += want;
		Z.avail_in += want;

		return true;
	}

	void Consume()
	{
		int used = Z.next_in - in_buffer;

		if (used == 0)
			return;

		SYS_ASSERT(1 <= used && used <= in_length);

		int keep = in_length - used;

		// move the remaining portion to front of buffer
		if (keep > 0)
		{
			memmove(in_buffer, in_buffer + used, keep);
		}

		in_length   -= used;
		in_position += used;

		Z.next_in  = in_buffer;
		Z.avail_in = in_length;
	}
};


//------------------------------------------------------------------------
//  ZIP READING
//------------------------------------------------------------------------

static raw_zip_end_of_directory_t  r_end_part;
static zip_central_entry_t * r_directory;

// IDEA: have a read_state per entry (E->read_state)
static zip_read_state_c *r_read_state;


static void destroy_read_state();


static int find_end_part()
{
	// returns the file offset if found, -1 if not found

	static byte buffer[ZIPF_BUFFER];

	// find the end-of-directory structure, search backwards from the
	// end of the file looking for its signature.

	fseek(r_zip_fp, 0, SEEK_END);

	int position = (int)ftell(r_zip_fp);

	while (position > 0)
	{
		// move back through file
		if (position > ZIPF_BUFFER-12)
			position -= (ZIPF_BUFFER-12);
		else
			position = 0;

		if (fseek(r_zip_fp, position, SEEK_SET) != 0)
			break;

		int length = fread(buffer, 1, ZIPF_BUFFER, r_zip_fp);

		// stop on read error
		if (length <= 0 || ferror(r_zip_fp))
			break;

		for (int offset = length-4 ; offset >= 0 ; offset--)
		{
			if (buffer[offset  ] == ZIPF_END_MAGIC[0] &&
				buffer[offset+1] == ZIPF_END_MAGIC[1] &&
				buffer[offset+2] == ZIPF_END_MAGIC[2] &&
				buffer[offset+3] == ZIPF_END_MAGIC[3])
			{
				return position + offset;
			}
		}
	}

	return -1;  // not found
}


static bool load_end_part()
{
	int position = find_end_part();

	if (position <= 0)
	{
		LogPrintf("ZIPF_OpenRead: not a ZIP file (cannot find EOD)\n");
		return false;
	}

	DebugPrintf("ZIP end-of-directory found at: 0x%08x\n", position);

	fseek(r_zip_fp, position, SEEK_SET);

	if (fread(&r_end_part, sizeof(r_end_part), 1, r_zip_fp) != 1 ||
			memcmp(r_end_part.magic, ZIPF_END_MAGIC, 4) != 0)
	{
		LogPrintf("ZIPF_OpenRead: bad ZIP file? (failed to load EOD)\n");
		return false;
	}

	// fix endianness
	r_end_part.this_disk        = LE_U16(r_end_part.this_disk);
	r_end_part.central_dir_disk = LE_U16(r_end_part.central_dir_disk);
	r_end_part.disk_entries     = LE_U16(r_end_part.disk_entries);
	r_end_part.total_entries    = LE_U16(r_end_part.total_entries);
	r_end_part.comment_length   = LE_U16(r_end_part.comment_length);

	r_end_part.dir_size   = LE_U32(r_end_part.dir_size);
	r_end_part.dir_offset = LE_U32(r_end_part.dir_offset);

	return true; // OK
}


static bool read_directory_entry(zip_central_entry_t *E)
{
	int position = (int)ftell(r_zip_fp);

	int res = fread(&E->hdr, sizeof(raw_zip_central_header_t), 1, r_zip_fp);

	if (res != 1 || ferror(r_zip_fp))
		return false;

	// check signature
	if (memcmp(E->hdr.magic, ZIPF_CENTRAL_MAGIC, 4) != 0)
	{
		LogPrintf("ZIP: signature check failed\n");
		return false;
	}

	// fix endianness
	E->hdr.made_version    = LE_U16(E->hdr.made_version);
	E->hdr.req_version     = LE_U16(E->hdr.req_version);

	E->hdr.flags           = LE_U16(E->hdr.flags);
	E->hdr.comp_method     = LE_U16(E->hdr.comp_method);
	E->hdr.file_time       = LE_U16(E->hdr.file_time);
	E->hdr.file_date       = LE_U16(E->hdr.file_date);

	E->hdr.crc             = LE_U32(E->hdr.crc);
	E->hdr.compress_size   = LE_U32(E->hdr.compress_size);
	E->hdr.full_size       = LE_U32(E->hdr.full_size);

	E->hdr.name_length     = LE_U16(E->hdr.name_length);
	E->hdr.extra_length    = LE_U16(E->hdr.extra_length);
	E->hdr.comment_length  = LE_U16(E->hdr.comment_length);
	E->hdr.start_disk      = LE_U16(E->hdr.start_disk);

	E->hdr.internal_attrib = LE_U16(E->hdr.internal_attrib);
	E->hdr.external_attrib = LE_U32(E->hdr.external_attrib);

	E->hdr.local_offset    = LE_U32(E->hdr.local_offset);


	// read filename
	int name_length = E->hdr.name_length;

	if (name_length > ZIPF_MAX_PATH-2)
	{
		LogPrintf("ZIP: truncating long filename (%d chars)\n", name_length);
		name_length = ZIPF_MAX_PATH-2;
	}

	fread(E->name, name_length, 1, r_zip_fp);  // ??? CHECK ERROR

	// ensure name is NUL terminated
	E->name[name_length] = 0;


	/// TODO: sanitize the name?
	/// for (char * p = E->name ; *p ; p++) { ... }


	// seek to next entry
	position += (int)sizeof(raw_zip_central_header_t);

	position += E->hdr.name_length;
	position += E->hdr.extra_length;
	position += E->hdr.comment_length;

	fseek(r_zip_fp, position, SEEK_SET);

	return true; // OK
}


bool ZIPF_OpenRead(const char *filename)
{
	r_zip_fp = fopen(filename, "rb");

	if (! r_zip_fp)
	{
		LogPrintf("ZIPF_OpenRead: no such file: %s\n", filename);
		return false;
	}

	LogPrintf("Opened ZIP file: %s\n", filename);

	if (! load_end_part())
	{
		fclose(r_zip_fp);
		return false;
	}

	/* read directory */

	DebugPrintf("ZIP central directory at offset: 0x%08x\n", r_end_part.dir_offset);

	if (r_end_part.total_entries >= 5000)  // sanity check
	{
		LogPrintf("ZIPF_OpenRead: bad ZIP file? (%d entries!)\n", r_end_part.total_entries);
		fclose(r_zip_fp);
		return false;
	}

	if (fseek(r_zip_fp, r_end_part.dir_offset, SEEK_SET) != 0)
	{
		LogPrintf("ZIPF_OpenRead: cannot seek to directory (at 0x%08x)\n", r_end_part.dir_offset);
		fclose(r_zip_fp);
		return false;
	}

	r_directory = new zip_central_entry_t[r_end_part.total_entries + 1];

	for (int i = 0 ; i < (int)r_end_part.total_entries ; i++)
	{
		zip_central_entry_t *E = &r_directory[i];

		if (! read_directory_entry(E))
		{
			LogPrintf("ZIPF_OpenRead: bad central directory (entry %d)\n", i+1);

			delete[] r_directory;
			r_directory = NULL;

			fclose(r_zip_fp);
			return false;
		}

		// the real start of data is determined at read time
		E->data_offset = -1;

		//  DebugPrintf(" %4d: +%08x %08x : %s\n", i+1, E->hdr.local_offset, E->hdr.full_size, E->name);
	}

	return true; // OK
}


void ZIPF_CloseRead(void)
{
	fclose(r_zip_fp);

	LogPrintf("Closed ZIP file\n");

	delete[] r_directory;
	r_directory = NULL;

	if (r_read_state)
		destroy_read_state();
}


int ZIPF_NumEntries(void)
{
	return (int)r_end_part.total_entries;
}


int ZIPF_FindEntry(const char *name)
{
	for (unsigned int i = 0 ; i < r_end_part.total_entries ; i++)
	{
		if (StringCaseCmp(name, r_directory[i].name) == 0)
			return i;
	}

	return -1; // not found
}


int ZIPF_EntryLen(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < ZIPF_NumEntries());

	return (int)r_directory[entry].hdr.full_size;
}


const char * ZIPF_EntryName(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < ZIPF_NumEntries());

	return r_directory[entry].name;
}


void ZIPF_ListEntries(void)
{
	printf("--------------------------------------------------\n");

	if (r_end_part.total_entries == 0)
	{
		printf("ZIP file is empty\n");
	}
	else
	{
		for (int i = 0 ; i < (int)r_end_part.total_entries ; i++)
		{
			zip_central_entry_t *E = &r_directory[i];

			printf("%4d: +%08x %08x : %s\n", i+1, E->hdr.local_offset, E->hdr.full_size, E->name);
		}
	}

	printf("--------------------------------------------------\n");
}


///////// READING STUFF ///////////////////////////////////////


static void create_read_state(int entry)
{
	zip_central_entry_t *E = &r_directory[entry];

	// TODO: verify the local_offset (check for ZIPF_LOCAL_MAGIC)
	//       could also verify that local fields match the central ones

	// determine offset to the data
	E->data_offset = (int)(E->hdr.local_offset + LOCAL_NAME_OFFSET +
			E->hdr.name_length  + E->hdr.extra_length);

	r_read_state = new zip_read_state_c(entry, E);
}


static void destroy_read_state()
{
	SYS_ASSERT(r_read_state);

	delete r_read_state;
	r_read_state = NULL;
}


static bool decompressing_read(int length, byte *buffer)
{
	//DebugPrintf("decompressing_read: %d\n", length);

	r_read_state->Z.next_out  = buffer;
	r_read_state->Z.avail_out = length;

	while (r_read_state->Z.avail_out > 0)
	{
		if (r_read_state->in_length == 0)
		{
			//    DebugPrintf("  fill buffer...\n");

			if (! r_read_state->Fill())
				return false;
		}

		//  DebugPrintf("  in_position: 0x%08x  in_length: %d\n", r_read_state->in_position, r_read_state->in_length);
		//  DebugPrintf("  avail_in: %u   next_in: +%u\n", r_read_state->Z.avail_in, r_read_state->Z.next_in - r_read_state->in_buffer);
		//  DebugPrintf("  avail_out: %u  next_out: +%u\n", r_read_state->Z.avail_out, r_read_state->Z.next_out - buffer);

		int res = inflate(&r_read_state->Z, Z_NO_FLUSH);

		//  DebugPrintf("  --> res: %d\n", res);
		//  DebugPrintf("  --> avail_in: %u   next_in: +%u\n", r_read_state->Z.avail_in, r_read_state->Z.next_in - r_read_state->in_buffer);
		//  DebugPrintf("  --> avail_out: %u  next_out: +%u\n", r_read_state->Z.avail_out, r_read_state->Z.next_out - buffer);

		// all done?
		if (res == Z_STREAM_END)
			break;

		if (res == Z_BUF_ERROR)
		{
			//    DebugPrintf("  refill buffer...\n");
			r_read_state->Consume();
			r_read_state->Fill();
			continue;
		}

		if (res != Z_OK)
		{
			LogPrintf("ZIP: error occurred during decompression (%d)\n", res);
			return false;
		}
	}

	//DebugPrintf("  OK\n");

	r_read_state->cur_offset += length;

	return true; // OK
}


static bool seek_read_state(int offset)
{
	zip_central_entry_t *E = r_read_state->E;

	// plain fseek for non-compressed files
	if (E->hdr.comp_method == ZIPF_COMP_STORE)
	{
		int res = fseek(r_zip_fp, E->data_offset + offset, SEEK_SET);
		return (res == 0);
	}

	// for compressed stream, only need to handle an unexpected offset
	if (offset == r_read_state->cur_offset)
		return true;

	if (offset < r_read_state->cur_offset)
	{
		// GO BACK TO START
		r_read_state->Reset();
	}

	// how many bytes do we need to skip?
	int count = offset - r_read_state->cur_offset;
	SYS_ASSERT(count >= 0);

	static byte buffer[ZIPF_BUFFER];

	while (count > 0)
	{
		int skip_len = MIN(count, ZIPF_BUFFER);

		if (! decompressing_read(skip_len, buffer))
			return false;

		count -= skip_len;
	}

	return true; // OK
}


bool ZIPF_ReadData(int entry, int offset, int length, void *buffer)
{
	SYS_ASSERT(entry >= 0 && entry < (int)r_end_part.total_entries);
	SYS_ASSERT(offset >= 0);
	SYS_ASSERT(length > 0);

	zip_central_entry_t *E = &r_directory[entry];

	if (E->hdr.comp_method != ZIPF_COMP_STORE &&
			E->hdr.comp_method != ZIPF_COMP_DEFLATE)
	{
		LogPrintf("ZIP: unknown compression method: %d\n", E->hdr.comp_method);
		LogPrintf("ZIP: used in entry: %s\n", E->name);

		return false;
	}

	// need a new read_state for a new entry
	if (! (r_read_state && r_read_state->entry == entry))
	{
		if (r_read_state)
			destroy_read_state();

		create_read_state(entry);
	}

	r_read_state->have_seeked = false;

	// check if enough data left (i.e. EOF)
	if ((u32_t)offset + (u32_t)length > E->hdr.full_size)
		return false;

	// move to where we want to read from
	if (! seek_read_state(offset))
		return false;

	if (E->hdr.comp_method == ZIPF_COMP_STORE)
	{
		// direct read
		int res = fread(buffer, length, 1, r_zip_fp);
		return (res == 1);
	}

	return decompressing_read(length, (byte*) buffer);
}


//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

static std::list<zip_central_entry_t> w_directory;

static zip_local_entry_t w_local;

static int w_local_start;
static int w_local_length;

// common date and time (not swapped)
static int zipf_date;
static int zipf_time;


bool ZIPF_OpenWrite(const char *filename)
{
	w_zip_fp = fopen(filename, "wb");

	if (! w_zip_fp)
	{
		LogPrintf("ZIPF_OpenWrite: cannot create file: %s\n", filename);
		return false;
	}

	LogPrintf("Created ZIP file: %s\n", filename);

	// grab the current date and time
	time_t cur_time = time(NULL);

	struct tm *t = localtime(&cur_time);

	if (t)
	{
		zipf_date = (((t->tm_year - 80) & 0x7f) << 9) |
					(((t->tm_mon  +  1) & 0x0f) << 5) |
					(  t->tm_mday       & 0x1f);

		zipf_time = ((t->tm_hour & 0x1f) << 11) |
					((t->tm_min  & 0x3f) <<  5) |
					((t->tm_sec  & 0x3e) >>  1);
	}
	else
	{
		// fallback
		zipf_date = ((2013 - 1980) << 9) | (3 << 5) | 1;
		zipf_time = (12 << 11) | (34 << 5) | (56 >> 1);
	}

	return true;
}


void ZIPF_CloseWrite(void)
{
	fflush(w_zip_fp);

	// write the directory

	LogPrintf("Writing ZIP directory\n");

	int dir_offset = (int)ftell(w_zip_fp);
	int dir_size   = 0;

	int total_entries = 0;

	std::list<zip_central_entry_t>::iterator ZDI;

	for (ZDI = w_directory.begin() ; ZDI != w_directory.end() ; ZDI++)
	{
		zip_central_entry_t *L = & (*ZDI);

		fwrite(&L->hdr, sizeof(raw_zip_central_header_t), 1, w_zip_fp);
		fwrite(&L->name, strlen(L->name), 1, w_zip_fp);

		dir_size += (int)sizeof(raw_zip_central_header_t);
		dir_size += strlen(L->name);

		total_entries++;
	}

	// write the end-of-directory info

	raw_zip_end_of_directory_t  end_part;

	memcpy(end_part.magic, ZIPF_END_MAGIC, 4);

	end_part.this_disk        = 0;
	end_part.central_dir_disk = 0;
	end_part.comment_length   = 0;

	end_part.disk_entries  = LE_U16(total_entries);
	end_part.total_entries = LE_U16(total_entries);

	end_part.dir_offset = LE_U32(dir_offset);
	end_part.dir_size   = LE_U32(dir_size);

	fwrite(&end_part, sizeof(end_part), 1, w_zip_fp);

	fflush(w_zip_fp);
	fclose(w_zip_fp);

	LogPrintf("Closed ZIP file\n");

	w_zip_fp = NULL;
	w_directory.clear();
}


void ZIPF_NewLump(const char *name)
{
	if (strlen(name)+1 >= ZIPF_MAX_PATH)
		Main_FatalError("ZIPF_NewLump: name too long (>= %d)\n", ZIPF_MAX_PATH);

	// remember position
	w_local_start  = (int)ftell(w_zip_fp);
	w_local_length = 0;

	// setup the zip_local_entry_t fields
	memcpy(w_local.hdr.magic, ZIPF_LOCAL_MAGIC, 4);

	w_local.hdr.req_version = LE_U16(ZIPF_REQ_VERSION);
	w_local.hdr.flags = 0;

	// no compression... yet...
	w_local.hdr.comp_method = LE_U16(ZIPF_COMP_STORE);

	w_local.hdr.file_date = LE_U16(zipf_date);
	w_local.hdr.file_time = LE_U16(zipf_time);

	/* CRC and sizes are fixed up in ZIPF_FinishLump */
	w_local.hdr.crc           = crc32(0, NULL, 0);
	w_local.hdr.compress_size = 0;
	w_local.hdr.full_size     = 0;

	int name_length = strlen(name);

	w_local.hdr.name_length  = LE_U16(name_length);
	w_local.hdr.extra_length = 0;

	strcpy(w_local.name, name);

	fwrite(&w_local.hdr, sizeof(w_local.hdr), 1, w_zip_fp);
	fwrite(&w_local.name, name_length, 1, w_zip_fp);
}


bool ZIPF_AppendData(const void *data, int length)
{
	if (length == 0)
		return true;

	SYS_ASSERT(length > 0);

	if (fwrite(data, length, 1, w_zip_fp) != 1)
		return false;

	// compute the CRC -- use function from zlib
	w_local.hdr.crc = crc32(w_local.hdr.crc, (const Bytef *)data, (uInt)length);

	w_local_length += length;

	return true;
}


void ZIPF_FinishLump(void)
{
	fflush(w_zip_fp);

	w_local.hdr.full_size     = LE_U32(w_local_length);
	w_local.hdr.compress_size = LE_U32(w_local_length);

	// seek back and fix up the CRC and size fields
	fseek(w_zip_fp, w_local_start + LOCAL_CRC_OFFSET, SEEK_SET);

	fwrite(&w_local.hdr.crc,           4, 1, w_zip_fp);
	fwrite(&w_local.hdr.compress_size, 4, 1, w_zip_fp);
	fwrite(&w_local.hdr.full_size,     4, 1, w_zip_fp);

	fflush(w_zip_fp);

	// seek back to end of file
	fseek(w_zip_fp, 0, SEEK_END);

	// create the central entry from the local entry
	zip_central_entry_t  central;

	memcpy(central.hdr.magic, ZIPF_CENTRAL_MAGIC, 4);

	central.hdr.made_version = LE_U16(ZIPF_MADE_VERSION);
	central.hdr.req_version  = w_local.hdr.req_version;

	central.hdr.flags       = w_local.hdr.flags;
	central.hdr.comp_method = w_local.hdr.comp_method;
	central.hdr.file_time   = w_local.hdr.file_time;
	central.hdr.file_date   = w_local.hdr.file_date;

	central.hdr.crc           = w_local.hdr.crc;
	central.hdr.compress_size = w_local.hdr.compress_size;
	central.hdr.full_size     = w_local.hdr.full_size;

	central.hdr.name_length    = w_local.hdr.name_length;
	central.hdr.extra_length   = 0;
	central.hdr.comment_length = 0;

	central.hdr.start_disk      = 0;
	central.hdr.internal_attrib = 0;
	central.hdr.external_attrib = LE_U32(ZIPF_ATTRIB_NORMAL);

	central.hdr.local_offset = LE_U32(w_local_start);

	strcpy(central.name, w_local.name);

	w_directory.push_back(central);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
