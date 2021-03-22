//----------------------------------------------------------------------------
//
// File:		wad.cpp
// Date:		26-Oct-1994
// Programmer:  Marc Rousseau
//
// Description: Object classes for manipulating Doom WAD files
//
// Copyright (c) 1994-2004 Marc Rousseau, All Rights Reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
//
// Revision History:
//
//   04-25-01	Added little/big endian conversions
//
//----------------------------------------------------------------------------

/* 2017 Zokum changes
 * 26.07: Adding comments, changing formatting, removing spurious dos 
 * characters. All if/else statements should use brackets.
 */

#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _MSC_VER
	#include <string.h>
	#define strncasecmp _strnicmp
	#define strcasecmp _stricmp
#else
	#include <strings.h>
#endif

#include <sys/stat.h>
#include "common.hpp"
#include "wad.hpp"
#include "level.hpp"

#if defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )
	#include <unistd.h>
	#define stricmp strcasecmp
	#define TEMP_DIR		"TMPDIR="
#else
	#include <io.h>
	#if ! defined ( _MSC_VER )
		#include <dir.h>
	#endif
	#include <sys\stat.h>
	#define TEMP_DIR		"TMP="
#endif

/*
int		 WAD::sm_NoFilters;
wadFilter **WAD::sm_Filter;
*/

static int _init () {
	if ( sizeof ( wadHeader ) != 12 ) {
		fprintf ( stderr, "sanity check: sizeof ( %s ) = %ld (expected %d)\n", "wadHeader", sizeof ( wadHeader ), 12 );
	}
	if ( sizeof ( wadDirEntry ) != 16 ) {
		fprintf ( stderr, "sanity check: sizeof ( %s ) = %ld (expected %d)\n", "wadDirEntry", sizeof ( wadDirEntry ), 16 );
	}
	return 0;
}

static int foo = _init ();


#if defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )
        void _fullpath ( char *full, const char *name, int max );
#endif

/*
#if defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )
	void _fullpath ( char *full, const char *name, int max ) {
		strncpy ( full, name, max );
	}
#endif
*/

#if defined ( VISUAL_STUDIO )

	int mkstemp ( char *filename ) {
		if ( filename == NULL ) return -1;

		size_t len = strlen ( filename );
		if ( len < 6 ) return -1;

		char *basePtr = filename + len - 6;
		for ( int i = 0; i < 6; i++ ) if ( basePtr [i] != 'X' ) return -1;

		int handle = -1;
		while ( handle == -1 ) {
			char *ptr = basePtr;
			for ( int i = 0; i < 6; i++ ) {
				int x = rand () % 62;
				if ( x >= 52 ) { ptr [i] = '0' + x - 52; continue; }
				if ( x >= 26 ) { ptr [i] = 'A' + x - 26; continue; }
				ptr [i] = 'a' + x;
			}
			handle = open ( filename, O_CREAT | O_EXCL | O_RDWR | O_BINARY, S_IRUSR | S_IWUSR );
		}
		return handle;
	}

#endif

#if ( BYTE_ORDER == BIG_ENDIAN )
	UINT32 swap_uint32 ( const unsigned char *ptr ) {
		UINT32 res = ptr [3];
		res = ( res << 8 ) | ptr [2];
		res = ( res << 8 ) | ptr [1];
		res = ( res << 8 ) | ptr [0];
		return res;
	}

	UINT16 swap_uint16 ( const unsigned char *ptr ) {
		UINT16 res = ptr [1];
		res = ( res << 8 ) | ptr [0];
		return res;
	}
#endif

