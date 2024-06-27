#pragma once

#include "ItemDescription.h"
#include "Steve.h"

namespace steve {
  struct TimeSignature : public ItemDescription {
    uint32_t beats_per_bar = 4;
    NoteValue beat_value = NoteValue::quarter;
  };
}
