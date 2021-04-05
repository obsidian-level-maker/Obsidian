# Microsoft Developer Studio Project File - Name="zdbsp" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=zdbsp - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "zdbsp.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "zdbsp.mak" CFG="zdbsp - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "zdbsp - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "zdbsp - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "zdbsp - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir ".\Release"
# PROP BASE Intermediate_Dir ".\Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ".\Release"
# PROP Intermediate_Dir ".\Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
MTL=midl.exe
# ADD BASE MTL /nologo /tlb".\Release\zdbsp.tlb" /win32
# ADD MTL /nologo /tlb".\Release\zdbsp.tlb" /win32
# ADD BASE CPP /nologo /W3 /GX /Zi /Ot /Og /Oi /Oy /Ob2 /Gy /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /GA /GF /c
# ADD CPP /nologo /MD /W3 /GX /Zi /Ot /Og /Oi /Oy /Ob2 /Gy /I "zlib" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /D _MSC_VER=1200 /D "DISABLE_SSE" /GA /GF /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# SUBTRACT BASE LINK32 /pdb:none
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "zdbsp - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir ".\Debug"
# PROP BASE Intermediate_Dir ".\Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ".\Debug"
# PROP Intermediate_Dir ".\Debug"
# PROP Target_Dir ""
MTL=midl.exe
# ADD BASE MTL /nologo /tlb".\Debug\zdbsp.tlb" /win32
# ADD MTL /nologo /tlb".\Debug\zdbsp.tlb" /win32
# ADD BASE CPP /nologo /W3 /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /GZ /c
# ADD CPP /nologo /W3 /GX /ZI /Od /I "zlib" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D _MSC_VER=1200 /D "DISABLE_SSE" /GZ /c
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# SUBTRACT BASE LINK32 /pdb:none
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# SUBTRACT LINK32 /pdb:none

!ENDIF 

# Begin Target

# Name "zdbsp - Win32 Release"
# Name "zdbsp - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Group "Reject(ed)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Unused\rejectbuilder.cpp
# PROP Exclude_From_Build 1
# End Source File
# Begin Source File

SOURCE=.\Unused\rejectbuilder.h
# PROP Exclude_From_Build 1
# End Source File
# Begin Source File

SOURCE=.\Unused\vis.cpp
# PROP Exclude_From_Build 1
# End Source File
# Begin Source File

SOURCE=.\Unused\visflow.cpp
# PROP Exclude_From_Build 1
# End Source File
# End Group
# Begin Source File

SOURCE=.\blockmapbuilder.cpp
DEP_CPP_BLOCK=\
	".\blockmapbuilder.h"\
	".\doomdata.h"\
	".\tarray.h"\
	".\templates.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=.\getopt.c
DEP_CPP_GETOP=\
	".\getopt.h"\
	
# End Source File
# Begin Source File

SOURCE=getopt1.c
DEP_CPP_GETOPT=\
	".\getopt.h"\
	
# End Source File
# Begin Source File

SOURCE=.\main.cpp
DEP_CPP_MAIN_=\
	".\blockmapbuilder.h"\
	".\doomdata.h"\
	".\getopt.h"\
	".\nodebuild.h"\
	".\processor.h"\
	".\tarray.h"\
	".\wad.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	
# End Source File
# Begin Source File

SOURCE=.\nodebuild.cpp
DEP_CPP_NODEB=\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\tarray.h"\
	".\templates.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=.\nodebuild_classify_nosse2.cpp
DEP_CPP_NODEBU=\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\tarray.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=nodebuild_events.cpp
DEP_CPP_NODEBUI=\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\tarray.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=nodebuild_extract.cpp
DEP_CPP_NODEBUIL=\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\tarray.h"\
	".\templates.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=nodebuild_gl.cpp
DEP_CPP_NODEBUILD=\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\tarray.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=nodebuild_utility.cpp
DEP_CPP_NODEBUILD_=\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\tarray.h"\
	".\templates.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=.\processor.cpp
DEP_CPP_PROCE=\
	".\blockmapbuilder.h"\
	".\doomdata.h"\
	".\nodebuild.h"\
	".\processor.h"\
	".\tarray.h"\
	".\wad.h"\
	".\workdata.h"\
	".\zdbsp.h"\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	
# End Source File
# Begin Source File

SOURCE=.\view.cpp
DEP_CPP_VIEW_=\
	".\doomdata.h"\
	".\tarray.h"\
	".\templates.h"\
	".\zdbsp.h"\
	
# End Source File
# Begin Source File

SOURCE=.\wad.cpp
DEP_CPP_WAD_C=\
	".\tarray.h"\
	".\wad.h"\
	".\zdbsp.h"\
	
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\blockmapbuilder.h
# End Source File
# Begin Source File

SOURCE=.\doomdata.h
# End Source File
# Begin Source File

SOURCE=getopt.h
# End Source File
# Begin Source File

SOURCE=.\nodebuild.h
# End Source File
# Begin Source File

SOURCE=.\processor.h
# End Source File
# Begin Source File

SOURCE=.\resource.h
# End Source File
# Begin Source File

SOURCE=.\tarray.h
# End Source File
# Begin Source File

SOURCE=.\templates.h
# End Source File
# Begin Source File

SOURCE=.\wad.h
# End Source File
# Begin Source File

SOURCE=.\workdata.h
# End Source File
# Begin Source File

SOURCE=.\zdbsp.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\resource.rc
# End Source File
# End Group
# Begin Group "zlib"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\zlib\adler32.c
DEP_CPP_ADLER=\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	
# End Source File
# Begin Source File

SOURCE=.\zlib\compress.c
DEP_CPP_COMPR=\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	
# End Source File
# Begin Source File

SOURCE=.\zlib\crc32.c
DEP_CPP_CRC32=\
	".\zlib\crc32.h"\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	".\zlib\zutil.h"\
	
# End Source File
# Begin Source File

SOURCE=.\zlib\crc32.h
# End Source File
# Begin Source File

SOURCE=.\zlib\deflate.c
DEP_CPP_DEFLA=\
	".\zlib\deflate.h"\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	".\zlib\zutil.h"\
	
# End Source File
# Begin Source File

SOURCE=.\zlib\deflate.h
# End Source File
# Begin Source File

SOURCE=.\zlib\trees.c
DEP_CPP_TREES=\
	".\zlib\deflate.h"\
	".\zlib\trees.h"\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	".\zlib\zutil.h"\
	
# End Source File
# Begin Source File

SOURCE=.\zlib\trees.h
# End Source File
# Begin Source File

SOURCE=.\zlib\zconf.h
# End Source File
# Begin Source File

SOURCE=.\zlib\zlib.h
# End Source File
# Begin Source File

SOURCE=.\zlib\zutil.c
DEP_CPP_ZUTIL=\
	".\zlib\zconf.h"\
	".\zlib\zlib.h"\
	".\zlib\zutil.h"\
	
# End Source File
# Begin Source File

SOURCE=.\zlib\zutil.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\zdbsp.html
# End Source File
# End Target
# End Project
