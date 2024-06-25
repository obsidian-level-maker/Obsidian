#pragma once

#include <cstdint>
#include <iterator>
#include <random>
#include <set>
#include <vector>
#include "Steve.h"

namespace steve {
  class Rand {
  public:
    static std::default_random_engine generator;
    static float next_float();
    static float next_normal();

    static uint32_t next(uint32_t min, uint32_t max); // Returns a random unsigned integer between min and max
    static uint64_t next(uint64_t min, uint64_t max); // Returns a random unsigned integer between min and max
    static int next(int min, int max); // Returns a random integer between min and max
    static float next(float min, float max); // Returns a random float between min and max
    static NoteValue next(NoteValue min, NoteValue max);

    static void reseed(uint64_t newseed);

    // Containers
    template <class T>
    static const T& in(const std::set<T>& s) {
      auto it(s.begin());
      std::advance(it, next(0ull, s.size()-1));
      return *it;
    }
    template <class T>
    inline static const T& in(const std::vector<T>& v) {
      return v[(unsigned int)next(0ull, v.size()-1)];
    }
  };
}
