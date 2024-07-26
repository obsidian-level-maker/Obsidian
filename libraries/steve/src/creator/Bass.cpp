#include "Bass.h"

#include "../Music.h"

using namespace steve;

Bass::Bass(Music *music) : Creator(music)
{
}
void Bass::init()
{
    Creator::init();
}
Notes Bass::get(size_t start, size_t size) const
{
    Notes     notes;
    auto      times = generate_times(start, _music->get_bar_ticks());
    uintptr_t i     = 0;
    while (i < size)
    {
        for (uintptr_t j = 0; j < times.size() - 1; j++)
        {
            const auto    duration = times[j + 1] - times[j];
            const Chord  &chord    = _music->chord_at(start + i);
            const uint8_t tone     = _min_tone + chord.key;
            add_note(notes, _channel, tone, i, duration);
            i += duration;
        }
    }
    return notes;
}
bool Bass::is_valid_instrument(const Instrument &instrument) const
{
    return instrument.midi_id >= 32 && instrument.midi_id <= 39;
}
