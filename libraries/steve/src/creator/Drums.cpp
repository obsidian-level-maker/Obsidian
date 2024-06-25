#include "Drums.h"

#include "../Music.h"
#include "../Rand.h"

using namespace steve;

Drums::Drums(Music* music) : Creator(music) {}
void Drums::init() {
  Creator::init();
  _channel = 9;
  _repetition = 1;
}
Notes Drums::get(size_t, size_t size) const {
  Notes notes;

  const auto bar_ticks = _music->get_bar_ticks();
  NoteValue max_period = NoteValue::whole;
  while(((bar_ticks / ticks_for(max_period)) * ticks_for(max_period)) != bar_ticks) {
    // We use only periods that can divide the bar to avoid weird things
    // it would be better to actually have an idea of how drums should sound
    // (this was introduced because of time signatures)
    max_period = NoteValue(uint32_t(max_period) - 1);
  }

  uint32_t layers(Rand::next(2, 5));
  for(uint32_t i(0); i < layers; i++) {
    uint8_t tone(Rand::next(35, 59));
    NoteValue period_value = Rand::next(NoteValue::eighth, max_period);
    uintptr_t period = ticks_for(period_value);
    uintptr_t offset = ticks_for(Rand::next(NoteValue::eighth, period_value));
    if(i == 0 || Rand::next(0, 3) > 0) {
      offset = 0;
    }

    for(uintptr_t j(offset); j < size; j += period) {
      if(_music->is_beat(j)) {
        add_note(notes, _channel, tone, j, 1, 100);
      }
    }
  }
  return notes;
}
