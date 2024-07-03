#pragma once

#include <functional>

#include "../Chord.h"
#include "../ItemDescription.h"
#include "../Steve.h"

namespace steve
{
struct CreatorDescription : public ItemDescription
{
    std::function<class Creator *(class Music *)> func;
    uint32_t                                      min_count = 0, max_count = 1;
};

class Creator
{
  protected:
    class Music                             *_music;
    std::shared_ptr<const struct Instrument> _instrument;
    std::vector<Phrase>                      _phrases;
    std::vector<uintptr_t>                   _phrase_list;
    size_t                                   _phrase_size;
    NoteValue                                _min_time, _max_time;
    uint8_t                                  _min_tone, _max_tone;
    float                                    _repetition;
    uint8_t                                  _channel;

  public:
    Creator(class Music *);
    virtual ~Creator()
    {
    }
    virtual void        init();
    virtual void        post_init();
    virtual Notes       compose();
    virtual Notes       get(size_t start, size_t size) const = 0;
    virtual const char *name() const                         = 0;
    virtual bool        is_valid_instrument(const Instrument &instrument) const;
    virtual void        write_txt(std::ostream &) const;

    inline std::shared_ptr<const Instrument> instrument() const
    {
        return _instrument;
    }

    uintptr_t              time(uintptr_t i, size_t size) const;
    std::vector<uintptr_t> generate_times(uintptr_t i, size_t size) const;
};
} // namespace steve
