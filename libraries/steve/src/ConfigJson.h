#pragma once

#include "Config.h"
#include "ext/json.h"

namespace steve
{
class ConfigJson : public Config
{
  protected:
    std::vector<std::string> _directory_stack;

  public:
    void parse_file(const char *filepath);
    void parse_buffer(const char *buffer, size_t size);
    void parse_time_signatures(const json_object_s *);
    void parse_creators(const json_object_s *);
    void parse_creator(const json_object_s *, CreatorDescription &);
    void parse_chords(const json_object_s *);
    void parse_chord(const json_object_s *, ChordDescription &);
    void parse_scales(const json_object_s *);
    void parse_scale(const json_object_s *, ScaleDescription &);
    void parse_chord_changes(const json_object_s *);
    void parse_chord_change(const json_object_s *, const std::string &src, const std::string &tar,
                            const std::string &off);
    void parse_instruments(const json_object_s *);
    void parse_instrument(const json_object_s *, Instrument &);
    void parse_item(const json_object_s *, ItemDescription &);
};
} // namespace steve
