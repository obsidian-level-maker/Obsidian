#include "Music.h"

#include <algorithm>
#include <cassert>
#include <iostream>

#include "Chord.h"
#include "Config.h"
#include "Rand.h"
#include "Scale.h"
#include "creator/Creator.h"

using namespace steve;

Music::Music(const Config& config)
  : _config(config),
    _scale(Scale(_config.get_scales().get_random_item(), Rand::next(0, 11))),
    _tempo(_config.get_random_tempo()),
    _signature(_config.get_signatures().get_random_item()) {
  do {
    _size = uint32_t(40 * Rand::next_normal()) + 26;
  } while(_size > 512); // <=512 with 46 average bars

  _size -= _size % 4; // Multiple of 4 bars
  _size *= get_bar_ticks();

  { // Generate chord progression
    _chord_progression = _config.get_chord_progression(_scale);
    for(uintptr_t i(0); i < bars(); i++) {
      for(uintptr_t j(0); j < get_bar_ticks(); j++) {
        _tones.push_back(_chord_progression[i % _chord_progression.size()].tones);
      }
    }
    assert(_tones.size() == _size);
  }

  { // Generate beats
    _beats.resize(get_bar_ticks());
    for(uint32_t i = 0; i < _beats.size(); i++) {
      _beats[i] = false;
      for(NoteValue j = get_beat_value(); j >= NoteValue(0); j = NoteValue(uint32_t(j) - 1)) {
        const auto ticks = ticks_for(j);
        if((i / ticks) * ticks == i) {
          if(Rand::next(0u, (uint32_t(get_beat_value()) - uint32_t(j)) * 2) == 0) {
            _beats[i] = true;
            break;
          }
        }
      }
    }
  }

  for(const auto& creator : _config.get_creators()) {
    add_creator(creator->func(this));
  }

#ifndef NDEBUG
  check();
#endif
}
void Music::add_creator(Creator* creator) {
  creator->init();
  creator->post_init();
  paste(creator->compose(), _notes);
  _creators.push_back(std::unique_ptr<Creator>(creator));
}
const Chord& Music::chord_at(size_t i) const {
  return _chord_progression[(i / get_bar_ticks()) % _chord_progression.size()];
}
ToneSet Music::tones_at(size_t start, size_t size) const {
  ToneSet tones = ~0;
  const uintptr_t start_bar = start / get_bar_ticks();
  const uintptr_t end_bar = (start + size - 1) / get_bar_ticks();
  for(uintptr_t i = start_bar; i <= end_bar; i++) {
      tones &= _chord_progression[i % _chord_progression.size()].tones;
  }
  return tones;
}
bool Music::is_beat(uintptr_t i) const {
  return _beats[i % _beats.size()];
}
std::vector<uintptr_t> Music::beats_inside(uintptr_t min, uintptr_t max) const {
  std::vector<uintptr_t> beats;
  for(uintptr_t i = min; i <= max; i++) {
    if(is_beat(i)) {
      beats.push_back(i);
    }
  }
  return beats;
}
std::string Music::to_short_string() const {
  std::string short_string;
  short_string += scale().desc->name + "_" + key_name(scale().key);
  short_string += "_" + std::to_string(_signature->beats_per_bar);
  short_string += std::to_string(1 << (uint32_t(NoteValue::whole) - uint32_t(get_beat_value())));
  short_string += "_" + std::to_string(tempo());

  std::replace(short_string.begin(), short_string.end(), ' ', '_');

  return short_string;
}
void Music::check() const {
  Tones final_tones(octave_tones(_notes));
  assert(final_tones.size() <= _tones.size());
  for(uintptr_t i(0); i < final_tones.size(); i++) {
    assert(tone_set_within(_scale.tones, final_tones[i]));
    assert(tone_set_within(_tones[i], final_tones[i]));
  }

  for(const auto& note : _notes) {
    assert(is_beat(note.first));
  }
}