/*
WAD::WAD ( const char *filename ) :
	m_Name ( NULL ),
	m_File ( NULL ),
	m_List ( NULL ),
	m_bValid ( false ),
	m_bRegistered ( false ),
	m_bDirChanged ( false ),
	m_Directory ( NULL ),
	m_DirInfo ( NULL ),
	m_Status ( ws_UNKNOWN ),
	m_Type ( wt_UNKNOWN ),
	m_Style ( wst_UNKNOWN ),
	m_MapStart ( NULL ),
	m_MapEnd ( NULL ),
	m_SpriteStart ( NULL ),
	m_SpriteEnd ( NULL ),
	m_PatchStart ( NULL ),
	m_PatchEnd ( NULL ),
	m_FlatStart ( NULL ),
	m_FlatEnd ( NULL ),
	m_NewData ( NULL ) {
		m_Name = ( filename != NULL ) ? strdup ( filename ) : strdup ( "" );

		memset ( &m_Header, 0, sizeof ( m_Header ));

		if ( filename != NULL ) {
			OpenFile ();
		}
	}

WAD::~WAD () {
	CloseFile ();

	free ( m_Name );
}

bool WAD::EnlargeDirectory ( int holePos, int entries ) {
	int newSize = m_Header.dirSize + entries;

	wadDirEntry *newDir = new wadDirEntry [ newSize ];
	wadDirInfo *newInfo = new wadDirInfo [ newSize ];

	if (( newDir == NULL ) || ( newInfo == NULL )) {
		if ( newDir != NULL ) {
			delete [] newDir;
		}
		if ( newInfo != NULL ) { 
			delete [] newInfo;
		}
		return false;
	}

	int loCount = holePos;
	int hiCount = m_Header.dirSize - holePos;

	memset ( newDir, 0, sizeof ( wadDirEntry ) * newSize );
	memset ( newInfo, 0, sizeof ( wadDirInfo ) * newSize );

	memcpy ( newDir, m_Directory, sizeof ( wadDirEntry ) * loCount );
	memcpy ( newDir + loCount + entries, m_Directory + loCount, sizeof ( wadDirEntry ) * hiCount );

	memcpy ( newInfo, m_DirInfo, sizeof ( wadDirInfo ) * loCount );
	memcpy ( newInfo + loCount + entries, m_DirInfo + loCount, sizeof ( wadDirInfo ) * hiCount );

	if ( m_Directory != NULL ) {
		delete [] m_Directory;
	}

	m_Directory = newDir;

	if ( m_DirInfo != NULL ) {
		delete [] m_DirInfo;
	}

	m_DirInfo = newInfo;

	m_Header.dirSize = newSize;
	FindMarkers ();

	return true;
}

bool WAD::ReduceDirectory ( int holePos, int entries ) {
	if ( holePos + entries > ( int ) m_Header.dirSize ) {
		entries = m_Header.dirSize - holePos;
	}

	int hiCount = m_Header.dirSize - ( holePos + entries );

	if ( hiCount > 0 ) {
		memcpy ( m_Directory + holePos, m_Directory + holePos + entries, sizeof ( wadDirEntry ) * hiCount );
		memcpy ( m_DirInfo + holePos, m_DirInfo + holePos + entries, sizeof ( wadDirInfo ) * hiCount );
	}
	m_Header.dirSize -= entries;

	if ( m_List != NULL ) {
		m_List->UpdateDirectory ();
	}

	return true;
}

void WAD::FindMarkers () {
	m_MapStart = m_MapEnd = NULL;
	UINT32 s;
	for ( s = 0; s < m_Header.dirSize; s++ ) {
		if ( IsMap ( m_Directory [s].name )) {
			m_MapStart = &m_Directory [s];
			break;
		}
	}
	for ( UINT32 e = m_Header.dirSize - 1; e >= s; e-- ) {
		if ( IsMap ( m_Directory [e].name )) {
			m_MapEnd = &m_Directory [e];
			break;
		}
	}

	if ( m_MapEnd != NULL ) {
		m_MapEnd += 10;
	}

	m_SpriteStart = FindDir ( "S_START" );
	m_SpriteEnd   = FindDir ( "S_END", m_SpriteStart );

	m_PatchStart  = FindDir ( "P_START" );
	m_PatchEnd	= FindDir ( "P_END", m_PatchStart );

	m_FlatStart   = FindDir ( "F_START" );
	m_FlatEnd	 = FindDir ( "F_END", m_FlatStart );
}

bool WAD::ReadHeader ( wadHeader *header ) {
	ReadBytes ( header, sizeof ( wadHeader ));

#if ( BYTE_ORDER == BIG_ENDIAN )
	header->dirSize  = swap_uint32 (( UINT8 * ) &header->dirSize );
	header->dirStart = swap_uint32 (( UINT8 * ) &header->dirStart );
#endif

	if ( ! IS_TYPE ( header->type, IWAD_ID ) && ! IS_TYPE ( header->type, PWAD_ID )) {
		fprintf ( stderr, "Invalid WAD header type '%4.4s' (expected '%4.4s' or '%4.4s')\n", header->type, (char*) &IWAD_ID, (char*) &PWAD_ID );
		return false;
	}

	return true;
}

bool WAD::WriteHeader ( FILE *file, wadHeader *header ) {
#if ( BYTE_ORDER == BIG_ENDIAN )
	wadHeader temp = *header;

	temp.dirSize  = swap_uint32 (( UINT8 * ) &temp.dirSize );
	temp.dirStart = swap_uint32 (( UINT8 * ) &temp.dirStart );

	header = &temp;
#endif

	return ( fwrite ( header, sizeof ( wadHeader ), 1, file ) == 1 ) ? true : false;
}

bool WAD::ReadDirEntry ( wadDirEntry *entry ) {
	ReadBytes ( entry, sizeof ( wadDirEntry ), 1 );

#if ( BYTE_ORDER == BIG_ENDIAN )
	entry->offset = swap_uint32 (( UINT8 * ) &entry->offset );
	entry->size   = swap_uint32 (( UINT8 * ) &entry->size );
#endif

	return true;
}

bool WAD::WriteDirEntry ( FILE *file, wadDirEntry *entry ) {
#if ( BYTE_ORDER == BIG_ENDIAN )
	wadDirEntry temp = *entry;

	temp.offset = swap_uint32 (( UINT8 * ) &temp.offset );
	temp.size   = swap_uint32 (( UINT8 * ) &temp.size );

	entry = &temp;
#endif

	return ( fwrite ( entry, sizeof ( wadDirEntry ), 1, file ) == 1 ) ? true : false;
}

bool WAD::ReadDirectory () {
	if ( m_Directory != NULL ) {
		delete [] m_Directory;
	}

	m_DirInfo = new wadDirInfo [ m_Header.dirSize ];

	for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
		m_DirInfo [i].newData   = NULL;
		m_DirInfo [i].cacheData = NULL;
		m_DirInfo [i].type	  = wl_UNCHECKED;
	}

	Seek ( m_Header.dirStart );

	m_Directory = new wadDirEntry [ m_Header.dirSize ];

	for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
		ReadDirEntry ( &m_Directory [i] );
	}

	FindMarkers ();

	return true;
}

bool WAD::WriteDirectory ( FILE *file ) {
	for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
		if ( WriteDirEntry ( file, &m_Directory [i] ) == false ) {
			return false;
		}
	}

	return true;
}

UINT32 WAD::IndexOf ( const wadDirEntry *entry ) const {
	return (( entry < m_Directory ) || ( entry > m_Directory + m_Header.dirSize )) ? -1 : entry - m_Directory;
}

void WAD::SetList ( wadList *_list ) {
	m_List = _list;
}

*/

