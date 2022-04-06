project(
  obsidian_physfs
  LANGUAGES C
  VERSION 0.1.0
)

add_library(
  obsidian_physfs
  physfs.c
  physfs_archiver_7z.c
  physfs_archiver_dir.c
  physfs_archiver_grp.c
  physfs_archiver_hog.c
  physfs_archiver_iso9660.c
  physfs_archiver_mvl.c
  physfs_archiver_qpak.c
  physfs_archiver_slb.c
  physfs_archiver_unpacked.c
  physfs_archiver_vdf.c
  physfs_archiver_wad.c
  physfs_archiver_zip.c
  physfs_byteorder.c
  physfs_platform_posix.c
  physfs_platform_qnx.c
  physfs_platform_unix.c
  physfs_platform_windows.c
  physfs_unicode.c
)
