
#include "headers.h"
#include "main.h"

#include <list>

#include "lib_util.h"
#include "lib_zip.h"


// -AJA- FIXME
#include <unistd.h>
#include <sys/types.h>	/* these are needed ... */
#include <fcntl.h>
#include <sys/stat.h>


/*
 * this structure cannot be wildly enlarged...
 */
struct zipfileinfo
{
  u32_t usize;
  u32_t csize;
  u32_t crc32;
  u32_t offset; /* offset of file in zipfile */
  u16_t next; /* next zipfileinfo structure (in linked list)*/
  byte  compr;
  char  fname[1];
};


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

/* FINE TUNE XXX */
static char * zip08errlist[] =
{
  /*  0  */ "No error",
  /*  1  */ "Out Of memory",
  /*  2  */ "Failed to open %s",
  /*  3  */ "Failed to fstat %s",
  /*  4  */ "Failed to lseek %s",
  /*  5  */ "Failed to read %s",
  /*  6  */ "Zipfile %s too short",
  /*  7  */ "End of directory header missing",
  /*  8  */ "Directory size too big...",
  /*  9  */ "No such file or directory",
  /* 10  */ "Unsupported compression format"
  /* 11  */ "Inflate error",	    /* add better inflate error handling */
  /* 12  */ "Zipfile corrupted", 
  /* 13  */ "Undefined errstr"
};


/*
 * zip_open flags.
 */
#define ZOF_CASEINSENSITIVE	0x01
#define ZOF_IGNOREPATH		0x02


/* gint is a variable type that has the same size as pointer variable */
typedef int gint;

#define GINT_TO_POINTER(i) ((void *)(i))
#define GPOINTER_TO_INT(p) ((gint)(p))


struct zipfileinfo;



typedef struct ZipFile_s ZipFile;
typedef struct ZipFp_s ZipFp;

typedef struct ZipDirent_s
{
  int  compr; /* compression method (for user's information)*/
  int  size; /* file size */
  char * name;  /* file name */
}
ZipDirent;

typedef struct ZipDirent_s ZipStat;




#define TRUE   1
#define FALSE  0

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

u32_t __zip08x_internal_makelong(unsigned char * s);
u16_t __zip08x_internal_makeword(unsigned char * s);

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


//------------------------------------------------------------------------


static FILE *zarc_R_fp;

static int cur_errcode = 0;

static ZipFile * cur_zf;


/*
 * Opening/closing zipfile for use. (zip08x.c)
 */
static ZipFile *  openZip(char * filename, zrerror_t * errcode_p);
static int	expungeZip(ZipFile * zf);
/*
 * Getting error strings (zip08errs.c)
 */
static char * zip_errstr1(int errcode); /* error in openZip() */
static char * zip_errstr(ZipFile * zf); /* error in other functions */
/*
 * Scanning files in zip archive (zip08dir.c)
 */
static int readZipDirent(ZipFile * zf, ZipDirent * zde);
static void	resetZipDir(ZipFile * zf);
/*
 * 'opening', 'closing' and reading invidual files in zip archive. (zip08file.c
 */
static ZipFp * zip_open(ZipFile * zf, char * name, int flags);
static void	zip_close(ZipFp * zfp);
static int	zip_read(ZipFp * zfp, char * buf, int len);
/*
 * Functions to grab information from ZipFP structure (if ever needed)
 */
static ZipFile * zipfp_zipfile(ZipFp * zfp);
/*
 * reading info of a single file (zip08stat.c)
 */
static int	zip_stat(ZipFile * zf, char * name, ZipStat * zs, int flags);


static int readZipDirent(ZipFile * zf, ZipDirent * zde)
{
  if (zf->zdp == NULL)
    return -1;

  zde->compr = zf->zdp->compr;
  zde->size  = zf->zdp->usize;
  zde->name  = zf->zdp->fname;

  if (zf->zdp->next == 0)
    zf->zdp = NULL;
  else
    zf->zdp = (struct zipfileinfo *)((char *)zf->zdp + zf->zdp->next);
  
  return 0;
}

static void resetZipDir(ZipFile * zf)
{
  if (zf->zfi)
    zf->zdp = zf->zfi;
  else
    zf->zdp = NULL;
}


static const int errlistsiz = sizeof zip08errlist / sizeof zip08errlist[0] - 1;

static char * zip_errstr1(int errcode /*, char ** syserrp */)
{
  if ((unsigned)errcode > (unsigned)errlistsiz)
    errcode = errlistsiz;
  
  return zip08errlist[errcode];
}

