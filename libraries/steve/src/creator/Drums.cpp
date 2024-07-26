#include "Drums.h"

#include "../Music.h"
#include "../Rand.h"

using namespace steve;

static const std::vector<uint8_t> bass = {35, 36};
static const std::vector<uint8_t> snare = {38, 40};
static const std::vector<uint8_t> tom = {41,43,45,47,48,50};
static const std::vector<uint8_t> hi_hat = {42,44,46};
static const std::vector<uint8_t> cymbal = {49,51,55,57,59};

Drums::Drums(Music *music) : Creator(music)
{
}
void Drums::init()
{
    Creator::init();
    _channel    = 9;
    _repetition = 1;
}
Notes Drums::get(size_t, size_t size) const
{
    Notes notes;

    const auto bar_ticks  = _music->get_bar_ticks();
    NoteValue  max_period = NoteValue::whole;
    while (((bar_ticks / ticks_for(max_period)) * ticks_for(max_period)) != bar_ticks)
    {
        // We use only periods that can divide the bar to avoid weird things
        // it would be better to actually have an idea of how drums should sound
        // (this was introduced because of time signatures)
        max_period = NoteValue(uint32_t(max_period) - 1);
    }

    uint32_t layers(Rand::next(2, 5));
    for (uint32_t i(0); i < layers; i++)
    {
        uint8_t tone;
        NoteValue period_value; // = (max_period <= NoteValue::quarter) ? max_period : Rand::next(NoteValue::quarter, max_period);
        //NoteValue period_value = Rand::next(NoteValue::eighth, max_period);
        uintptr_t period;//       = ticks_for(period_value);
        //uintptr_t offset       = ticks_for(Rand::next(NoteValue::eighth, period_value));
        uintptr_t offset;//       = ticks_for((period_value <= NoteValue::quarter) ? period_value : Rand::next(NoteValue::quarter, period_value));
        switch (i)
        {
            case 0:
                tone = Rand::in(bass);
                period_value = (max_period <= NoteValue::half) ? max_period : Rand::next(NoteValue::half, max_period);
                period = ticks_for(period_value);
                offset = ticks_for((period_value <= NoteValue::quarter) ? period_value : Rand::next(NoteValue::quarter, period_value));
                break;
            case 1:
                tone = Rand::in(snare);
                period_value = (max_period <= NoteValue::quarter) ? max_period : Rand::next(NoteValue::quarter, max_period);
                period = ticks_for(period_value);
                offset = ticks_for((period_value <= NoteValue::eighth) ? period_value : Rand::next(NoteValue::eighth, period_value));
                break;
            case 2:
                tone = Rand::in(tom);
                period_value = (max_period <= NoteValue::eighth) ? max_period : Rand::next(NoteValue::eighth, max_period);
                period = ticks_for(period_value);
                offset = ticks_for((period_value <= NoteValue::sixteenth) ? period_value : Rand::next(NoteValue::sixteenth, period_value));
                break;
            case 3:
                tone = Rand::in(hi_hat);
                period_value = (max_period <= NoteValue::eighth) ? max_period : Rand::next(NoteValue::eighth, max_period);
                period = ticks_for(period_value);
                offset = ticks_for((period_value <= NoteValue::sixteenth) ? period_value : Rand::next(NoteValue::sixteenth, period_value));
                break;
            case 4:
                tone = Rand::in(cymbal);
                period_value = (max_period <= NoteValue::eighth) ? max_period : Rand::next(NoteValue::eighth, max_period);
                period = ticks_for(period_value);
                offset = ticks_for((period_value <= NoteValue::sixteenth) ? period_value : Rand::next(NoteValue::sixteenth, period_value));
                break;
            default:
                break;
        }
        if (i == 0 || Rand::next(0, 3) > 0)
        {
            offset = 0;
        }
        for (uintptr_t j(offset); j < size; j += period)
        {
            if (_music->is_beat(j))
            {
                add_note(notes, _channel, tone, j, 1, 100);
            }
        }
    }
    return notes;
}