static void write_bigendian(std::ostream& s, uint32_t v, uint32_t byteCount) {
  if(byteCount>=4) s << uint8_t(v>>24);
  if(byteCount>=3) s << uint8_t(v>>16);
  if(byteCount>=2) s << uint8_t(v>>8);
  if(byteCount>=1) s << uint8_t(v);
}
class VarLength {
  uint32_t _value;
public:
  inline VarLength(uint32_t value) : _value(value) {}
  friend inline std::ostream& operator<<(std::ostream& s, const VarLength& v) {
    if(v._value >= 128) {
      s << (uint8_t)(((v._value >> 7) & 0x7f) | 0x80);
    }
    s << (uint8_t)(v._value & 0x7f);
    return s;
  }
};
void Music::write_mid(std::ostream& s) const {
  // Header chunk
  s << "MThd"; // Chunk id
  write_bigendian(s, 6, 4); // Chunk size
  write_bigendian(s, 0, 2); // Format type (single track)
  write_bigendian(s, 1, 2); // Number of tracks
  write_bigendian(s, ticks_for(NoteValue::quarter), 2); // Time division (ticks per beat)

  // Track chunk
  s << "MTrk";
  const size_t sizeoff(s.tellp());
  write_bigendian(s, 0, 4); // Placeholder for track size

  { // Tempo meta event
    s << uint8_t(0) << uint8_t(0xff) << uint8_t(0x51) << uint8_t(3);
    write_bigendian(s, 60000000u / _tempo, 3); // Microseconds per quarter note
  }

  { // Time signature meta event
    s << uint8_t(0) << uint8_t(0xff) << uint8_t(0x58) << uint8_t(4)
      << uint8_t(_signature->beats_per_bar) // Numerator
      << uint8_t(uint8_t(NoteValue::whole) - uint8_t(get_beat_value())) // Denominator (2^x)
      << uint8_t(0x18) // Metronome pulse in clock ticks
      << uint8_t(ticks_for(get_beat_value()) / ticks_for(NoteValue::thirtysecond)); // 32nd per beat
  }

  for(uint32_t i(0); i < _creators.size(); i++) {
    s << uint8_t(0) << uint8_t(0xC0|i) << _creators[i]->instrument()->midi_id; // Program change
  }

  uint32_t last = 0;
  uint32_t last_chord = -1;

  Notes end_notes;
  auto process_end_notes = [&s, &last, &end_notes](uint32_t next_time) {
    while(!end_notes.empty()) {
      auto next_end = end_notes.begin();
      if(next_end->first <= next_time) {
        s << VarLength(next_end->first - last) << uint8_t(0x80 | next_end->second.channel) << uint8_t(next_end->second.tone) << uint8_t(next_end->second.velocity); // Note off
        last = next_end->first;
        end_notes.erase(next_end);
      } else {
        break;
      }
    }
  };

  for(const auto& note : _notes) {
    process_end_notes(note.first);

    s << VarLength(note.first - last) << uint8_t(0x90 | note.second.channel) << uint8_t(note.second.tone) << uint8_t(note.second.velocity); // Note on

    end_notes.insert(std::make_pair(note.first + note.second.duration, note.second));

    last = note.first;

    if(note.first != last_chord && note.first != _size && note.first % get_bar_ticks() == 0) {
      // Chord meta-event
      const Chord chord = chord_at(note.first);
      const uint8_t degree =_scale.get_degree_for_tone(chord.key);
      const std::string chord_str = chord_at(note.first).to_short_string() + " (" + std::to_string(degree + 1) + ")";
      s << uint8_t(0) << uint8_t(0xFF) << uint8_t(0x01) << VarLength(chord_str.size()) << chord_str;
      last_chord = note.first;
    }
  }
  process_end_notes(last + get_bar_ticks());

  s << uint8_t(0) << uint8_t(0xFF) << uint8_t(0x2F) << uint8_t(0); // End of track

  // Write chunk size
  const size_t endoff(s.tellp());
  s.seekp(sizeoff);
  write_bigendian(s, endoff-sizeoff-4, 4);
}
void Music::write_txt(std::ostream& s) const {
  s << "Scale: " << key_name(scale().key) << " " << scale().desc->name << std::endl
    << "Tempo: " << tempo() << std::endl
    << "Signature: " << _signature->beats_per_bar << "/" << (1 << (uint32_t(NoteValue::whole) - uint32_t(get_beat_value()))) << std::endl
    << "Duration: " << duration() << std::endl << std::endl;

  {
    s << "Chord progression:" << std::endl;
    for(const Chord& chord : _chord_progression) {
      s << " - " << _scale.get_degree_string_for_chord(chord) << " (" << chord.to_short_string() << ")" << std::endl;
    }
    s << std::endl;
  }

  {
    s << "Rhythm:" << std::endl << '\t';
    for(uintptr_t i = 0; i < _beats.size(); i += 2) {
      if(i % ticks_for(get_beat_value()) == 0 && i > 0) {
        s << ' ';
      }
      s << (is_beat(i) ? '1' : '0');
    }
    s << std::endl << std::endl;
  }

  s << "Creators:" << std::endl;
  for(const auto& creator : _creators) {
    creator->write_txt(s);
    s << std::endl;
  }
}