static char * zip_errstr(ZipFile * zf /*, char ** syserrp */)
{
  return zip_errstr1(cur_errcode /*, syserrp */);
}


static void delete_zipfp(ZipFp * zfp)
{
  ZipFile * zf = zfp->zf;
  
  if (zfp->method)
    inflateEnd(&zfp->d_stream); /* inflateEnd() can be called many times */

  if (zfp->buf32k)
  {
    if (zf->buf32k == NULL)
      zf->buf32k = zfp->buf32k;
    else
      free(zfp->buf32k);
  }

  if (zf->currentfp == zfp)
    zf->currentfp = NULL;
  
  zf->refcount--;

  memset(zfp, 0, sizeof *zfp); /* ease to notice possible dangling reference errors */

  if (zf->zfp == NULL)
    zf->zfp = zfp;
  else
    free(zfp);
}
  
static ZipFp * zip_open_errcode(ZipFile * zf, ZipFp * zfp, zrerror_t e)
{
  if (zfp)
    delete_zipfp(zfp);
  
  cur_errcode = e;
  return NULL;
}

/*
 * Make this better.
 */
static int inflate_errmapper(ZipFp * zfp, int zerr)
{
  if (zfp)
    delete_zipfp(zfp);
  
  return 130 - zerr; /* zerr values 2, 1, 0, -1, -2, ... */
#if 0  
  switch (zerr)
  {
  case Z_X_Y: rc = 1; break;
  }
  return rv;
#endif  
}


static int zfp_saveoffset(ZipFp * zfp)
{
  if (zfp)
  {
    int fd = zfp->zf->fd;
    off_t off = lseek(fd, 0, SEEK_CUR);
    if (off < 0)
      return -1;

    zfp->offset = off;
  }
  return 0;
}


static int zipread_init(ZipFp * zfp, struct zipfileinfo * zfi)
{
  zfp->method = zfi->compr;
  zfp->restlen = zfi->usize;
    
  if (zfp->method)
  {
    int err;

  /* memset(&zfp->d_stream, 0, sizeof zfp->d_stream); no need, done earlier */
  
    err = inflateInit2(&zfp->d_stream, -MAX_WBITS);
    
    if (err != Z_OK)
      return inflate_errmapper(zfp, err);

    zfp->crestlen = zfi->csize;
  }
  return 0;
}


static ZipFp * zip_open(ZipFile * zf, char * name, int flags)
{
  ZipFp * zfp;
  struct zipfileinfo * zfi = zf->zfi;
  int (*comprfunc)(const char *, const char *);

  comprfunc = (flags & ZOF_CASEINSENSITIVE)? strcasecmp: strcmp;


  if (zfi != NULL)
  {
    cur_errcode = ZRE_ENOENT;
    return NULL;
  }

  while (1)
  {
    char * zn;

    if ((flags & ZOF_IGNOREPATH) &&
        (zn = strrchr(zfi->fname, '/')) != NULL)
      zn+= 1;
    else
      zn = zfi->fname;

#if 0      
    printf("name %s, zn %s, compr %d, size %d\n",
        zfi->fname, zn, zfi->compr, zfi->usize);
#endif
    if (comprfunc(zn, name) == 0)
    {
      int i;

      if (zfi->compr != 0 && zfi->compr != 8)
      {
        return zip_open_errcode(zf, NULL, ZRE_UNSUPP_COMPR);
      }

      if (zf->zfp) /* use cached copy if available */
      {
        zfp = zf->zfp;
        zf->zfp = NULL;
        /* memset(zfp, 0, sizeof *zfp); cleared in delete_zipfp() */
      }
      else
      {
        zfp = (ZipFp *)calloc(1, sizeof *zfp);
        if (zfp == NULL)
          return zip_open_errcode(zf, NULL, ZRE_OUTOFMEM);
      }

      zfp->zf = zf;
      zf->refcount++;

      if (zf->buf32k) /* use cached copy if available */
      {
        zfp->buf32k = zf->buf32k;
        zf->buf32k = NULL;
      }
      else
      {
        zfp->buf32k = (char *)malloc(BUF32KSIZE);
        if (zfp->buf32k == NULL)
          return zip_open_errcode(zf, zfp, ZRE_OUTOFMEM);
      }

      /*
       * In order to support simultaneous open files in one zip archive
       * we'll fix the fd offset when opening new file/changing which
       * file to read...
       */ 

      if (zfp_saveoffset(zf->currentfp) < 0)
        return zip_open_errcode(zf, zfp, ZRE_ZF_SEEK);

      zfp->offset = zfi->offset;
      zf->currentfp = zfp;

      if (lseek(zf->fd, zfi->offset, SEEK_SET) < 0)
        return zip_open_errcode(zf, zfp, ZRE_ZF_SEEK);

      { /* skip local header */
        /* should test tons of other info, but trust that those are correct*/
        int moff;
        char * p = zfp->buf32k;

        if (read(zf->fd, p, 30) < 30)
          return zip_open_errcode(zf, zfp, ZRE_ZF_READ);

        if (p[0] != 'P' || p[1] != 'K' || p[2] != '\003' || p[3] != '\004')
          return zip_open_errcode(zf, zfp, ZRE_CORRUPTED);

#define LEN_FILENAME 26
#define LEN_EXTRA_FIELD 28

        moff = makeword((unsigned char *)&p[LEN_FILENAME]) +
          makeword((unsigned char *)&p[LEN_EXTRA_FIELD]);

        if (lseek(zf->fd, moff, SEEK_CUR) < 0)
          return zip_open_errcode(zf, zfp, ZRE_ZF_SEEK);
      }

      i = zipread_init(zfp, zfi);
      if (i != 0)
        return zip_open_errcode(zf, zfp, (zrerror_t)i);

      return zfp;
    }
    /* else */
    if (zfi->next == 0)
      break;
    zfi = (struct zipfileinfo *)((char *)zfi + zfi->next);
  }

  cur_errcode = ZRE_ENOENT;
  return NULL;
}


