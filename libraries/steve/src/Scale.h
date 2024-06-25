#pragma once

#include <string>
#include <vector>

#include "Chord.h"
#include "ItemDescription.h"
#include "Steve.h"

namespace steve {
  struct ScaleDescription : public ItemDescription {
    std::vector<Chord> chords;
    ToneSet tones = 1;

    void compute_chords(const class Config&);
  };
  struct Scale {
    std::shared_ptr<const ScaleDescription> desc;
    uint8_t key = 0;
    ToneSet tones = 0;

    inline Scale(const std::shared_ptr<const ScaleDescription>& d, uint8_t k)
      : desc(d), key(k), tones(tone_set_shift(d->tones, k)) {}

    inline std::string full_name() const { return std::string(key_name(key)) + " " + desc->name; }

    // Zero-based
    uint8_t get_degree_for_tone(uint8_t tone) const;
    std::string get_degree_string_for_chord(const Chord& chord) const;
  };
}
