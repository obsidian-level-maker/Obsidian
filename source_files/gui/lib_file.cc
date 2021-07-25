//------------------------------------------------------------------------
//  File Utilities
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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

#include "lib_file.h"

#include <algorithm>
#include <whereami.h>

#include "fmt/format.h"
#include "headers.h"
#include "lib_util.h"

#ifdef WIN32
#include <io.h>
#endif

#ifdef UNIX
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#endif

#ifdef __APPLE__
#include <mach-o/dyld.h>  // _NSGetExecutablePath
#include <sys/param.h>
#endif

bool HasExtension(const char *filename) {
    int A = (int)strlen(filename) - 1;

    if (A > 0 && filename[A] == '.') {
        return false;
    }

    for (; A >= 0; A--) {
        if (filename[A] == '.') {
            return true;
        }

        if (filename[A] == '/') {
            break;
        }

#ifdef WIN32
        if (filename[A] == '\\' || filename[A] == ':') break;
#endif
    }

    return false;
}

//
// MatchExtension
//
// When ext is NULL or "", checks if the file has no extension.
//
bool MatchExtension(std::string_view filename, std::string_view ext) {
    if (ext.empty()) {
        return !HasExtension(filename);
    }

    int A = filename.size() - 1;
    int B = ext.size() - 1;

    for (; B >= 0; B--, A--) {
        if (A < 0) {
            return false;
        }

        if (toupper(filename[A]) != toupper(ext[B])) {
            return false;
        }
    }

    return (A >= 1) && (filename[A] == '.');
}

//
// ReplaceExtension
//
// When ext is NULL or "", any existing extension is removed.
//
// Returned string is a COPY.
//
std::string ReplaceExtension(const char *filename, const char *ext) {
    SYS_ASSERT(filename[0] != 0);

    size_t total_len = strlen(filename) + (ext ? strlen(ext) : 0);

    std::string buffer{filename};

    auto dot_pos = buffer.rbegin();

    for (; dot_pos != buffer.rend() && *dot_pos != '.'; ++dot_pos) {
        if (*dot_pos == '/') {
            break;
        }

#ifdef WIN32
        if (*dot_pos == '\\' || *dot_pos == ':') break;
#endif
    }

    if (dot_pos != buffer.rend() && *dot_pos != '.') {
        dot_pos = buffer.rend();
    }

    if (!(ext && ext[0])) {
        if (dot_pos != buffer.rend()) {
            buffer.resize(buffer.rend() - dot_pos);
        }

        return buffer;
    }

    if (dot_pos != buffer.rend()) {
        dot_pos[1] = 0;
    } else {
        buffer.push_back('.');
    }

    buffer.append(ext);

    return buffer;
}

const char *FindBaseName(const char *filename) {
    // Find the base name of the file (i.e. without any path).
    // The result always points within the given string.
    //
    // Example:  "C:\Foo\Bar.wad"  ->  "Bar.wad"

    const char *pos = filename + strlen(filename) - 1;

    for (; pos >= filename; pos--) {
        if (*pos == '/') {
            return pos + 1;
        }

#ifdef WIN32
        if (*pos == '\\' || *pos == ':') return pos + 1;
#endif
    }

    return filename;
}

bool FilenameIsBare(const char *filename) {
    if (strchr(filename, '.')) {
        return false;
    }
    if (strchr(filename, '/')) {
        return false;
    }
    if (strchr(filename, '\\')) {
        return false;
    }
    if (strchr(filename, ':')) {
        return false;
    }

    return true;
}

void FilenameStripBase(char *buffer) {
    char *pos = buffer + strlen(buffer) - 1;

    for (; pos > buffer; pos--) {
        if (*pos == '/') {
            break;
        }

#ifdef WIN32
        if (*pos == '\\') break;

        if (*pos == ':') {
            pos[1] = 0;
            return;
        }
#endif
    }

    if (pos > buffer) {
        *pos = 0;
    } else {
        strcpy(buffer, ".");
    }
}

void FilenameGetPath(char *dest, size_t maxsize, const char *filename) {
    size_t len = (size_t)(FindBaseName(filename) - filename);

    // remove trailing slash (except when following "C:" or similar)
    if (len >= 1 && (filename[len - 1] == '/' || filename[len - 1] == '\\') &&
        !(len >= 2 && filename[len - 2] == ':')) {
        len--;
    }

    if (len == 0) {
        strcpy(dest, ".");
        return;
    }

    if (len >= maxsize) {
        len = maxsize - 1;
    }

    strncpy(dest, filename, len);
    dest[len] = 0;
}

bool FileCopy(const char *src_name, const char *dest_name) {
    char buffer[1024];

    FILE *src = fopen(src_name, "rb");
    if (!src) {
        return false;
    }

    FILE *dest = fopen(dest_name, "wb");
    if (!dest) {
        fclose(src);
        return false;
    }

    while (true) {
        size_t rlen = fread(buffer, 1, sizeof(buffer), src);
        if (rlen == 0) {
            break;
        }

        size_t wlen = fwrite(buffer, 1, rlen, dest);
        if (wlen != rlen) {
            break;
        }
    }

    bool was_OK = !ferror(src) && !ferror(dest);

    fclose(dest);
    fclose(src);

    return was_OK;
}