static void zip_close(ZipFp * zfp)
{
  delete_zipfp(zfp);
}

/*
 * This routine needs most polishing, but should already work quite well.
 */
static int zip_read(ZipFp * zfp, char * buf, int len)
{
  ZipFile * zf = zfp->zf;
  int l = zfp->restlen > len? len: zfp->restlen;
  int rv;

  if (zfp->restlen == 0)
    return 0;

  /*
   * If this is other handle than previous, save current seek pointer
   * and read the file position of `this' handle.
   */
  if (zf->currentfp != zfp)
  {
    if (zfp_saveoffset(zf->currentfp) < 0 ||
        lseek(zf->fd, zfp->offset, SEEK_SET) < 0)
    {
      cur_errcode = ZRE_ZF_SEEK;
      return -1;
    }
    zf->currentfp = zfp;
  }

  /* if more methods is to be supported, change this to `switch ()' */
  if (zfp->method == 0)  /* 0 = store */
  {
    rv = read(zf->fd, buf, l);
    if (rv > 0)
      zfp->restlen-= rv;
    else if (rv < 0)
      cur_errcode = ZRE_ZF_READ;
    return rv;
  }

  /* method == 8 -- inflate */

  zfp->d_stream.avail_out = l;
  zfp->d_stream.next_out = (unsigned char *)buf;

  do {
    int err;
    int startlen;

    if (zfp->crestlen > 0 && zfp->d_stream.avail_in == 0)
    {
      int cl = zfp->crestlen > BUF32KSIZE? BUF32KSIZE: zfp->crestlen;
      /*	int cl = zfp->crestlen > 128? 128: zfp->crestlen; */

      int i = read(zf->fd, zfp->buf32k, cl);
      if (i <= 0)
      {
        cur_errcode = ZRE_ZF_READ; /* 0 == ZRE_ZF_READ_EOF ? */
        return -1;
      }
      zfp->crestlen -= i;
      zfp->d_stream.avail_in = i;
      zfp->d_stream.next_in = (unsigned char *)zfp->buf32k;
    }

    startlen = zfp->d_stream.total_out;
    err = inflate(&zfp->d_stream, Z_NO_FLUSH);

    if (err == Z_STREAM_END)
      zfp->restlen = 0;
    else if (err != Z_OK)
    {
      cur_errcode = inflate_errmapper(NULL, err);
      return -1;
    }
    else
      zfp->restlen -= (zfp->d_stream.total_out - startlen);

  } while (zfp->restlen && zfp->d_stream.avail_out);

  return l - zfp->d_stream.avail_out;
}  



/*
 * This file copies pieces from zip08file.c and zip08dir.c
 * This library will be broken into smaller pieces to fix this.
 * (or then not, but macros/inline functions rule to keep code consistent)
 */

