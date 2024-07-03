#pragma once

#include <memory>
#include <string>

#include "ItemDescription.h"
#include "Steve.h"

namespace steve
{
struct ChordDescription : public ItemDescription
{
    std::string suffix;
    ToneSet     tones     = 1;
    bool        uppercase = false;

    uint8_t get_tone(uint8_t index) const;

    inline uint8_t get_tone_count() const
    {
        return tone_set_count(tones);
    }
};

struct Chord
{
  public:
    std::shared_ptr<const ChordDescription> desc;
    uint8_t                                 key;
    ToneSet                                 tones;

    inline Chord(std::shared_ptr<const ChordDescription> desc, uint8_t key)
        : desc(desc), key(key), tones(tone_set_shift(desc->tones, key))
    {
    }

    std::string  to_short_string() const;
    inline Chord shifted(uint8_t semitones) const
    {
        return Chord(desc, (key + semitones) % 12);
    }
};
} // namespace steve
