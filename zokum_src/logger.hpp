//----------------------------------------------------------------------------
//
// File:	logger.hpp
// Date:	15-Apr-1998
// Programmer:	Marc Rousseau			 
//
// Description: Error Logger object header
//
// Copyright (c) 1998-2004 Marc Rousseau, All Rights Reserved.
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

#ifndef LOGGER_HPP_
#define LOGGER_HPP_

#ifdef ERROR
    #undef ERROR
#endif
#ifdef ASSERT
    #undef ASSERT
#endif

#if defined ( DEBUG )

    struct LOG_FLAGS {
        bool    FunctionEntry;
    };

    extern LOG_FLAGS g_LogFlags;

    #define FUNCTION_ENTRY(t,f,l)					\
        void *l_pThis  = ( void * ) t;					\
        char *l_FnName = f;						\
        bool l_log = ( g_LogFlags.FunctionEntry == l ) ? true : false;  \
        if ( l_log && g_LogFlags.FunctionEntry ) {			\
            DBG_MINOR_TRACE2 ( l_FnName, l_pThis, "Function entered" );	\
        }

    #define ASSERT(x)                  (( ! ( x )) ? dbg_Assert ( dbg_FileName, __LINE__, l_FnName, l_pThis, #x ), 1 : 0 )
    #define ASSERT_BOOL(x)             ASSERT ( x )

#else

    #if defined ( _MSC_VER )
        #pragma warning ( disable: 4127 )    // C4127: conditional expression is constant
    #endif

    #define FUNCTION_ENTRY(t,f,l)
    #define ASSERT(x)
    #define ASSERT_BOOL(x)             0

#endif

#define TRACE(x)        DBG_MAJOR_TRACE2 ( l_FnName, l_pThis, ( const char * ) x )
#define EVENT(x)        DBG_MINOR_EVENT2 ( l_FnName, l_pThis, ( const char * ) x )
#define MINOR_EVENT(x)  DBG_MINOR_EVENT2 ( l_FnName, l_pThis, ( const char * ) x )
#define MAJOR_EVENT(x)  DBG_MAJOR_EVENT2 ( l_FnName, l_pThis, ( const char * ) x )
#define STATUS(x)       DBG_STATUS2 ( l_FnName, l_pThis, ( const char * ) x )
#define WARNING(x)      DBG_WARNING2 ( l_FnName, l_pThis, ( const char * ) x )
#define ERROR(x)        DBG_ERROR2 ( l_FnName, l_pThis, ( const char * ) x )
#define FATAL(x)        DBG_FATAL2 ( l_FnName, l_pThis, ( const char * ) x )

#if ! defined ( DEBUG )

    #define DBG_REGISTER(x)
    #define DBG_STRING(x)              ""
    #define DBG_MINOR_TRACE(f,t,x)
    #define DBG_MINOR_TRACE2(f,t,x)
    #define DBG_MAJOR_TRACE(f,t,x)
    #define DBG_MAJOR_TRACE2(f,t,x)
    #define DBG_MINOR_EVENT(f,t,x)
    #define DBG_MINOR_EVENT2(f,t,x)
    #define DBG_MAJOR_EVENT(f,t,x)
    #define DBG_MAJOR_EVENT2(f,t,x)
    #define DBG_STATUS(f,t,x)
    #define DBG_STATUS2(f,t,x)
    #define DBG_WARNING(f,t,x)
    #define DBG_WARNING2(f,t,x)
    #define DBG_ERROR(f,t,x)
    #define DBG_ERROR2(f,t,x)          
    #define DBG_FATAL(f,t,x)
    #define DBG_FATAL2(f,t,x)
    #define DBG_ASSERT(f,t,x)          0

#else

    #define DBG_REGISTER(x)            static int dbg_FileName = dbg_RegisterFile ( x );	
    #define DBG_STRING(x)              x
    #define DBG_MINOR_TRACE(f,t,x)     dbg_Record ( _MINOR_TRACE_, dbg_FileName, __LINE__, f, t, x )
    #define DBG_MINOR_TRACE2(f,t,x)    dbg_Record ( _MINOR_TRACE_, dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_MAJOR_TRACE(f,t,x)     dbg_Record ( _MAJOR_TRACE_, dbg_FileName, __LINE__, f, t, x )
    #define DBG_MAJOR_TRACE2(f,t,x)    dbg_Record ( _MAJOR_TRACE_, dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_MINOR_EVENT(f,t,x)     dbg_Record ( _MINOR_EVENT_, dbg_FileName, __LINE__, f, t, x )
    #define DBG_MINOR_EVENT2(f,t,x)    dbg_Record ( _MINOR_EVENT_, dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_MAJOR_EVENT(f,t,x)     dbg_Record ( _MAJOR_EVENT_, dbg_FileName, __LINE__, f, t, x )
    #define DBG_MAJOR_EVENT2(f,t,x)    dbg_Record ( _MAJOR_EVENT_, dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_STATUS(f,t,x)          dbg_Record ( _STATUS_,      dbg_FileName, __LINE__, f, t, x )
    #define DBG_STATUS2(f,t,x)         dbg_Record ( _STATUS_,      dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_WARNING(f,t,x)         dbg_Record ( _WARNING_,     dbg_FileName, __LINE__, f, t, x )
    #define DBG_WARNING2(f,t,x)        dbg_Record ( _WARNING_,     dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_ERROR(f,t,x)           dbg_Record ( _ERROR_,       dbg_FileName, __LINE__, f, t, x )
    #define DBG_ERROR2(f,t,x)          dbg_Record ( _ERROR_,       dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_FATAL(f,t,x)           dbg_Record ( _FATAL_,       dbg_FileName, __LINE__, f, t, x )
    #define DBG_FATAL2(f,t,x)          dbg_Record ( _FATAL_,       dbg_FileName, __LINE__, f, t, dbg_Stream () << x ), dbg_Stream ().flush ()
    #define DBG_ASSERT(f,t,x)          (( ! ( x )) ? dbg_Assert (  dbg_FileName, __LINE__, f, t, #x ), 1 : 0 )

enum eLOG_TYPE {
    _MINOR_TRACE_,
    _MAJOR_TRACE_,
    _MINOR_EVENT_,
    _MAJOR_EVENT_,
    _STATUS_,
    _WARNING_,
    _ERROR_,
    _FATAL_,
    LOG_TYPE_MAX
};  

class dbgString {

    friend dbgString &hex ( dbgString & );
    friend dbgString &dec ( dbgString & );

    int     m_Base;
    bool    m_OwnBuffer;
    char   *m_Ptr;
    char   *m_Buffer;

public:

    dbgString ( char * );

    operator const char * ();
    void flush ();

    dbgString &operator << ( const char * );
    dbgString &operator << ( char );
    dbgString &operator << ( unsigned char );
    dbgString &operator << ( short );
    dbgString &operator << ( unsigned short );
    dbgString &operator << ( int );
    dbgString &operator << ( unsigned int );
    dbgString &operator << ( long );
    dbgString &operator << ( unsigned long );
/*
    dbgString &operator << ( __int64 );
    dbgString &operator << ( unsigned __int64 );
*/
    dbgString &operator << ( double );
    dbgString &operator << ( void * );
    dbgString &operator << ( dbgString &(*f) ( dbgString & ));

};

dbgString &hex ( dbgString & );
dbgString &dec ( dbgString & );

extern "C" {

    dbgString  &dbg_Stream ();
    int         dbg_RegisterFile ( const char * );
    void        dbg_Assert ( int, int, const char * , void *, const char * );
    void        dbg_Record ( int, int, int, const char *, void *, const char * );

};

#endif

#endif
