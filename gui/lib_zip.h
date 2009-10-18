
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

/*
 * this structure cannot be wildly enlarged...
 */
typedef struct zipfileinfo
{
  u32_t usize;
  u32_t csize;
  u32_t crc32;
  u32_t offset; /* offset of file in zipfile */
  u16_t next; /* next zipfileinfo structure (in linked list)*/
  byte  compr;
  char  fname[1];
}
raw_zip_entry_t;


#endif /* __OBLIGE_LIB_ZIP_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
