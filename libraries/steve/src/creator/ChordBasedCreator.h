#pragma once

#include "Creator.h"

namespace steve {
  class ChordBasedCreator : public Creator {
  protected:
    ChordBasedCreator(Music* music);
    virtual void init() override;
    virtual std::vector<uint8_t> chord_for(uintptr_t start, size_t size) const;
  };
}
