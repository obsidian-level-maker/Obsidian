#include <fstream>

#include "ConfigJson.h"
#include "Music.h"
#include "Steve.h"
#include "lib_util.h"
#include "main.h"
#include "physfs.h"
#include "sys_assert.h"
#include "sys_debug.h"

bool steve_generate(const char *config_file, const char *out_file) {

  SYS_ASSERT(config_file && out_file);

  steve::note_name_init();

  steve::ConfigJson config;

// all.json must be read in regardless; load additional config afterwards if selected
  PHYSFS_File *config_fp = PHYSFS_openRead("scripts/midi/all.json");

  if (!config_fp)
  {
    LogPrint("Unable to open MIDI generator config scripts/midi/all.json!\n");
    return false;
  }

  size_t len = PHYSFS_fileLength(config_fp);
  uint8_t *buf = new uint8_t[len];

  if (PHYSFS_readBytes(config_fp, buf, len) != len)
  {
    PHYSFS_close(config_fp);
    delete[] buf;
    LogPrint("Unable to read MIDI generator config scripts/midi/all.json!!\n");
    return false;
  }

  PHYSFS_close(config_fp);

  config.parse_buffer((const char *)buf, len);
  delete[] buf;

  if (GetFilename(config_file) != "all.json")
  {
    config_fp = PHYSFS_openRead(config_file);
    if (!config_fp)
    {
      LogPrint("Unable to open MIDI generator config %s!\n", config_file);
      return false;
    }

    len = PHYSFS_fileLength(config_fp);
    buf = new uint8_t[len];

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
  }
  
  config.compute_cache();

  steve::Music music(config);
  std::ofstream fs(PathAppend(home_dir, out_file), std::ofstream::binary);
  music.write_mid(fs);

  return true;

}
