#pragma once

#include "Creator.h"

namespace steve {
  class Melody : public Creator {
  public:
    Melody(Music*);
    Notes get(size_t start, size_t size) const override;
    const char* name() const override { return "Melody"; }
    std::set<uint8_t> choose_note_from_chord(const ToneSet& chord) const;
  };
}