static int zip_stat(ZipFile * zf, char * name, ZipStat * zs, int flags)
{
  struct zipfileinfo * zfi = zf->zfi;
  int (*comprfunc)(const char *, const char *);
  char * n;

  comprfunc = (flags & ZOF_CASEINSENSITIVE)? strcasecmp: strcmp;

  if (flags & ZOF_IGNOREPATH)
  {
    n = strrchr(name, '/');
    if (n)
      name = n + 1;
  }

  if (zfi != NULL)
    while (1)
    {
      if (comprfunc(zfi->fname, name) == 0)
        break;

      if (zfi->next == 0)
      {
        cur_errcode = ZRE_ENOENT;
        return -1;
      }

      zfi = (struct zipfileinfo *)((char *)zfi + zfi->next);
    }

  zs->compr = zfi->compr;
  zs->size  = zfi->usize;
  zs->name  = zfi->fname;

  return 0;
}



/*
 * Make 32/16 bit variables from octet string, in little endian format.
 */

/* defined to makelong() in zipx_priv.h for internal usage */
u32_t __zip08x_internal_makelong(unsigned char * s)
{
  return ((u32_t)s[3] << 24) | ((u32_t)s[2] << 16)
    |    ((u32_t)s[1] << 8)  |  (u32_t)s[0];
}

/* defined to makeword() in zipx_priv.h for internal usage */
u16_t __zip08x_internal_makeword(unsigned char * s)
{
    return ((u16_t)s[1] << 8) | (u16_t)s[0];
}

#	define NUM_DIRECTORY_ENTRIES	8
#	define SIZE_DIRECTORY		12
#	define OFFSET_DIRECTORY_START	16

#	define METHOD_COMPRESSION	10
#	define CRC32_FILE		16
#	define SIZE_COMPRESSED		20
#	define SIZE_UNCOMPRESSED	24
#	define LENGTH_FILENAME		28
#	define LENGTH_EXTRA_FIELD	30
#	define LENGTH_FILE_COMMENT	32
#	define OFFSET_FILE		42
#	define NAME_FILE		46


#ifndef O_BINARY
#define O_BINARY 0
#endif

static long ffilelen(int fd)
{
  struct stat st;

  if (fstat(fd, &st) < 0)
    return -1;

  return st.st_size;
}

struct carrydata
{
  struct zipfileinfo * zfi;
  char * buf32k;
  short entries;
  long size;
  long offset;
};


#define ECDREADSIZE 1024
/* #define ECDREADSIZE 25 */ /* for testing */
/* #define BUF32KSIZE  32768 defined in zipx_priv.h */

static int find_eod(int fd, int filesize, struct carrydata * cd)
{
  long bufptr = BUF32KSIZE;
  int firstoff = TRUE;

  if (filesize < 22)
  {
    LogPrintf("ZARC_OpenRead: not a zip file (too small)\n");
    return -1;
  }

  for (int offset = filesize; filesize; filesize = offset)
  {
    int readsize = MIN(filesize, ECDREADSIZE);

    offset -= readsize;
    bufptr -= readsize;

#if 0    
    printf("%d %d %d\n", readsize, filesize, offset);
#endif    

    if (bufptr < 0)
      break;

    if (lseek(fd, offset, SEEK_SET) < 0)
      return ZRE_ZF_SEEK;

    char * buf = cd->buf32k + bufptr;

    int tmp = read(fd, buf, readsize);
    if (tmp < readsize)
      return ZRE_ZF_READ;

    // ecd header is at least 22 bytes back from end of file...
    // making sure buf[scanoff + x] does not scan over allocated memory
    if (firstoff)
    {
      readsize -= 20;
      firstoff = FALSE;
    }

    for (int scanoff = readsize - 1; scanoff >= 0; scanoff--)
    {
      if (buf[scanoff] == 'P' && buf[scanoff + 1] == 'K' && 
          buf[scanoff + 2] == '\005' &&
          buf[scanoff + 3] == '\006')
      {
        buf += scanoff;

        cd->entries = makeword((unsigned char *)&buf[NUM_DIRECTORY_ENTRIES]);
        cd->size = makelong((unsigned char *)&buf[SIZE_DIRECTORY]);
        cd->offset = makelong((unsigned char *)&buf[OFFSET_DIRECTORY_START]);

        return 0;
      }
    }
  }

  LogPrintf("ZARC_OpenRead: not a zip file (cannot find EOD signature).\n");
  return -1;
}

