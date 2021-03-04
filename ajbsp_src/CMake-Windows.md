Compiling AJBSP for Windows
===========================

Build Preface
-------------

This build uses CMakeLists.txt, CMake-GUI, and Visual Studio to compile for Win32.

*Note that CMake can also be used for compiling on other operating systems,*
*like Linux, Raspberry Pi, MacOS X, and also supports cross compilation.*
*This document only covers building with CMake and Visual Studio under Windows.*


Pre-Requisites
--------------

1. [Cmake](https://www.cmake.org)
2. [Visual Studio Community 2015/2017](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx)


Configuring AJBSP (CMakeLists.txt)
----------------------------------

1. Open CMake-GUI.

2. Set the source code directory to your AJBSP source folder and the build
   directory to a subdirectory called `build` (or however you choose to name
   these).

3. Click **Configure** and CMake-GUI will open a new window for configuration
   options.  *This step is version-dependent and coincides with the version
   of Visual Studio you have installed!*
    - (3a) If you have Visual Studio Community 15, the generator would be
      *Visual Studio 14 2015*.
    - (3b) If you have Visual Studio Community 17, the generator would be
      *Visual Studio 15 2017*.
    - (3c) Use the [-T] parameter `v140_xp` if you want to compile with Windows
      XP support. If you are using Visual Studio 2017, the [-T] parameter would
      instead be `v141_xp` for Visual Studio Community 2017. If you do not care
      about running the project with Windows XP, you should skip this parameter
      altogether.

4. For most people, the default 'Use default native compilers' is sufficient.
   If you are a [vcpkg](https://github.com/Microsoft/vcpkg) user, please refer
   to step (4a), if not, click **Finish** and go to step (5).
   - (4a) If you use [Microsoft's vcpkg](https://github.com/Microsoft/vcpkg)
     service under Windows for library building and linking, you will instead
     select *Specify toolchain file for cross-compiling*. Click **Next**, and
     you will be prompted to specify the vcpkg buildscript. This file usually
     resides in `C:/vcpkg/scripts/buildsystems/`, unless your hard drive or
     vcpkg location is different. Select `vcpkg.cmake` and continue. If you
     haven't already, you should run the command `.\vcpkg integrate install`
     using PowerShell, as this will make vcpkg's build system universally
     included by Visual Studio (this option also works even if a vcpkg
     toolchain is not explicitly specified).

5. Once Configure completes successfully, click **Generate** and then you'll
   get a file called `ajbsp.sln` in the build folder, which you can use to
   compile AJBSP with Visual Studio Community 2015 or 2017 (other VS versions
   are untested, but should work in theory).


Building AJBSP (Visual Studio Community)
----------------------------------------

1. Go to the directory where Cmake-GUI set your Build directory.
2. Open up `ajbsp.sln` (solution project).
3. Right click the entire solution, and then 'Build Solution'.
4. Depending on what you are building with (Debug, Release, RelWithDebInfo),
   you will find it in the appropriate folder in the VS Build directory you
   specified (named `ajbsp.exe`).