bool FileRename(const char *old_name, const char *new_name) {
#ifdef WIN32
    return (::MoveFile(old_name, new_name) != 0);

#else  // UNIX or MacOSX

    return (rename(old_name, new_name) == 0);
#endif
}

bool FileDelete(const char *filename) {
#ifdef WIN32
    return (::DeleteFile(filename) != 0);

#else  // UNIX or MacOSX

    return (remove(filename) == 0);
#endif
}

bool FileChangeDir(const char *dir_name) {
#ifdef WIN32
    return (::SetCurrentDirectory(dir_name) != 0);

#else  // UNIX or MacOSX

    return (chdir(dir_name) == 0);
#endif
}

bool FileMakeDir(const char *dir_name) {
#ifdef WIN32
    return (::CreateDirectory(dir_name, NULL) != 0);

#else  // UNIX or MacOSX

    return (mkdir(dir_name, 0775) == 0);
#endif
}

byte *FileLoad(const char *filename, int *length) {
    *length = 0;

    FILE *fp = fopen(filename, "rb");

    if (!fp) {
        return NULL;
    }

    // determine size of file (via seeking)
    fseek(fp, 0, SEEK_END);
    { (*length) = (int)ftell(fp); }
    fseek(fp, 0, SEEK_SET);

    if (ferror(fp) || *length < 0) {
        fclose(fp);
        return NULL;
    }

    byte *data = (byte *)malloc(*length + 1);

    if (!data) {
        AssertFail("Out of memory (%d bytes for FileLoad)\n", *length);
    }

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

void FileFree(const byte *mem) {
    if (mem) {
        free((void *)mem);
    }
}

//
// Note: returns false when the path doesn't exist.
//
bool PathIsDirectory(const char *path) {
#ifdef WIN32
    char old_dir[MAX_PATH + 1];

    if (GetCurrentDirectory(MAX_PATH, (LPSTR)old_dir) == FALSE) return false;

    bool result = SetCurrentDirectory(path);

    SetCurrentDirectory(old_dir);

    return result;

#else  // UNIX or MacOSX

    struct stat finfo;

    if (stat(path, &finfo) != 0) {
        return false;
    }

    return (S_ISDIR(finfo.st_mode)) ? true : false;
#endif
}

std::string FileFindInPath(const char *paths, const char *base_name) {
    // search through the path list (separated by ';') to find the file.
    // If found, the complete filename is returned (which must be freed
    // using StringFree).  If not found, NULL is returned.

    for (;;) {
        const char *sep = strchr(paths, ';');
        int len = sep ? (sep - paths) : strlen(paths);

        SYS_ASSERT(len > 0);

        std::string filename = fmt::format("{:{}}/{}", paths, len, base_name);

        //  fprintf(stderr, "Trying data file: [%s]\n", filename);

        if (FileExists(filename.c_str())) {
            return filename;
        }

        if (!sep) {
            return "";  // not found
        }

        paths = sep + 1;
    }
}

//------------------------------------------------------------------------

int ScanDirectory(std::string_view path, directory_iter_f func,
                  void *priv_dat) {
    int count = 0;
    for (auto p : std::filesystem::directory_iterator{path}) {
        int flags = 0;

        if (p.is_directory()) {
            flags |= SCAN_F_IsDir;
        }

        if ((std::filesystem::status(p.path()).permissions() &
             (std::filesystem::perms::owner_write |
              std::filesystem::perms::group_write |
              std::filesystem::perms::others_write)) ==
            std::filesystem::perms::none) {
            flags |= SCAN_F_ReadOnly;
        }

        if (p.path().stem().native()[0] == '.') {
            flags |= SCAN_F_Hidden;
        }

        func(p.path().native(), flags, priv_dat);

        count++;
    }

    return count;
}

struct filename_nocase_CMP {
    inline bool operator()(std::string_view A, std::string_view B) const {
        return StringCaseCmp(A, B) < 0;
    }
};

struct scan_match_data_t {
    std::vector<std::string> &list;
    std::string_view ext;
};

static void add_matching_name(std::string_view name, int flags,
                              void *priv_dat) {
    scan_match_data_t *match_data = (scan_match_data_t *)priv_dat;

    auto &list = match_data->list;

    if ((flags & SCAN_F_Hidden) || name[0] == '.') {
        return;
    }

    if (flags & SCAN_F_IsDir) {
        return;
    }

    if (!MatchExtension(name, match_data->ext)) {
        return;
    }

    list.emplace_back(name);
}

int ScanDir_MatchingFiles(std::string_view path, std::string_view ext,
                          std::vector<std::string> &list) {
    scan_match_data_t data{list, ext};

    int count = ScanDirectory(path, add_matching_name, &data);

    if (count > 0) {
        std::sort(list.begin(), list.end(), filename_nocase_CMP());
    }

    return count;
}

//------------------------------------------------------------------------

std::filesystem::path GetExecutablePath() {
    size_t length = wai_getExecutablePath(nullptr, 0, nullptr);
    std::string path;
    path.resize(length + 1);
    wai_getExecutablePath(path.data(), length, nullptr);
    path[length] = '\0';
    return path;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