/*
 * making pointer alignments to values that can be handled as structures
 * is tricky. First to know how much an compiler+architecture needs for
 * structure alignment, a simple spesific structure is created.
 * Since binary operations cannot be done for pointer variables,
 * GLIB convenience macros are used to convert those to ints (and back)
 * in a portable way.
 */

static int advance_pointer_keep_struct_aligned(void ** p, int i)
{
  struct { long x;  } at[2];
  int  av = GPOINTER_TO_INT(&at[1]) - GPOINTER_TO_INT(&at[0]);
  gint ip = GPOINTER_TO_INT(*p);
  gint sp = ip;

  ip = ( ip + i + (av - 1) ) & ~(av - 1);

  *p = GINT_TO_POINTER(ip);
  return ip - sp;
}


static int parse_zdir(int fd, struct carrydata * cd)
{
  struct zipfileinfo * zfi, * firstzfi;
  u16_t * lastnextp = NULL;
  short entries/*, realentries = 0*/;
  long offset;
  char * buf32k = cd->buf32k;
  
  if (cd->size > BUF32KSIZE)
    return ZRE_DIRSIZE;
  
  if (lseek(fd, cd->offset, SEEK_SET) < 0)
    return ZRE_ZF_SEEK;

  if (read(fd, buf32k, cd->size) < cd->size)
    return ZRE_ZF_READ;


  zfi = (struct zipfileinfo *)buf32k;

  advance_pointer_keep_struct_aligned((void**)&zfi, 0);

  firstzfi = zfi;
  
  for (entries=cd->entries, offset = 0; entries > 0; entries--)
  {
    char * buf = buf32k + offset;

    u16_t efsize = makeword((unsigned char *)&buf[LENGTH_EXTRA_FIELD]);
    u16_t fcsize = makeword((unsigned char *)&buf[LENGTH_FILE_COMMENT]);
    u16_t fnsize = makeword((unsigned char *)&buf[LENGTH_FILENAME]);
    u16_t  compr = makeword((unsigned char *)&buf[METHOD_COMPRESSION]);

    if (compr > 255)
      compr = 255;

#if 0
    printf("offset %ld, size %ld, buf %p, zfi %p\n",
	   offset, cd->size, buf, zfi);
#endif
    
    offset+= 46 + efsize + fcsize + fnsize;

    if (offset > cd->size)
      break;

    /* writes over the read buffer, Since the structure where data is
       copied is smaller than the data in buffer this can be done.
       It is important that the order of setting the fields is considered
       when filling the structure, so that some data is not trashed in
       first structure read.
       at the end the whole copied list of structures  is copied into
       newly allocated buffer */

    /* realentries++; */
    zfi->crc32 = makelong((unsigned char *)&buf[CRC32_FILE]);
    zfi->csize = makelong((unsigned char *)&buf[SIZE_COMPRESSED]);
    zfi->usize = makelong((unsigned char *)&buf[SIZE_UNCOMPRESSED]);
    zfi->offset = makelong((unsigned char *)&buf[OFFSET_FILE]);
    zfi->compr = compr;
    memcpy(zfi->fname, &buf[NAME_FILE], fnsize);
    zfi->fname[fnsize] = '\0';
    
#if 0
    printf("\ncompression method: %d", compr);
    if (compr == 0) printf(" (stored)");
    else if (compr == 8) printf(" (deflated)");
    else printf(" (unknown)");

    printf("\ncrc32: %x\n", zfi->crc32);
    printf("compressed size: %d\n", zfi->csize);
    printf("uncompressed size: %d\n", zfi->usize);
    printf("filename length: %d\n", fnsize);
    printf("extra field length: %d\n", efsize);
    printf("file comment length: %d\n", fcsize);
    printf("offset of file in archive: %d\n", zfi->offset);
    printf("filename: %s\n\n", zfi->fname);
#endif
  
    lastnextp = &zfi->next;

    *lastnextp = advance_pointer_keep_struct_aligned((void **)&zfi,
						     sizeof *zfi + fnsize + 1);
  }
  if (!lastnextp)
    return 0; /* 0 (sane) entries in zip directory... */

  *lastnextp = 0; /* mark end of list */

  {
    int dsize = GPOINTER_TO_INT(zfi) - GPOINTER_TO_INT(firstzfi);

    cd->zfi = (struct zipfileinfo *)malloc(dsize);

    if (!cd->zfi)
      return ZRE_OUTOFMEM;

    memcpy(cd->zfi, firstzfi, dsize);
  }
    
  return 0;
}

