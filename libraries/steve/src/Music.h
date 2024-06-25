#pragma once

#include <memory>
#include <vector>

#include "Chord.h"
#include "Instrument.h"
#include "Scale.h"
#include "Steve.h"
#include "TimeSignature.h"

namespace steve {
  class Config;
  class Creator;
  class Music {
  protected:
    const Config& _config;
    Notes _notes;
    Tones _tones;
    std::vector<std::unique_ptr<Creator>> _creators;
    std::vector<Chord> _chord_progression;
    std::vector<bool> _beats;
    Scale _scale;
    uint32_t _tempo, _size;
    std::shared_ptr<TimeSignature> _signature;

  public:
    Music(const Config&);
    void add_creator(Creator* creator);
    const Chord& chord_at(size_t i) const;
    ToneSet tones_at(size_t start, size_t size = 1) const;
    bool is_beat(uintptr_t i) const;
    std::vector<uintptr_t> beats_inside(uintptr_t min, uintptr_t max) const;
    std::string to_short_string() const;
    void check() const;

    void write_mid(std::ostream&) const;
    void write_txt(std::ostream&) const;

    inline const Config& get_config() const { return _config; }
    inline const Notes& notes() const { return _notes; }
    inline const Tones& tones() const { return _tones; }
    inline const Scale& scale() const { return _scale; }
    inline const std::vector<Chord> chord_progression() const { return _chord_progression; }
    inline size_t size() const { return _size; }
    inline size_t bars() const { return _size / get_bar_ticks(); }
    inline size_t get_bar_ticks() const { return ticks_for(_signature->beat_value) * _signature->beats_per_bar; }
    inline NoteValue get_beat_value() const { return _signature->beat_value; }
    inline size_t parts() const { return _creators.size(); }
    inline const std::vector<std::unique_ptr<Creator>>& creators() const { return _creators; }
    inline size_t tempo() const { return _tempo; }
    inline size_t tickTime() const { return 60000 / (_tempo * 32); }
    inline size_t duration() const { return (tickTime() * _size) / 1000; }
  };
}
