#include "Config.h"

#include <algorithm>
#include <iostream>

#include "Music.h"
#include "Rand.h"
#include "creator/Arpeggio.h"
#include "creator/Bass.h"
#include "creator/Chords.h"
#include "creator/Drums.h"
#include "creator/Melody.h"

using namespace steve;

std::shared_ptr<ChordChange> Config::get_chord_change(const std::shared_ptr<ChordDescription>& source, const std::shared_ptr<ChordDescription>& target, uint8_t tone_shift) {
  std::shared_ptr<ChordChange> chord_change = _chord_changes.get_item(source->name + "->" + target->name + "+" + std::to_string(tone_shift));
  chord_change->source_chord = source;
  chord_change->target_chord = target;
  chord_change->tone_shift = tone_shift;
  return chord_change;
}

Config::Config() {
  _creators.get_item("Arpeggio")->func = [](Music* music) {
    return new Arpeggio(music);
  };
  _creators.get_item("Bass")->func = [](Music* music) {
    return new Bass(music);
  };
  _creators.get_item("Chords")->func = [](Music* music) {
    return new Chords(music);
  };
  _creators.get_item("Drums")->func = [](Music* music) {
    return new Drums(music);
  };
  _creators.get_item("Melody")->func = [](Music* music) {
    return new Melody(music);
  };
}

void Config::compute_cache() {
  // This needs to happen before computing scale chords
  _chords.compute_cache();
  for(auto& scale : _scales.get_all()) {
    scale->compute_chords(*this);
  }

  _scales.compute_cache();
  _instruments.compute_cache();
  _creators.compute_cache();
  _signatures.compute_cache();
  _chord_changes.compute_cache();
}

void Config::list_scales(std::ostream& out) const {
  for(const auto& scale_desc : _scales.get_allowed()) {
    Scale scale(scale_desc, 0);
    out << scale.desc->name << ":" << std::endl;
    for(const auto& chord : scale.desc->chords) {
      out << '\t' << scale.get_degree_string_for_chord(chord) << "\n";
    }
  }
}

uint32_t Config::get_random_tempo() const {
  const float tempo_range = max_tempo - min_tempo;
  const uint32_t full_precision_tempo = uint32_t(tempo_range * Rand::next_normal()) + min_tempo;
  return (full_precision_tempo / 5) * 5;
}

std::vector<Chord> Config::get_chords_inside(ToneSet tones) const {
  std::vector<Chord> chords;
  for(const auto& desc : _chords.get_allowed()) {
    for(int key(0); key < 12; key++) {
      const Chord shifted_chord(desc, key);
      if((tones | shifted_chord.tones) == tones) { // All chord tones are in the toneset
        chords.push_back(shifted_chord);
      }
    }
  }
  return chords;
}
std::vector<Chord> Config::get_chord_progression(const Scale& scale) const {
  std::vector<Chord> chords;

  // Start with first degree chord
  chords.push_back(Chord(_chords.get_random_item([scale](std::shared_ptr<ChordDescription> chord) {
    return std::find_if(scale.desc->chords.begin(), scale.desc->chords.end(), [chord](const Chord& scale_chord) {
      return scale_chord.desc == chord && scale_chord.key == 0;
    }) != scale.desc->chords.end();
  }),
    scale.key));

  // Progress backwards
  while(chords.size() < 4) {
    const Chord dest_chord = chords.back();
    const std::shared_ptr<ChordChange> chord_change = _chord_changes.get_random_item([&](std::shared_ptr<ChordChange> chord_change) {
      return dest_chord.desc == chord_change->target_chord && tone_set_within(scale.tones, tone_set_shift(chord_change->source_chord->tones, (dest_chord.key - chord_change->tone_shift + 12) % 12));
    });
    chords.push_back(Chord(chord_change->source_chord, (dest_chord.key - chord_change->tone_shift + 12) % 12));
  }

  // Reverse but keep first as start
  std::reverse(chords.begin() + 1, chords.end());

  return chords;
}

std::vector<std::shared_ptr<const CreatorDescription>> Config::get_creators() const {
  std::vector<std::shared_ptr<const CreatorDescription>> creators;

  while(creators.empty()) {
    for(const auto creator : _creators.get_allowed()) {
      const uint32_t count = Rand::next(creator->min_count, creator->max_count);
      for(uint32_t i = 0; i < count; i++) {
        creators.push_back(creator);
      }
    }
  }

  return creators;
}
