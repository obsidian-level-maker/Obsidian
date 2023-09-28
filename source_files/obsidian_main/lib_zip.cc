//------------------------------------------------------------------------
//  ARCHIVE Handling - ZIP files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2009-2017 Andrew Apted
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

#include "lib_zip.h"

#include "lib_util.h"

#include "headers.h"

#include "miniz.h"

static std::filesystem::path current_zip;

//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

// Just a spot check to make sure the file doesn't exist
bool ZIPF_OpenWrite(const std::filesystem::path &filename) {
    if (std::filesystem::exists(filename)) {
        return false;
    }
    current_zip = filename;
    return true;
}

bool ZIPF_AddFile(const std::filesystem::path &filename) {
#ifdef _WIN32
    FILE *zip_file = _wfopen(filename.c_str(), (const wchar_t *)StringToUTF16("rb").c_str());
#else
    FILE *zip_file = fopen(filename.generic_string().c_str(), "rb");
#endif
    if (!zip_file) {
        return false;
    }
    uintmax_t zip_length = std::filesystem::file_size(filename);
    byte *zip_buf = new byte[zip_length];
    if (!zip_buf) {
        fclose(zip_file);
        return false;
    }
    memset(zip_buf, 0, zip_length);
    fread(zip_buf, 1, zip_length, zip_file);
    fclose(zip_file);
    if (mz_zip_add_mem_to_archive_file_in_place(
            current_zip.generic_u8string().c_str(),
            filename.filename().generic_u8string().c_str(), zip_buf,
            zip_length, NULL, 0, MZ_DEFAULT_COMPRESSION) == MZ_TRUE) {
        delete[] zip_buf;
        return true;
    } else {
        delete[] zip_buf;
        // Probably don't want to keep this zip file
        if (std::filesystem::exists(current_zip)) {
            std::filesystem::remove(current_zip);
        }
        return false;
    }
}

// Calling function is responsible for freeing *data
bool ZIPF_AddMem(std::string name, byte *data, size_t length) {
    if (mz_zip_add_mem_to_archive_file_in_place(
            current_zip.generic_u8string().c_str(),
            name.c_str(), data,
            length, NULL, 0, MZ_DEFAULT_COMPRESSION) == MZ_TRUE) {
        return true;
    } else {
        // Probably don't want to keep this zip file
        if (std::filesystem::exists(current_zip)) {
            std::filesystem::remove(current_zip);
        }
        return false;
    }
}

// Not super needed, but keeps the paradigm
void ZIPF_CloseWrite(void) {
    current_zip.clear();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