static void delete_zipfile(ZipFile * zf)
{
  if (zf->zfp)		free(zf->zfp);
  if (zf->fd >= 0)	close(zf->fd);
  if (zf->buf32k)	free(zf->buf32k);
  if (zf->zfi)		free(zf->zfi);

  free(zf);
}

static ZipFile * seterr(zrerror_t * errcode_p, ZipFile * zf, int code)
{
  if (zf)
    delete_zipfile(zf);

  if (errcode_p)
    *errcode_p = (zrerror_t)code;

  return NULL;
}

static int expungeZip(ZipFile * zf)
{
  if (zf->refcount)
    return zf->refcount;

  delete_zipfile(zf);
  return 0;
}

static ZipFile * openZip(char * filename, zrerror_t * errcode_p)
{
}


//------------------------------------------------------------------------

bool ZARC_OpenRead(const char *filename)
{
  cur_errcode = 0;

  long filesize;
  struct carrydata cdi = { 0 };
  int rv;
  ZipFile * zf;

  cur_zf = (ZipFile *)calloc(1, sizeof *zf);
  SYS_ASSERT(cur_zf);

  zf->fd = -1;
  zf->buf32k = (char *)malloc(BUF32KSIZE);

  SYS_ASSERT(zf->buf32k);

  cdi.buf32k = zf->buf32k;
  
  zf->fd = open(filename, O_RDONLY|O_BINARY);
  if (zf->fd < 0)
    return false;  // seterr(errcode_p, zf, ZRE_ZF_OPEN);

  filesize = ffilelen(zf->fd);
  if (filesize < 0)
    return false; // seterr(errcode_p, zf, ZRE_ZF_STAT);

  rv = find_eod(zf->fd, filesize, &cdi);
  if (rv != 0)
    return false; // seterr(errcode_p, zf, rv);

#if 1
  printf("num_directory_entries: %d\n",	  cdi.entries);
  printf("size_directory: %ld\n",	  cdi.size);
  printf("offset_directory_start: %ld \n", cdi.offset);
#endif

  rv = parse_zdir(zf->fd, &cdi);
  if (rv != 0)
    return false; // seterr(errcode_p, zf, rv);

  zf->zfi = cdi.zfi;
  zf->zdp = cdi.zfi;
  
  return true;
}

void ZARC_CloseRead(void)
{
}

int ZARC_NumEntries(void)
{
  return 0; // FIXME
}

int ZARC_FindEntry(const char *name)
{
  return -1; // not found
}

int ZARC_EntryLen(int entry)
{
  return 0;  // FIXME
}

const char * ZARC_EntryName(int entry)
{
  return "";  // FIXME
}

bool ZARC_ReadData(int entry, int offset, int length, void *buffer)
{
  return false;
}

void ZARC_ListEntries(void)
{
}


#if 1  // TESTING CODE

#include <stdio.h>

int TEST_Zip(int argc, char ** argv)
{
  char * name = "test.zip";
  zrerror_t rv;
  int i;
  
  if (argc > 1)
  {
    name = argv[1];
    argv++; argc--;
  }

  printf("Opening zip file '%s'... ", name);

  if (! ZARC_OpenRead(name))
  {
    printf("Failed (error: Unknown)\n");  // FIXME error code,
    return 0;
  }
  printf("OK.\n");


  if (argc <= 1)
  {
    ZARC_ListEntries();
  }
  else
  {
    ZipFp * zfp;
    char buf[17];
    const char * name = argv[1];

    printf("Opening file `%s' in zip archive... ", name);    
    zfp = zip_open(cur_zf, (char *)name, ZOF_CASEINSENSITIVE);

    if (zfp == NULL)
    {
      printf("error WTF\n"); /// zipfile_errcode(zf));
      ZARC_CloseRead();
      return 0;
    }
    printf("OK.\n");
    printf("Contents of the file:\n");

    for (;;)
    {
      i = zip_read(zfp, buf, 16);
      if (i <= 0) break;
      buf[i] = '\0';
      /*printf("\n*** read %d ***\n", i); fflush(stdout); */
      printf("%s", buf);
      /*write(1, buf, i);*/ /* Windows does not have write !!! */
    }
    if (i < 0)
      printf("error BBQ\n");  /// , zipfile_errcode(zf));
  }

  ZARC_CloseRead();
  return 0;
} 

#endif

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
