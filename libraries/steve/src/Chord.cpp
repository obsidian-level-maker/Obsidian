#include "Chord.h"

using namespace steve;

uint8_t ChordDescription::get_tone(uint8_t index) const {
  uint8_t tone = 0;
  while(index > 0) {
    tone += 1;
    if(((1 << tone) & tones) != 0) {
      index -= 1;
    }
  }
  return tone;
}

std::string Chord::to_short_string() const {
  return key_name(key) + desc->suffix;
}
