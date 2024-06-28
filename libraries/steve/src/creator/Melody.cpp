#include "Melody.h"

#include "../Music.h"
#include "../Rand.h"

using namespace steve;

Melody::Melody(Music *music) : Creator(music)
{
}
Notes Melody::get(size_t start, size_t size) const
{
    Notes notes;
    auto  times = generate_times(start, size);
    for (uintptr_t i = 0; i < times.size() - 1; i++)
    {
        const auto time     = times[i];
        const auto duration = times[i + 1] - time;
        const auto tones    = choose_note_from_chord(_music->tones_at(start + time, duration));
        const auto tone     = Rand::in(tones);
        add_note(notes, _channel, tone, time, duration);
    }
    return notes;
}
std::set<uint8_t> Melody::choose_note_from_chord(const ToneSet &tones) const
{
    std::set<uint8_t> notes_in_ambitus;
    for (uint8_t tone(0); tone < 12; tone++)
    {
        if (tones & (1 << tone))
        {
            for (uint8_t t(tone); t <= _max_tone; t += 12)
            {
                if (t >= _min_tone)
                {
                    notes_in_ambitus.insert(t);
                }
            }
        }
    }
    return notes_in_ambitus;
}