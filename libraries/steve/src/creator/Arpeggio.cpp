#include "Arpeggio.h"

#include "../Music.h"
#include "../Rand.h"

using namespace steve;

Arpeggio::Arpeggio(Music *music) : ChordBasedCreator(music)
{
}
void Arpeggio::init()
{
    ChordBasedCreator::init();
    _min_time = NoteValue::sixteenth;
    _max_time = NoteValue::quarter;
}
Notes Arpeggio::get(size_t start, size_t size) const
{
    Notes     notes;
    auto      times = generate_times(start, _music->get_bar_ticks());
    uintptr_t i     = 0;
    while (i < size)
    {
        const uint8_t base_tone = _min_tone + 12 - (_min_tone % 12);
        for (uintptr_t j = 0; j < times.size() - 1; j++)
        {
            const Chord  &chord            = _music->chord_at(start + i);
            const auto    chord_tone_count = chord.desc->get_tone_count();
            const auto    duration         = times[j + 1] - times[j];
            const uint8_t tone             = base_tone + chord.key + chord.desc->get_tone(j % chord_tone_count);
            add_note(notes, _channel, tone, i, duration);
            i += duration;
        }
    }
    return notes;
}
