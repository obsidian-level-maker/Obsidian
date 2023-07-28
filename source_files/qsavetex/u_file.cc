//------------------------------------------------------------------------
//  File Utilities
//------------------------------------------------------------------------
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (c) 2008-2017  Andrew J Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "main.h"

/*#ifdef WIN32
#include <io.h>
#endif

#ifdef UNIX
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#endif

#ifdef MACOSX
#include <mach-o/dyld.h>  // _NSGetExecutablePath
#include <sys/param.h>
#endif

#ifndef PATH_MAX
#define PATH_MAX 2048
#endif*/

bool FileExists(std::filesystem::path filename) {
    return std::filesystem::exists(filename);
}

bool HasExtension(std::filesystem::path filename) {
    return filename.has_extension();
}

bool CheckExtension(std::filesystem::path filename, std::string ext) {
    if (ext.empty()) return !HasExtension(filename);

    int A = filename.string().size() - 1;
    int B = ext.size() - 1;

    for (; B >= 0; B--, A--) {
        if (A < 0) return false;

        if (toupper(filename.string().at(A)) != toupper(ext.at(B))) return false;
    }

    return (A >= 1) && (filename.string().at(A) == '.');
}

std::filesystem::path ReplaceExtension(std::filesystem::path filename, std::string ext) {
    return filename.replace_extension(ext);
}

std::filesystem::path FindBaseName(std::filesystem::path filename) {
    return filename.filename();
}

void FilenameStripBase(char *buffer) {
    char *pos = buffer + strlen(buffer) - 1;

    for (; pos > buffer; pos--) {
        if (*pos == '/') break;

#ifdef WIN32
        if (*pos == '\\') break;

        if (*pos == ':') {
            pos[1] = 0;
            return;
        }
#endif
    }

    if (pos > buffer)
        *pos = 0;
    else
        strcpy(buffer, ".");
}

bool FileCopy(std::filesystem::path src_name, std::filesystem::path dest_name) {
    return std::filesystem::copy_file(src_name, dest_name);
}

bool FileRename(std::filesystem::path old_name, std::filesystem::path new_name) {
    if (std::filesystem::exists(new_name)) { return false; } // Fail if target name already exists
    std::filesystem::rename(old_name, new_name);
    return std::filesystem::exists(new_name); // Should return false if it didn't work for whatever reason
}

bool FileDelete(std::filesystem::path filename) {
    std::filesystem::remove(filename);
    return std::filesystem::exists(filename);
}

bool FileChangeDir(std::filesystem::path dir_name) {
    std::filesystem::current_path(dir_name);
    return std::filesystem::equivalent(dir_name, std::filesystem::current_path());
}

bool FileMakeDir(std::filesystem::path dir_name) {
    return std::filesystem::create_directory(dir_name);
}

u8_t *FileLoad(std::filesystem::path filename, int *length) {
    *length = 0;

    FILE *fp = fopen(filename.generic_u8string().c_str(), "rb");

    if (!fp) return NULL;

    // determine size of file (via seeking)
    fseek(fp, 0, SEEK_END);
    { (*length) = (int)ftell(fp); }
    fseek(fp, 0, SEEK_SET);

    if (ferror(fp) || *length < 0) {
        fclose(fp);
        return NULL;
    }

    u8_t *data = (u8_t *)malloc(*length + 1);

    if (!data) FatalError("Out of memory (%d bytes for FileLoad)\n", *length);

    // ensure buffer is NUL-terminated
    data[*length] = 0;

    if (1 != fread(data, *length, 1, fp)) {
        FileFree(data);
        fclose(fp);
        return NULL;
    }

    fclose(fp);

    return data;
}

void FileFree(u8_t *mem) { free((void *)mem); }

//
// Note: returns false when the path doesn't exist.
//
bool PathIsDirectory(std::filesystem::path path) {
 return std::filesystem::is_directory(path);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
