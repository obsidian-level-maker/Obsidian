//----------------------------------------------------------------------
//  Addons Loading and Selection GUI
//----------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
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
//----------------------------------------------------------------------

#include "m_addons.h"

#include "headers.h"

#include "fmt/core.h"
#ifndef CONSOLE_ONLY
#include "hdr_fltk.h"
#include "hdr_ui.h"
#endif
#include "lib_argv.h"
#include "lib_file.h"
#include "lib_util.h"
#include "m_cookie.h"
#include "main.h"
#include "physfs.h"

// need this because the OPTIONS file is loaded *before* the addons
// folder is scanned for valid archives, so remember enabled ones here.
std::map<std::filesystem::path, int> initial_enabled_addons;

std::vector<addon_info_t> all_addons;

void VFS_AddFolder(std::string name) {
#ifdef _WIN32
    std::filesystem::path path = physfs_dir;
#else
    std::filesystem::path path = install_dir;
#endif
    path /= name;
    std::string mount = fmt::format("/{}", name);

    if (!PHYSFS_mount(path.string().c_str(), mount.c_str(), 0)) {
        Main::FatalError("Failed to mount '{}' folder in PhysFS:\n{}\n", name,
                         PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        return; /* NOT REACHED */
    }

    DebugPrintf("mounted folder '{}'\n", name);
}

bool VFS_AddArchive(std::filesystem::path filename, bool options_file) {
    LogPrintf("  using: {}\n", filename.string());

   // when handling "bare" filenames from the command line (i.e. ones
    // containing no paths or drive spec) and the file does not exist in
    // the current dir, look for it in the standard addons/ folder.
    if ((!std::filesystem::exists(filename) && !filename.has_parent_path())) {
        std::filesystem::path new_name =
            fmt::format("{}/addons/{}", home_dir.string(), filename.string());
        if (!std::filesystem::exists(new_name)) {
            new_name = fmt::format("{}/addons/{}", install_dir.string(),
                                   filename.string());
        }
        filename = new_name;
    }

    if (!PHYSFS_mount(filename.string().c_str(), "/", 0)) {
        if (options_file) {
            LogPrintf(
                fmt::format("Failed to mount '{}' archive in PhysFS:\n{}\n",
                            filename.string(),
                            PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()))
                    .c_str());
        } else {
            Main::FatalError("Failed to mount '{}' archive in PhysFS:\n{}\n",
                             filename.string(),
                             PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        }

        return false;
    }

    return true;  // Ok
}

void VFS_InitAddons(const char *argv0) {
    LogPrintf("Initializing VFS...\n");

    if (!PHYSFS_init(argv0)) {
        Main::FatalError("Failed to init PhysFS:\n{}\n",
                         PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
    }

    VFS_AddFolder("scripts");
    VFS_AddFolder("games");
    VFS_AddFolder("engines");
    VFS_AddFolder("modules");
    VFS_AddFolder("data");
    VFS_AddFolder("ports");

    LogPrintf("DONE.\n\n");
}

void VFS_ParseCommandLine() {
    int arg = argv::Find('a', "addon");
    int count = 0;

    if (arg < 0) {
        return;
    }

    arg++;

    LogPrintf("Command-line addons....\n");

    for (; arg < argv::list.size() && !argv::IsOption(arg); arg++, count++) {
        VFS_AddArchive(argv::list[arg], false /* options_file */);
    }

    if (!count) {
        Main::FatalError("Missing filename for --addon option\n");
    }

    LogPrintf("DONE\n\n");
}

void VFS_OptParse(std::string name) {
    // just remember it now
    if (initial_enabled_addons.find(name) == initial_enabled_addons.end()) {
        initial_enabled_addons[name] = 1;
    }
}

void VFS_OptWrite(std::ofstream &fp) {
    fp << "---- Enabled Addons ----\n\n";

    for (unsigned int i = 0; i < all_addons.size(); i++) {
        const addon_info_t *info = &all_addons[i];

        if (info->enabled) {
            fp << "addon = " << info->name.string() << "\n";
        }
    }

    fp << "\n";
}

void VFS_ScanForAddons() {
    LogPrintf("Scanning for addons....\n");

    all_addons.clear();

    std::filesystem::path dir_name = install_dir;
    dir_name /= "addons";

    std::vector<std::filesystem::path> list;
    int result1 = 0;
    int result2 = 0;

    for (auto &file : std::filesystem::directory_iterator(dir_name)) {
        if (file.is_directory() || StringCaseCmp(file.path().extension().generic_string(), ".oaf") == 0) {
            if (PHYSFS_mount(file.path().string().c_str(), nullptr, 0)) {
                PHYSFS_unmount(file.path().string().c_str());
                result1 += 1;
                list.push_back(file.path());
            }
            else {
                LogPrintf(
                    fmt::format("Failed to mount '{}' archive in PhysFS:\n{}\n",
                                file.path().string(),
                                PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()))
                        .c_str());
            }
        }
    }

    if (StringCaseCmp(home_dir.generic_string(),
                      install_dir.generic_string()) != 0) {
        dir_name = home_dir;
        dir_name /= "addons";
        if (!std::filesystem::exists(dir_name)) {
            goto no_home_addon_dir;
        }

        std::vector<std::filesystem::path> list2;

        for (auto &file : std::filesystem::directory_iterator(dir_name)) {
            if (file.is_directory() || StringCaseCmp(file.path().extension().generic_string(), ".oaf") == 0) {
                if (PHYSFS_mount(file.path().string().c_str(), nullptr, 0)) {
                    PHYSFS_unmount(file.path().string().c_str());
                    result2 += 1;
                    list2.push_back(file.path());
                }
                else {
                    LogPrintf(
                    fmt::format("Failed to mount '{}' archive in PhysFS:\n{}\n",
                                file.path().string(),
                                PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()))
                        .c_str());
                }
            }
        }
        // std::vector<std::filesystem::path>().swap(list2);
        for (auto x : list2) {
            list.push_back(x);
        }
    }

no_home_addon_dir:

    if ((result1 < 0) && (result2 < 0)) {
        LogPrintf("FAILED -- no addon directory found.\n\n");
        return;
    }

    for (unsigned int i = 0; i < list.size(); i++) {
        addon_info_t info;

        info.name = list[i];

        info.enabled = false;

        if (initial_enabled_addons.find(list[i]) !=
            initial_enabled_addons.end()) {
            info.enabled = true;
        }

        // DEBUG
        // info.enabled = true;

        LogPrintf("  found: {}{}\n", info.name.string(),
                  info.enabled ? " (Enabled)" : " (Disabled)");

        all_addons.push_back(info);

        // if enabled, install into the VFS
        if (info.enabled) {
            VFS_AddArchive(info.name, true /* options_file */);
        }
    }

    if (list.size() == 0) {
        LogPrintf("DONE (none found)\n");
    } else {
        LogPrintf("DONE\n");
    }

    LogPrintf("\n");
}

