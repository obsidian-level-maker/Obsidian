
#ifndef __OBLIGE_LIB_ZIP_H__
#define __OBLIGE_LIB_ZIP_H__

#include <zlib.h>

// FIXME FIXME
typedef char gint8;
typedef unsigned char guint8;

typedef short gint16;
typedef unsigned short guint16;

typedef int gint32;
typedef unsigned int guint32;

/* gint is a variable type that has the same size as pointer variable */
typedef int gint;
typedef unsigned int guint;

#define GINT_TO_POINTER(i) ((void *)(i))
#define GPOINTER_TO_INT(p) ((gint)(p))


struct zipfileinfo;

typedef enum {
/*  0 */ ZRE_NO_ERROR,	/* no error, may be used if user sets it. */
/*  1 */ ZRE_OUTOFMEM,	/* out of memory */
/*  2 */ ZRE_ZF_OPEN,	/* failed to open zipfile, see errno for details */
/*  3 */ ZRE_ZF_STAT,   /* failed to fstat zipfile, see errno for details */
/*  4 */ ZRE_ZF_SEEK,   /* failed to lseek zipfile, see errno for details */
/*  5 */ ZRE_ZF_READ,   /* failed to read zipfile, see errno for details */
/*  6 */ ZRE_ZF_TOO_SHORT,
/*  7 */ ZRE_EDH_MISSING,
/*  8 */ ZRE_DIRSIZE,
/*  9 */ ZRE_ENOENT,
/* 10 */ ZRE_UNSUPP_COMPR,
/* 11 */ ZRE_INFLATE,
/* 12 */ ZRE_CORRUPTED,
/* 13 */ ZRE_UNDEF
}
zrerror_t;

/*
 * zip_open flags.
 */
#define ZOF_CASEINSENSITIVE	0x01
#define ZOF_IGNOREPATH		0x02

typedef struct ZipFile_s ZipFile;
typedef struct ZipFp_s ZipFp;

typedef struct ZipDirent_s
{
  int	 compr;	/* compression method (for user's information)*/
  int	 size;	/* file size */
  char * name;  /* file name */
}
ZipDirent;

typedef struct ZipDirent_s ZipStat;

/*
 * Opening/closing zipfile for use. (zip08x.c)
 */
ZipFile *  openZip(char * filename, zrerror_t * errcode_p);
int	expungeZip(ZipFile * zf);

/*
 * Getting error strings (zip08errs.c)
 */
char * zip_errstr1(int errcode); /* error in openZip() */
char * zip_errstr(ZipFile * zf); /* error in other functions */


/*
 * Scanning files in zip archive (zip08dir.c)
 */
int	readZipDirent(ZipFile * zf, ZipDirent * zde);
void	resetZipDir(ZipFile * zf);

/*
 * 'opening', 'closing' and reading invidual files in zip archive. (zip08file.c
 */

ZipFp * zip_open(ZipFile * zf, char * name, int flags);
void	zip_close(ZipFp * zfp);
int	zip_read(ZipFp * zfp, char * buf, int len);


/*
 * Functions to grab information from ZipFP structure (if ever needed)
 */
ZipFile * zipfp_zipfile(ZipFp * zfp);


/*
 * reading info of a single file (zip08stat.c)
 */

int	zip_stat(ZipFile * zf, char * name, ZipStat * zs, int flags);


//----------------------------------------------------------------
//  PRIVATE STUFF
//----------------------------------------------------------------

#define TRUE   1
#define FALSE  0

/*
 * this structure cannot be wildly enlarged...
 */
struct zipfileinfo
{
  guint32	usize;
  guint32	csize;
  guint32	crc32;
  guint32	offset;	/* offset of file in zipfile */
  guint16	next;	/* next zipfileinfo structure (in linked list)*/
  guint8	compr;
  char		fname[1];
};

struct ZipFp_s;

#define ZipFp struct ZipFp_s
struct ZipFile_s
{
  int fd;
  int refcount;
  ZipFp * zfp;   /* --- reduce a lot of allocations/deallocations by */
  char * buf32k; /* --- caching one entry of these data structures */
  struct zipfileinfo * zfi;
  struct zipfileinfo * zdp; /* zip directpry pointer, for dirent stuff */
  ZipFp * currentfp; /* last zfp used... */
  int /* zrerror_t */ errcode;
}; 
#undef ZipFp

#define BUF32KSIZE 32768

guint32 __zip08x_internal_makelong(unsigned char * s);
guint16 __zip08x_internal_makeword(unsigned char * s);

#define makelong(x) __zip08x_internal_makelong(x)
#define makeword(x) __zip08x_internal_makeword(x)


/*
 * ZipFp structure... currently no need to unionize, since structure needed
 * for inflate is superset of structure needed for unstore.
 *
 * Don't make this public. Instead, create methods for needed operations.
 */

struct ZipFile_s;

#define ZipFile struct ZipFile_s
struct ZipFp_s
{
  ZipFile * zf;
  int method;
  int restlen;
  int crestlen;
  char * buf32k;
  off_t offset; /* offset from the start of zipfile... */
  z_stream d_stream;
};
#undef ZipFile


bool ZARC_OpenRead(const char *filename);
void ZARC_CloseRead(void);

int  ZARC_NumEntries(void);
int  ZARC_FindEntry(const char *name);
int  ZARC_EntryLen(int entry);
const char * ZARC_EntryName(int entry);

bool ZARC_ReadData(int entry, int offset, int length, void *buffer);

void ZARC_ListEntries(void);


#endif /* __OBLIGE_LIB_ZIP_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