/*
 * This function is horrible! It desperatly needs a rewrite to fix e5mX bugs for Heretic
 * and more modern less constrained doom ports that do not follow these naming conventions
 * at all!. Should also support eXm10 etc ala early doom versions.
 */


/*
bool WAD::IsMap ( const char *name ) {
	if ( name == NULL ) { 
		return false;
	}
	if (( name[0] != 'M' ) && ( name[0] != 'E' )) {
		return false;
	}

	if ( strncmp ( name, "MAP", 3 ) == 0 ) {
		if ( isdigit ( name[3] ) == false ) return false;
		if ( isdigit ( name[4] ) == false ) return false;
		if ( name[5] != '\0' ) return false;
		int level;
		if ( sscanf ( name+3, "%d", &level ) == 0 ) return false;
		return (( level >= 1 ) && ( level <= 99 )) ? true : false;
	}
	if (( name[0] == 'E' ) && ( name[2] == 'M' )) {
		int episode = name[1], mission = name[3];
		if (( episode < '1' ) || ( episode > '4' )) {
			return false;
		}
		if (( mission < '1' ) || ( mission > '9' )) {
			return false;
		}
		if ( name[4] != '\0' ) {
			return false;
		}
		return true;
	}
	return false;
}

UINT32 WAD::FileSize () const {
	UINT32 totalSize = sizeof ( wadHeader );

	for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
		totalSize += sizeof ( wadDirEntry ) + m_Directory [i].size;
	}

	return totalSize;
}

bool WAD::AddFilter ( wadFilter *newFilter ) {
	wadFilter **newList = new wadFilter * [ sm_NoFilters + 1 ];

	if ( sm_Filter != NULL ) {
		memcpy ( newList, sm_Filter, sizeof ( wadFilter * ) * sm_NoFilters );
		delete [] sm_Filter;
	}

	sm_Filter = newList;
	sm_Filter [ sm_NoFilters++ ] = newFilter;

	return true;
}

bool WAD::HasChanged ( const wadDirEntry *entry ) const {
	UINT32 index = IndexOf ( entry );
	return ( index == ( UINT32 ) -1 ) ? false : m_DirInfo [ index ].newData ? true : false;
}

void WAD::Seek ( UINT32 offset ) {
	m_Status = ws_OK;
	if ( m_File == NULL ) {
		m_Status = ws_INVALID_FILE;
	} else if ( fseek ( m_File, offset, SEEK_SET )) {
		m_Status = ws_SEEK_ERROR;
	}
}

void WAD::ReadBytes ( void *ptr , UINT32 size, UINT32 count ) {
	m_Status = ws_OK;
	if ( m_File == NULL ) {
		m_Status = ws_INVALID_FILE;
	} else if ( fread ( ptr, count, size, m_File ) != size ) {
		m_Status = ws_READ_ERROR;
	}
}

void *WAD::ReadEntry ( const char *name, UINT32 *size, const wadDirEntry *start, const wadDirEntry *end, bool cache ) {
	return ReadEntry ( FindDir ( name, start, end ), size, cache );
}

void *WAD::ReadEntry ( const wadDirEntry *entry, UINT32 *size, bool cache ) {
	char *buffer = NULL;
	if ( size ) {
		*size = 0;
	}
	UINT32 index = IndexOf ( entry );
	if ( index != ( UINT32 ) -1 ) {
		buffer = new char [ entry->size + 1 ];
		if ( size ) {
			*size = entry->size;
		}
		if ( m_DirInfo [ index ].newData ) {
			memcpy ( buffer, m_DirInfo [ index ].newData, entry->size );
		} else if ( m_DirInfo [ index ].cacheData ) {
			memcpy ( buffer, m_DirInfo [ index ].cacheData, entry->size );
		} else {
			Seek ( entry->offset );
			if ( m_Status == ws_OK ) {
				ReadBytes ( buffer, entry->size );
			}
			if ( cache ) {
				m_DirInfo [ index ].cacheData = new UINT8 [ entry->size + 1 ];
				memcpy ( m_DirInfo [ index ].cacheData, buffer, entry->size );
				m_DirInfo [ index ].cacheData [ entry->size ] = '\0';
			}
		}
		buffer [ entry->size ] = '\0';
	}
	return ( void * ) buffer;
}

bool WAD::WriteEntry ( const char *name, UINT32 newSize, void *newStuff, bool owner, const wadDirEntry *start, const wadDirEntry *end ) {
	const wadDirEntry *entry = FindDir ( name, start, end );
	return WriteEntry ( entry, newSize, newStuff, owner );
}

bool WAD::WriteEntry ( const wadDirEntry *entry, UINT32 newSize, void *newStuff, bool owner ) {
	UINT32 index = IndexOf ( entry );
	if ( index == ( UINT32 ) -1 ) {
		return false;
	}

	if ( newSize && ( newSize == entry->size )) {
		// printf("same size\n");
		char *oldStuff = ( char * ) ReadEntry ( entry, NULL );
		if ( memcmp ( newStuff, oldStuff, newSize ) == 0 ) {
			delete [] oldStuff;
			if ( owner == true ) { 
				delete [] ( char * ) newStuff;
			}
			return false;
		}
		delete [] oldStuff;
	} else {
		// printf("not same %d %d %s\n", newSize, entry->size, (char *) entry->name);
	}

	UINT8 *temp = ( UINT8 * ) newStuff;
	if ( owner == false ) {
		temp = new UINT8 [ newSize ];
		// printf("copying... %d\n", newSize);
		memcpy ( temp, newStuff, newSize );
	}
	if ( m_DirInfo [ index ].cacheData ) {
		delete m_DirInfo [ index ].cacheData;
		m_DirInfo [ index ].cacheData = NULL;
	}

	// printf("index is %d\n", index);

	m_DirInfo [ index ].newData = temp;
	m_Directory [ index ].size = newSize;
	m_Directory [ index ].offset = ( UINT32 ) -1;

	return true;
}

void WAD::OpenFile () {
	if ( m_File != NULL ) {
		fclose ( m_File );
	}
	m_File = NULL;

	int handle = open ( m_Name, O_RDONLY );
	if ( handle < 0 ) {
		m_Status = ( errno == ENOENT ) ? ws_INVALID_FILE : ws_CANT_READ;
		return;
	} else {
		close ( handle );
	}

	if (( m_File = fopen ( m_Name, "rb" )) == NULL ) {
		m_Status = ws_INVALID_FILE;
		return;
	}

	// Read in the WAD's header
	if ( ReadHeader ( &m_Header ) == false ) {
		m_Status = ws_INVALID_WAD;
		return;
	}
	m_Status = ws_OK;

	// Read in the WAD's directory info
	m_bValid = true;
	ReadDirectory ();

	if ( FindDir ( "TEXTURE2" )) {
		m_bRegistered = true;
	}

	if ( FindDir ( "BEHAVIOR" )) {
		m_Type = wt_HEXEN;
	}
	else if ( FindDir ( "M_HTIC" )) {
		m_Type = wt_HERETIC;
	}
	else if ( FindDir ( "SHT2A0" )) {
		m_Type = wt_DOOM2;
	}

	switch ( m_Type ) {
		case wt_DOOM	: m_Style = wst_FORMAT_1;	break;
		case wt_DOOM2   : m_Style = wst_FORMAT_2;	break;
		case wt_HERETIC : m_Style = wst_FORMAT_1;	break;
		case wt_HEXEN   : m_Style = wst_FORMAT_3;	break;
		default :
				  if ( m_MapStart != NULL ) {
					  m_Style = ( toupper ( m_MapStart->name[0] ) == 'E' ) ? wst_FORMAT_1 : wst_FORMAT_2;
				  }
	}
	if ( m_Type == wt_UNKNOWN ) {
		if ( m_Style == wst_FORMAT_2 ) {
			m_Type = wt_DOOM2;
		}
	}
}

void WAD::CloseFile () {
	m_bValid	  = false;
	m_bRegistered = false;
	m_bDirChanged = false;

	if ( m_DirInfo != NULL ) {
		for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
			if ( m_DirInfo [i].newData ) delete [] ( char * ) m_DirInfo [i].newData;
			m_DirInfo [i].newData = NULL;
			if ( m_DirInfo [i].cacheData ) delete [] ( char * ) m_DirInfo [i].cacheData;
			m_DirInfo [i].cacheData = NULL;
			m_DirInfo [i].type = wl_UNCHECKED;
		}
		delete [] m_DirInfo;
	}
	m_DirInfo = NULL;

	if ( m_Directory != NULL ) {
		delete [] m_Directory;
	}
	m_Directory = NULL;

	m_MapStart = m_MapEnd = NULL;

	if ( m_File != NULL ) {
		fclose ( m_File );
	}
	m_File = NULL;

	memset ( &m_Header, 0, sizeof ( m_Header ));
}

const wadDirEntry *WAD::GetDir ( UINT32 index ) const {
	return ( index >= m_Header.dirSize ) ? ( const wadDirEntry * ) NULL : &m_Directory [index];
}

const wadDirEntry *WAD::FindDir ( const char *name, const wadDirEntry *start, const wadDirEntry *end ) const {
	UINT32 i = 0, last = m_Header.dirSize - 1;
	if ( start != NULL ) {
		UINT32 index = IndexOf ( start );
		if ( index == ( UINT32 ) -1 ) {
			return NULL;
		}
		if ( index > i ) {
			i = index;
		}
	}
	if ( end != NULL ) {
		UINT32 index = IndexOf ( end );
		if ( index == ( UINT32 ) -1 ) {
			return NULL;
		}
		if ( index < last ) {
			last = index;
		}
	}
	const wadDirEntry *dir = &m_Directory [i];
	for ( ; i <= last; i++, dir++ ) {
		if ( dir->name[0] != name[0] ) {
			continue;
		}
		if ( strncmp ( dir->name, name, 8 ) == 0 ) {
			return dir;
		}
	}
	return NULL;
}

bool WAD::HasChanged () const {
	if ( m_bDirChanged ) {
		return true;
	}

	bool changed = false;
	for ( UINT32 i = 0; ! changed && ( i < m_Header.dirSize ); i++ ) {
		if ( m_DirInfo [i].newData ) {
			changed = true;
			printf("found new data\n");
		}
	}
	if (!changed) {
		printf("no new data\n");
	}

	return changed;
}

bool WAD::InsertBefore ( const wLumpName *name, UINT32 newSize, void *newStuff, bool owner, const wadDirEntry *entry ) {
	UINT32 index = IndexOf ( entry );
	if ( entry && ( index == ( UINT32 ) -1 )) {
		return false;
	}

	if ( entry == NULL ) {
		index = 0;
	}
	if ( ! EnlargeDirectory ( index, 1 )) {
		return false;
	}

	wadDirEntry *newDir = &m_Directory [ index ];
	strncpy ( newDir->name, ( char * ) name, sizeof ( wLumpName ));

	bool retVal = WriteEntry ( newDir, newSize, newStuff, owner );

	if ( m_List != NULL ) {
		m_List->UpdateDirectory ();

	} else {
		printf("directory was null\n");
	}

	return retVal;
}

bool WAD::InsertAfter ( const wLumpName *name, UINT32 newSize, void *newStuff, bool owner, const wadDirEntry *entry ) {
	UINT32 index = IndexOf ( entry );
	if ( entry && ( index == ( UINT32 ) -1 )) {
		return false;
	}

	if ( entry == NULL ) {
		index = m_Header.dirSize;
	} else {
		index += 1;
	}

	if ( ! EnlargeDirectory ( index, 1 )) {
		return false;
	}

	wadDirEntry *newDir = &m_Directory [ index ];
	strncpy ( newDir->name, ( char * ) name, sizeof ( wLumpName ));

	bool retVal = WriteEntry ( newDir, newSize, newStuff, owner );

	if ( m_List != NULL ) {
		m_List->UpdateDirectory ();
	}

	return retVal;
}

bool WAD::Remove ( const wLumpName *lump, const wadDirEntry *start, const wadDirEntry *end ) {
	const wadDirEntry *entry = FindDir ( *lump, start, end );

	UINT32 index = IndexOf ( entry );
	if ( index == ( UINT32 ) -1 ) {
		return false;
	}

	return ReduceDirectory ( index, 1 );
}
*/

