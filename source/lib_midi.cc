#include <fstream>

#include "ConfigJson.h"
#include "Music.h"
#include "Steve.h"

void steve_generate(const char *config_file, const char *out_file) {

  int num = 1;

  steve::note_name_init();

  steve::ConfigJson config;
  config.parse_file(config_file);
  config.compute_cache();

  for(uint32_t i = 0; i < num; i++) {
    std::string music_path;
    steve::Music music(config);
    if(!out_file) {
      music_path = music.to_short_string();
      music_path.append(".mid");
    }
    else
      music_path = out_file;
    std::ofstream fs(music_path, std::ofstream::binary);
    music.write_mid(fs);
  }
}
