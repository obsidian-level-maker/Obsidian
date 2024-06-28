#pragma once

#include <cstdint>

#include "ItemDescription.h"

namespace steve
{
struct Instrument : ItemDescription
{
    uint8_t midi_id;
    uint8_t min_tone = 0, max_tone = 127;
    uint8_t voices = 1;
};
} // namespace steve