/*
// TBD
int  InsertBefore ( const wLumpName *, UINT32, void *, bool, const wadDirEntry * = NULL );
int  InsertAfter ( const wLumpName *, UINT32, void *, bool, const wadDirEntry * = NULL );
// TBD
*/

/*
bool WAD::SaveFile ( const char *newName ) {
	if ( newName == NULL ) {
		newName = m_Name;
	}
	const char *tempName = newName;

	char wadPath [MAXPATH], newPath [MAXPATH], tmpPath [MAXPATH];
	_fullpath ( wadPath, m_Name, MAXPATH );
	_fullpath ( newPath, newName, MAXPATH );

	FILE *tmpFile = NULL;

	// if ( strcasecamp ( wadPath, newPath ) == 0 ) {
	if ( strcasecmp ( wadPath, newPath ) == 0 ) {
		if ( HasChanged () == false ) {
			return true;
		}
		sprintf ( tmpPath, "%s.XXXXXX", newPath );
#if defined _WIN32 && !defined __MINGW32__
		// #ifdef _WIN32 
		int tmp = _mktemp_s( tmpPath );
#else
		int tmp = mkstemp(tmpPath);
#endif
		if ( tmp == -1 ) {
			fprintf ( stderr, "\nERROR: WAD::SaveFile - Error creating temporary file." );
			return false;
		}
		tempName = tmpPath;
		tmpFile  = fdopen ( tmp, "wb" );
	}

	if ( tmpFile == NULL ) {
		tmpFile = fopen ( tempName, "wb" );
	}

	if ( tmpFile == NULL ) {
		return false;
	}

	bool errors = false;
	if ( fwrite ( &m_Header, sizeof ( m_Header ), 1, tmpFile ) != 1 ) {
		fprintf ( stderr, "ERROR: WAD::SaveFile - Error writing dummy header.\n" );
		errors = true;
	}

	wadDirEntry *dir = m_Directory;
	for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
		UINT32 offset = ftell ( tmpFile );
		if ( dir->size ) {
			if ( m_DirInfo [i].newData ) {
				if ( fwrite ( m_DirInfo [i].newData, dir->size, 1, tmpFile ) != 1 ) {
					fprintf ( stderr, "ERROR: WAD::SaveFile - Error writing entry %8.8s. (newData)\n", dir->name );
					errors = true;
				}
			} else if ( m_DirInfo [i].cacheData ) {
				if ( fwrite ( m_DirInfo [i].cacheData, dir->size, 1, tmpFile ) != 1 ) {
					fprintf ( stderr, "ERROR: WAD::SaveFile - Error writing entry %8.8s. (cached)\n", dir->name );
					errors = true;
				}
			} else {
				char *ptr = ( char * ) ReadEntry ( dir, NULL );
				if ( m_Status != ws_OK ) {
					fprintf ( stderr, "ERROR: WAD::SaveFile - Error reading entry %8.8s. (%04x)\n", dir->name, m_Status );
					errors = true;
				}
				if ( fwrite ( ptr, dir->size, 1, tmpFile ) != 1 ) {
					fprintf ( stderr, "ERROR: WAD::SaveFile - Error writing entry %8.8s. (file copy)\n", dir->name );
					errors = true;
				}
				delete [] ptr;
			}
		}
		dir->offset = offset;
		dir++;
	}

	m_Header.dirStart = ftell ( tmpFile );

	if ( WriteDirectory ( tmpFile ) == false ) {
		fprintf ( stderr, "\nERROR: WAD::SaveFile - Error writing directory." );
		errors = true;
	}

	fseek ( tmpFile, 0, SEEK_SET );

	if ( WriteHeader ( tmpFile, &m_Header ) == false ) {
		fprintf ( stderr, "\nERROR: WAD::SaveFile - Error writing header." );
		errors = true;
	}

	fclose ( tmpFile );

	if ( errors == true ) {
		remove ( tempName );
		return false;
	}
	// stri fix
	if ( strcasecmp ( wadPath, newPath ) == 0 ) {
		if ( m_File != NULL ) {
			fclose ( m_File );
		}
		if ( remove ( m_Name ) != 0 ) {
			fprintf ( stderr, "\nERROR: WAD::SaveFile - Unable to remove %s.", m_Name );
			return false;
		}
		if ( rename ( tempName, m_Name ) != 0 ) {
			fprintf ( stderr, "\nERROR: WAD::SaveFile - Unable to rename %s to %s.", tempName, m_Name );
			return false;
		}
		m_File = fopen ( m_Name, "rb" );
	}

	for ( UINT32 i = 0; i < m_Header.dirSize; i++ ) {
		if ( m_DirInfo [i].newData ) {
			if ( m_DirInfo [i].cacheData ) delete m_DirInfo [i].cacheData;
			m_DirInfo [i].cacheData = m_DirInfo [i].newData;
			m_DirInfo [i].newData = NULL;
		}
	}

	return true;
}
*/

