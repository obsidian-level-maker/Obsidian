#pragma once

#include "Creator.h"

namespace steve
{
class Drums : public Creator
{
  public:
    Drums(Music *music);
    virtual void        init() override;
    virtual Notes       get(size_t start, size_t size) const override;
    virtual const char *name() const override
    {
        return "Drums";
    }
};
} // namespace steve
