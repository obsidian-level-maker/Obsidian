#include "ChordBasedCreator.h"

#include "../Music.h"
#include "../Rand.h"

using namespace steve;

ChordBasedCreator::ChordBasedCreator(Music* music) : Creator(music) {}
void ChordBasedCreator::init() {
  Creator::init();
  _min_time = Rand::next(NoteValue::quarter, NoteValue::whole);
  _max_time = Rand::next(_min_time, NoteValue::whole);
}
std::vector<uint8_t> ChordBasedCreator::chord_for(uintptr_t start, size_t size) const {
  const ToneSet chord(_music->tones_at(start, size));
  const uint8_t octave(Rand::next(_min_tone / 12, _max_tone / 12) * 12);

  // Get chord tones in a vector
  std::vector<uint8_t> tones;
  for(uint8_t t(0); t < 12; t++) {
    if(chord & 1 << t) {
      tones.push_back(t + octave);
    }
  }
  return tones;
}