wadList::wadList () :
	m_DirSize ( 0 ),
	m_MaxSize ( 0 ),
	m_Directory ( NULL ),
	m_Type ( wt_UNKNOWN ),
	m_Style ( wst_UNKNOWN ),
	m_List ( NULL ) {
	}

wadList::~wadList () {
	while ( m_List != NULL ) {
		wadListEntry *temp = m_List->Next;
		delete m_List->wad;
		delete m_List;
		m_List = temp;
	}

	if ( m_Directory != NULL ) {
		delete [] m_Directory;
	}
}

int wadList::wadCount () const {
	int size = 0;

	wadListEntry *ptr = m_List;
	while ( ptr != NULL ) {
		size++;
		ptr = ptr->Next;
	}

	return size;
}

UINT32 wadList::FileSize () const {
	UINT32 totalSize = sizeof ( wadHeader );

	for ( UINT32 i = 0; i < m_DirSize; i++ ) {
		totalSize += sizeof ( wadDirEntry ) + m_Directory [i].entry->size;
	}

	return totalSize;
}

WAD *wadList::GetWAD ( int index ) const {
	wadListEntry *ptr = m_List;
	while ( ptr && index-- ) ptr = ptr->Next;
	return ptr ? ptr->wad : NULL;
}

void wadList::Clear () {
	wadListEntry *ptr = m_List;
	while ( ptr ) {
		wadListEntry *next = ptr->Next;
		delete ptr->wad;
		delete ptr;
		ptr = next;
	}
	if ( m_Directory != NULL ) {
		delete [] m_Directory;
	}

	m_DirSize   = 0;
	m_MaxSize   = 0;
	m_Directory = NULL;
	m_List	  = NULL;
	m_Type	  = wt_UNKNOWN;
	m_Style	 = wst_UNKNOWN;
}

