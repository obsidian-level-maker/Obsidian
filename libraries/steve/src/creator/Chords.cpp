#include "Chords.h"

#include "../Instrument.h"
#include "../Music.h"

using namespace steve;

Chords::Chords(Music *music) : ChordBasedCreator(music)
{
}
Notes Chords::get(size_t start, size_t size) const
{
    Notes     notes;
    auto      times = generate_times(start, _music->get_bar_ticks());
    uintptr_t i     = 0;
    while (i < size)
    {
        for (uintptr_t j = 0; j < times.size() - 1; j++)
        {
            const auto   duration    = times[j + 1] - times[j];
            const Chord &chord       = _music->chord_at(start + i);
            uint8_t      voice_count = 0;
            for (uint8_t tone = _min_tone; tone < _max_tone && voice_count < _instrument->voices; tone++)
            {
                if (voice_count == 0 && (tone % 12) != chord.key)
                {
                    // continue; // Lowest tone need to be key
                }
                if (((1 << (tone % 12)) & chord.tones) != 0)
                {
                    add_note(notes, _channel, tone, i, duration);
                    voice_count++;
                }
            }
            i += duration;
        }
    }
    return notes;
}

bool Chords::is_valid_instrument(const Instrument &instrument) const
{
    return instrument.voices >= 3;
}