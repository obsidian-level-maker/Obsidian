#pragma once

#include "ChordBasedCreator.h"

namespace steve
{
class Arpeggio : public ChordBasedCreator
{
  public:
    Arpeggio(Music *);
    virtual void        init() override;
    virtual Notes       get(size_t start, size_t size) const override;
    virtual const char *name() const override
    {
        return "Arpeggio";
    }
};
} // namespace steve