void wadList::UpdateDirectory () {
	m_DirSize = 0;

	wadListEntry *ptr = m_List;
	while ( ptr != NULL ) {
		AddDirectory ( ptr->wad );
		ptr = ptr->Next;
	}
}

bool wadList::Add ( WAD *wad ) {
	if (( m_Type == wt_UNKNOWN ) && ( m_Style == wst_UNKNOWN )) {
		m_Type = wad->Type ();
		m_Style = wad->Style ();
	}

	if (( m_Type != wt_UNKNOWN ) && ( wad->Type () == wt_UNKNOWN ) 
			&& ( wad->Format () == PWAD_ID )) {
		const wadDirEntry *dir = wad->FindDir ( "SECTORS" );
		if ( dir != NULL ) {
			UINT32 temp;
			wSector *sector = ( wSector * ) wad->ReadEntry ( dir, &temp, true );
			int noSectors = temp / sizeof ( wSector );
			char tempName [ MAX_LUMP_NAME + 1 ]; 
			tempName [ MAX_LUMP_NAME ] = '\0';
			int i;
			for ( i = 0; i < noSectors; i++ ) {
				strncpy ( tempName, sector[i].floorTexture, MAX_LUMP_NAME );
				if ( FindWAD ( tempName ) == NULL ) break;
				strncpy ( tempName, sector[i].ceilTexture, MAX_LUMP_NAME );
				if ( FindWAD ( tempName ) == NULL ) break;
			}
			if ( i == noSectors ) wad->Type ( m_Type );
			delete [] ( char * ) sector;
		}
	}

	if ( m_Type != wad->Type ()) {
		return false;
	}
	if ( m_Style != wad->Style ()) {
		return false;
	}

	wadListEntry *newNode = new wadListEntry;
	newNode->wad = wad;
	newNode->Next = NULL;

	if ( m_List == NULL ) {
		m_List = newNode;
	} else {
		wadListEntry *ptr = m_List;
		while ( ptr->Next != NULL ) {
			ptr = ptr->Next;
		}
		ptr->Next = newNode;
	}

	AddDirectory ( wad, m_List->Next ? true : false );

	wad->SetList ( this );

	return true;
}

bool wadList::Remove ( WAD *wad ) {	
	bool found = false;
	wadListEntry *ptr = m_List;

	if ( m_List->wad == wad ) {
		found = true;
		m_List = m_List->Next;
		delete ptr;
	} else {
		while ( ptr->Next != NULL ) {
			if ( ptr->Next->wad == wad ) {
				found = true;
				wadListEntry *next = ptr->Next->Next;
				delete ptr->Next;
				ptr->Next = next;
				break;
			}
			ptr = ptr->Next;
		}
	}

	if ( found ) {
		wad->SetList ( NULL );
		m_DirSize = 0;
		ptr = m_List;
		while ( ptr != NULL ) {
			AddDirectory ( ptr->wad );
			ptr = ptr->Next;
		}
	}

	if ( m_DirSize == 0 ) {
		m_Type = wt_UNKNOWN;
	}

	return found;
}

