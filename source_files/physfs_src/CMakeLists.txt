project(
  obsidian_physfs
  LANGUAGES CXX
  VERSION 0.1.0
)

add_library(
  obsidian_physfs
  physfs.cc
  physfs.h
  physfs_archiver_7z.cc
  physfs_archiver_dir.cc
  physfs_archiver_grp.cc
  physfs_archiver_hog.cc
  physfs_archiver_iso9660.cc
  physfs_archiver_mvl.cc
  physfs_archiver_qpak.cc
  physfs_archiver_slb.cc
  physfs_archiver_unpacked.cc
  physfs_archiver_vdf.cc
  physfs_archiver_wad.cc
  physfs_archiver_zip.cc
  physfs_byteorder.cc
  physfs_casefolding.h
  physfs_internal.h
  physfs_lzmasdk.h
  physfs_miniz.h
  # physfs_platform_apple.m
  # physfs_platform_os2.cc
  physfs_platform_posix.cc
  physfs_platform_qnx.cc
  physfs_platform_unix.cc
  physfs_platform_windows.cc
  physfs_platforms.h
  physfs_unicode.cc
)
