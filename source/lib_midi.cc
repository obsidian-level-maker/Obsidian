#include <fstream>
#include <sstream>

#include "ConfigJson.h"
#include "Music.h"
#include "Steve.h"
#include "lib_util.h"
#include "main.h"
#include "physfs.h"
#include "sys_assert.h"
#include "sys_debug.h"

bool steve_generate(const char *config_file, const char *out_file)
{

    SYS_ASSERT(config_file && out_file);

    steve::note_name_init();

    steve::ConfigJson config;

    PHYSFS_File *config_fp = PHYSFS_openRead(config_file);

    if (!config_fp)
    {
        LogPrint("Unable to open MIDI generator config %s!\n", config_file);
        return false;
    }

    size_t   len = PHYSFS_fileLength(config_fp);
    uint8_t *buf = new uint8_t[len];

    if (PHYSFS_readBytes(config_fp, buf, len) != len)
    {
        PHYSFS_close(config_fp);
        delete[] buf;
        LogPrint("Unable to read MIDI generator config %s!\n", config_file);
        return false;
    }

    PHYSFS_close(config_fp);

    config.parse_buffer((const char *)buf, len);

    delete[] buf;

    config.compute_cache();

    steve::Music  music(config);
    std::ofstream fs(PathAppend(home_dir, out_file), std::ofstream::binary);
    music.write_mid(fs);
    std::string        music_debug;
    std::ostringstream ss(music_debug);
    music.write_txt(ss);
    ss.flush();
    LogPrint("MIDI Statistics for %s:\n", out_file);
    LogPrint("%s\n", ss.str().c_str());

    return true;
}