UINT32 wadList::IndexOf ( const wadListDirEntry *entry ) const {
	return (( entry < m_Directory ) || ( entry > m_Directory + m_DirSize )) ? -1 : entry - m_Directory;
}

int wadList::AddLevel ( UINT32 index, const wadDirEntry *&entry, WAD *wad ) {
	int size = 0;
	const wadDirEntry *start = entry + 1;
	const wadDirEntry *end   = entry + 11;

	if ( wad->FindDir ( "THINGS",	start, end )) size++;
	if ( wad->FindDir ( "LINEDEFS",  start, end )) size++;
	if ( wad->FindDir ( "SIDEDEFS",  start, end )) size++;
	if ( wad->FindDir ( "VERTEXES",  start, end )) size++;
	if ( wad->FindDir ( "SEGS",	  start, end )) size++;
	if ( wad->FindDir ( "SSECTORS",  start, end )) size++;
	if ( wad->FindDir ( "NODES",	 start, end )) size++;
	if ( wad->FindDir ( "SECTORS",   start, end )) size++;
	if ( wad->FindDir ( "REJECT",	start, end )) size++;
	if ( wad->FindDir ( "BLOCKMAP",  start, end )) size++;
	if ( wad->FindDir ( "BEHAVIOR",  start, end )) size++;

	if ( index == m_DirSize ) {
		m_DirSize += size;
		for ( int i = 0; i < size; i++ ) {
			m_Directory [ index ].wad   = wad;
			m_Directory [ index ].entry = ++entry;
			index++;
		}
	} else {
		for ( int i = 0; i < size; i++ ) {
			/* TBD proper replacement of level lumps
			   const wadListDirEntry *entry = FindWAD ( entry[1].name, index, index + 10 );
			   UINT32 index = IndexOf ( entry );
			   */
			m_Directory [ index ].wad   = wad;
			m_Directory [ index ].entry = ++entry;
			index++;
		}
	}

	return size;
}

void wadList::AddDirectory ( WAD *wad, bool check ) {
	// Make sure AddDirectory has enough room to work
	if ( m_DirSize + wad->DirSize () > m_MaxSize ) {
		m_MaxSize = m_DirSize + wad->DirSize ();
		wadListDirEntry *temp = new wadListDirEntry [ m_MaxSize ];
		if ( m_Directory != NULL ) {
			memcpy ( temp, m_Directory, sizeof ( wadListDirEntry ) * m_DirSize );
			delete [] m_Directory;
		}   
		m_Directory = temp;
	}

	const wadDirEntry *newDir = wad->GetDir ( 0 );
	UINT32 count = wad->DirSize ();
	while ( count ) {
		const wadListDirEntry *entry = check ? FindWAD ( newDir->name ) : NULL;
		if ( entry != NULL ) {
			UINT32 index = IndexOf ( entry );
			m_Directory [ index ].wad = wad;
			m_Directory [ index ].entry = newDir;
			if ( WAD::IsMap ( newDir->name )) {
				count -= AddLevel ( index + 1, newDir, wad );
			}
		} else {
			UINT32 index = m_DirSize++;
			m_Directory [ index ].wad = wad;
			m_Directory [ index ].entry = newDir;
			if ( WAD::IsMap ( newDir->name )) {
				count -= AddLevel ( index + 1, newDir, wad );
			}
		}
		newDir++;
		count--;
	}
}

const wadListDirEntry *wadList::GetDir ( UINT32 index ) const {
	return ( index >= m_DirSize ) ? ( const wadListDirEntry * ) NULL : &m_Directory [index];
}

const wadListDirEntry *wadList::FindWAD ( const char *name, const wadListDirEntry *start, const wadListDirEntry *end ) const {
	UINT32 i = 0, last = m_DirSize;

	if ( start != NULL ) {
		i = IndexOf ( start );
	}
	if ( end != NULL ) {
		last = IndexOf ( end );
	}


	for ( ; i < last; i++ ) {
		const wadListDirEntry *dir = &m_Directory [i];
		// printf("%d Comparing %s to %s\n", i, dir->entry->name, name);
		if ( dir->entry->name[0] != name[0] ) {
			continue;
		}
		if ( strncmp ( dir->entry->name, name, 8 ) == 0 ) {
			return dir;
		}
	}
	return NULL;
}

bool wadList::HasChanged () const {
	wadListEntry *ptr = m_List;
	while ( ptr != NULL ) {
		if ( ptr->wad->HasChanged ()) {
			return true;
		}
		ptr = ptr->Next;
	}
	return false;
}

bool wadList::Contains ( WAD *wad ) const {
	wadListEntry *ptr = m_List;
	while ( ptr != NULL ) {
		if ( ptr->wad == wad ) {
			return true;
		}
		ptr = ptr->Next;
	}
	return false;
}

