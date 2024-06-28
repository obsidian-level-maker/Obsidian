#pragma once

#include <cstdint>

#include "Chord.h"
#include "ItemDescription.h"

namespace steve
{
struct ChordChange : ItemDescription
{
    std::shared_ptr<ChordDescription> source_chord, target_chord;
    uint8_t                           tone_shift = 0;
};
} // namespace steve