//----------------------------------------------------------------------

//
// this is useful to "extract" something out of virtual FS to the real
// file system so we can use normal stdio file operations on it
// [ especially a _library_ that uses stdio.h ]
//
bool VFS_CopyFile(const char *src_name, const char *dest_name) {
    char buffer[1024];

    PHYSFS_file *src = PHYSFS_openRead(src_name);
    if (!src) {
        return false;
    }

    FILE *dest = fopen(dest_name, "wb");
    if (!dest) {
        PHYSFS_close(src);
        return false;
    }

    bool was_OK = true;

    while (was_OK) {
        int rlen = (int)(PHYSFS_readBytes(src, buffer, sizeof(buffer)) /
                         sizeof(buffer));
        if (rlen < 0) {
            was_OK = false;
        }

        if (rlen <= 0) {
            break;
        }

        int wlen = fwrite(buffer, 1, rlen, dest);
        if (wlen < rlen || ferror(dest)) {
            was_OK = false;
        }
    }

    fclose(dest);
    PHYSFS_close(src);

    return was_OK;
}

byte *VFS_LoadFile(const char *filename, int *length) {
    *length = 0;

    PHYSFS_File *fp = PHYSFS_openRead(filename);

    if (!fp) {
        return NULL;
    }

    *length = (int)PHYSFS_fileLength(fp);

    if (*length < 0) {
        PHYSFS_close(fp);
        return NULL;
    }

    byte *data = new byte[*length + 1];

    // ensure buffer is NUL-terminated
    data[*length] = 0;

    if ((PHYSFS_readBytes(fp, data, *length) / *length) != 1) {
        VFS_FreeFile(data);
        PHYSFS_close(fp);
        return NULL;
    }

    PHYSFS_close(fp);

    return data;
}

void VFS_FreeFile(const byte *mem) {
    if (mem) {
        delete[] mem;
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