bool wadList::Save ( const char *newName ) {
	if ( IsEmpty ()) {
		printf("empty!!!!\n");
		return false;
	}

	printf("saving!!!!\n");

	if ( m_List->Next ) {

		wadListEntry *ptr = m_List;
		const char *m_Name = NULL;
		char wadPath [MAXPATH], newPath [MAXPATH], tmpPath [MAXPATH];
		_fullpath ( newPath, newName, MAXPATH );
		while ( ptr->Next != NULL ) {
			m_Name = ptr->wad->Name ();
			_fullpath ( wadPath, m_Name, MAXPATH );
			if ( strcasecmp ( wadPath, newPath ) == 0 ) break;
			ptr = ptr->Next;
		}

		FILE *tmpFile = NULL;

		if ( newName == NULL ) {
			newName = m_Name;
		}
		const char *tempName = newName;

		if ( strcasecmp ( wadPath, newPath ) == 0 ) {
			sprintf ( tmpPath, "%s.XXXXXX", newPath );
#if defined _WIN32 && !defined __MINGW32__
			int tmp = _mktemp_s(tmpPath);
#else
			int tmp = mkstemp(tmpPath);
#endif
			if ( tmp == -1 ) {
				fprintf ( stderr, "\nERROR: wadList::SaveFile - Error creating temporary file." );
				return false;
			}
			tempName = tmpPath;
			tmpFile  = fdopen ( tmp, "wb" );
		}

		if ( tmpFile == NULL ) {
			tmpFile = fopen ( tempName, "wb" );
		}

		if ( tmpFile == NULL ) return false;

		bool errors = false;
		wadHeader m_Header;
		if ( fwrite ( &m_Header, sizeof ( m_Header ), 1, tmpFile ) != 1 ) {
			errors = true;
			fprintf ( stderr, "\nERROR: wadList::Save - Error writing dummy header." );
		}

		wadListDirEntry *srcDir = m_Directory;
		wadDirEntry *dir = new wadDirEntry [ m_DirSize ];
		for ( UINT32 i = 0; i < m_DirSize; i++ ) {
			dir[i] = *srcDir->entry;
			long offset = ftell ( tmpFile );
			char *ptr = ( char * ) srcDir->wad->ReadEntry ( srcDir->entry, NULL );
			if ( srcDir->wad->Status () != ws_OK ) {
				errors = true;
				fprintf ( stderr, "\nERROR: wadList::Save - Error reading entry %8.8s. (%04X)", srcDir->entry->name, srcDir->wad->Status ());
			}
			if (( dir[i].size > 0 ) && ( fwrite ( ptr, dir[i].size, 1, tmpFile ) != 1 )) {
				errors = true;
				fprintf ( stderr, "\nERROR: wadList::Save - Error writing entry %8.8s.", srcDir->entry->name );
			}
			delete [] ptr;
			dir[i].offset = offset;
			srcDir++;
			// printf("writing %s\n", srcDir->entry->name);
		}

		//printf("done writing\n");

		WAD *wad = ptr->wad;

		* ( UINT32 * ) m_Header.type = wad->Format ();
		m_Header.dirSize  = m_DirSize;
		m_Header.dirStart = ftell ( tmpFile );

		if (( UINT32 ) fwrite ( dir, sizeof ( wadDirEntry ), m_DirSize, tmpFile ) != m_DirSize ) {
			errors = true;
			fprintf ( stderr, "\nERROR: wadList::Save - Error writing directory." );
		}
		delete [] dir;

		fseek ( tmpFile, 0, SEEK_SET );
		if ( fwrite ( &m_Header, sizeof ( m_Header ), 1, tmpFile ) != 1 ) {
			errors = true;
			fprintf ( stderr, "\nERROR: wadList::Save - Error writing header." );
		}

		fclose ( tmpFile );

		if ( errors == true ) {
			remove ( tempName );
			return false;
		}

		if ( strcasecmp ( wadPath, newPath ) == 0 ) {
			wad->CloseFile ();
			if ( remove ( m_Name ) != 0 ) {
				fprintf ( stderr, "\nERROR: wadList::Save - Unable to remove %s.", m_Name );
				return false;
			}
			if ( rename ( tempName, m_Name ) != 0 ) {
				fprintf ( stderr, "\nERROR: wadList::Save - Unable to rename %s to %s.", tempName, m_Name );
				return false;
			}
			wad->OpenFile ();
		}

	} else {
		return m_List->wad->SaveFile ( newName );
	}

	return true;
}

bool wadList::Extract ( const wLumpName *res, const char *m_Name ) {
	UINT32 size;
	const wadListDirEntry *dir;

	WAD *newWad = new WAD ( NULL );

	bool hasMaps = false;
	for ( int i = 0; res [i][0]; i++ ) {
		if ( WAD::IsMap ( res[i] )) {
			hasMaps = true;
			const wadListDirEntry *dir = FindWAD ( res[i] );
			DoomLevel *level = new DoomLevel ( res[i], dir->wad, true );
			level->AddToWAD ( newWad );
			delete level;
		} else {
			if (( dir = FindWAD ( res[i], NULL, NULL )) != NULL ) {
				void *ptr = dir->wad->ReadEntry ( dir->entry, &size, false );
				newWad->InsertAfter (( const wLumpName * ) res[i], size, ptr, true );
			}
		}
	}

	if ( hasMaps ) {
		if (( dir = FindWAD ( "MAPINFO" )) != NULL ) {
			void *ptr = dir->wad->ReadEntry ( dir->entry, &size, false );
			newWad->InsertAfter (( const wLumpName * ) "MAPINFO", size, ptr, true );
		}
		if (( dir = FindWAD ( "SNDINFO" )) != NULL ) {
			void *ptr = dir->wad->ReadEntry ( dir->entry, &size, false );
			newWad->InsertAfter (( const wLumpName * ) "SNDINFO", size, ptr, true );
		}
	}

	newWad->Format ( PWAD_ID );

	char filename [ 256 ];
	if ( m_Name ) {
		strcpy ( filename, m_Name );
	} else {
		sprintf ( filename, "%s.WAD", res [0] );
	}
	bool retVal = newWad->SaveFile ( filename );
	delete newWad;

	return retVal;
}
