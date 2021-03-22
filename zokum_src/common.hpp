//----------------------------------------------------------------------------
//
// File:	common.hpp
// Date:
// Programmer:	Marc Rousseau
//
// Description:
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
//----------------------------------------------------------------------------

#ifndef COMMON_HPP_
#define COMMON_HPP_

//----------------------------------------------------------------------------
// Generic definitions
//----------------------------------------------------------------------------

#ifdef UNREFERENCED_PARAMETER
    #undef UNREFERENCED_PARAMETER
#endif

#if defined ( _MSC_VER )
    #define UNREFERENCED_PARAMETER(x)	x
#else
    #define UNREFERENCED_PARAMETER(x)
#endif

#define OFFSET_OF(t,x)	(( size_t ) & (( t * ) 0 )->( x ))
#define SIZE(x)		( sizeof ( x ) / sizeof (( x )[0] ))
#define EVER		;;

typedef signed char  INT8;
typedef signed short INT16;
typedef signed int   INT32;

typedef unsigned char  UINT8, UCHAR;
typedef unsigned short UINT16;
typedef unsigned int   UINT32;

#if defined ( __GNUC__ )

    typedef long long          INT64;
    typedef unsigned long long UINT64;

#else

    typedef __int64            INT64;
    typedef unsigned __int64   UINT64;

#endif

#if defined ( __WIN32__ ) || defined ( __AMIGAOS__ )

    // Undo any previos definitions
    #define BIG_ENDIAN      1234
    #define LITTLE_ENDIAN   4321

    #define BYTE_ORDER      LITTLE_ENDIAN

#else

    // Use the environments endian definitions
    #undef  __USE_BSD
    #define __USE_BSD
    #include <endian.h>

#endif

typedef int (*QSORT_FUNC) ( const void *, const void * );

#ifdef max
    #undef max
#endif
#ifdef min
    #undef min
#endif

template < class T > inline void swap ( T &item1, T &item2 )
{
    T temp = item1;
    item1 = item2;
    item2 = temp;
}

//----------------------------------------------------------------------------
// Platform specific definitions
//----------------------------------------------------------------------------

#if defined ( __OS2__ ) || defined ( __WIN32__ )

#define SEPERATOR	'\\'
#define DEFAULT_CHAR	'*'

#elif defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )

#define SEPERATOR	'/'
#define DEFAULT_CHAR	'*'

#endif

//----------------------------------------------------------------------------
// Compiler specific definitions
//----------------------------------------------------------------------------

#if defined ( __BORLANDC__ )

    #if defined ( __BCPLUSPLUS__ ) || defined ( __TCPLUSPLUS__ )
        #undef  NULL
        #define NULL ( void * ) 0
    #endif

    #if (( __BORLANDC__ < 0x0500 ) || defined ( __OS2__ ))

        // Fake out ANSI definitions for deficient compilers
        #define for    if (0); else for

        enum { false, true };
        class bool {
            int   value;
        public:
            operator = ( int x ) { value = x ? true : false; }
            bool operator ! ()   { return value; }
        };

    #endif

    template <class T> inline const T &min ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t2 : t1;
    }

    template <class T> inline const T &max ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t1 : t2;
    }

#elif defined ( _MSC_VER )

    #undef  NULL
    #define NULL        0L

    #define MAXPATH	_MAX_PATH
    #define MAXDRIVE	_MAX_DRIVE
    #define MAXDIR	_MAX_DIR
    #define MAXFNAME	_MAX_FNAME
    #define MAXEXT	_MAX_EXT

    #if ( _MSC_VER < 1300 )

        // Fake out ANSI definitions for deficient compilers
        #define for    if (0); else for

        #pragma warning ( disable: 4127 )    // C4127: conditional expression is constant

    #endif

    #pragma warning ( disable: 4244 )    // C4244: 'xyz' conversion from 'xxx' to 'yyy', possible loss of data
    #pragma warning( disable : 4290 )    // C4290: C++ exception specification ignored...
    #pragma warning ( disable: 4514 )    // C4514: 'xyz' unreferenced inline function has been removed

    template <class T> inline const T &min ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t2 : t1;
    }

    template <class T> inline const T &max ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t1 : t2;
    }

    #if ( _MSC_VER >= 1300 )
        extern char *strndup ( const char *string, size_t max );
    #endif

#elif defined ( __WATCOMC__ )

    #define M_PI        3.14159265358979323846

    template <class T> inline const T &min ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t2 : t1;
    }

    template <class T> inline const T &max ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t1 : t2;
    }

#elif defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )

    #define MAXPATH	FILENAME_MAX
    #define MAXDRIVE	FILENAME_MAX
    #define MAXDIR	FILENAME_MAX
    #define MAXFNAME	FILENAME_MAX
    #define MAXEXT	FILENAME_MAX

    #define O_BINARY	0

    #define stricmp strcasecmp
    #define strnicmp strncasecmp

        template <class T> inline const T &min ( const T &t1, const T &t2 )
        {
            return ( t1 > t2 ) ? t2 : t1;
        }

        template <class T> inline const T &max ( const T &t1, const T &t2 )
        {
            return ( t1 > t2 ) ? t1 : t2;
        }

#elif defined ( __AMIGAOS__ )

    // Fake out ANSI definitions for deficient compilers
    #define for    if (0); else for

    enum { false, true };
    class bool {
        int   value;
    public:
        operator = ( int x ) { value = x ? true : false; }
        bool operator ! ()   { return value; }
    };

    template <class T> inline const T &min ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t2 : t1;
    }

    template <class T> inline const T &max ( const T &t1, const T &t2 )
    {
        return ( t1 > t2 ) ? t1 : t2;
    }

    extern char *strdup ( const char *string );
    extern char *strndup ( const char *string, size_t max );

#endif

#endif
