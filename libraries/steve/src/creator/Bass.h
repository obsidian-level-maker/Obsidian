#pragma once

#include "Creator.h"

namespace steve {
  class Bass : public Creator {
  public:
    Bass(Music*);
    virtual void init() override;
    virtual Notes get(size_t start, size_t size) const override;
    virtual const char* name() const override { return "Bass"; }
    virtual bool is_valid_instrument(const Instrument& instrument) const override;
  };
}
