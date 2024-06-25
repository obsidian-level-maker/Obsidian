#pragma once

#include <cstdint>
#include <vector>

#include "Chord.h"
#include "ChordChange.h"
#include "ConfigItemList.h"
#include "Instrument.h"
#include "Scale.h"
#include "TimeSignature.h"
#include "creator/Creator.h"

namespace steve {
  class Config {
  protected:
    uint32_t min_tempo = 0, max_tempo = 360;
    ConfigItemList<TimeSignature> _signatures;
    ConfigItemList<CreatorDescription> _creators;
    ConfigItemList<ChordDescription> _chords;
    ConfigItemList<ScaleDescription> _scales;
    ConfigItemList<ChordChange> _chord_changes;
    ConfigItemList<Instrument> _instruments;

    std::shared_ptr<ChordChange> get_chord_change(const std::shared_ptr<ChordDescription>& source, const std::shared_ptr<ChordDescription>& target, uint8_t tone_shift);

  public:
    Config();
    void compute_cache();
    void list_scales(std::ostream&) const;

    uint32_t get_random_tempo() const;
    std::vector<Chord> get_chords_inside(ToneSet tones) const;
    std::vector<Chord> get_chord_progression(const Scale&) const;
    std::vector<std::shared_ptr<const CreatorDescription>> get_creators() const;

    inline const auto& get_signatures() const { return _signatures; }
    inline const auto& get_scales() const { return _scales; }
    inline const auto& get_instruments() const { return _instruments; }
  };
}
