
#ifndef __OBLIGE_LIB_ZIP_H__
#define __OBLIGE_LIB_ZIP_H__

#include <zlib.h>

bool ZARC_OpenRead(const char *filename);
void ZARC_CloseRead(void);

int  ZARC_NumEntries(void);
int  ZARC_FindEntry(const char *name);
int  ZARC_EntryLen(int entry);
const char * ZARC_EntryName(int entry);

bool ZARC_ReadData(int entry, int offset, int length, void *buffer);

void ZARC_ListEntries(void);


/* ----- ZIP file structure ---------------------- */

typedef struct
{
  char magic[4];

  u16_t disk_stuff[2];
  u16_t num_entries[2];

  u32_t dir_size;
  u32_t dir_offset;
}
raw_zip_trailer_t;

#define ZARC_EOD_MAGIC  "PK\005\006"


typedef struct
{
  char magic[4];

  u16_t req_version;
  u16_t flags;
  u16_t comp_method;

  u16_t file_time;  // MS-DOS format
  u16_t file_data;  //

  u32_t crc;
  u32_t comp_size;
  u32_t real_size;

  char filename[1];  // variable size
}
raw_zip_entry_t;

#define ZARC_ENTRY_MAGIC  "PK\003\004"

#define ZARC_F_ENCRYPTED       (1 << 0)
#define ZARC_F_POST_DATA_DESC  (1 << 3)

#define ZARC_COMPR_STORE    0
#define ZARC_COMPR_DEFLATE  8


#endif /* __OBLIGE_LIB_ZIP_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
