#pragma once

#include "ChordBasedCreator.h"

namespace steve
{
class Chords : public ChordBasedCreator
{
  public:
    Chords(Music *);
    Notes       get(size_t start, size_t size) const override;
    const char *name() const override
    {
        return "Chords";
    }
    bool is_valid_instrument(const struct Instrument &instrument) const override;
};
} // namespace steve
