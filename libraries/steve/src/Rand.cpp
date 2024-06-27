#include "Rand.h"

#include <random>

using namespace steve;

std::mt19937_64 Rand::generator;
static std::uniform_real_distribution<float> nf_dist(0.f, 1.f);
static std::normal_distribution<float> nn_dist(0.5f, 0.1f);

void Rand::reseed(uint64_t newseed) {
  generator.seed(newseed);
}

float Rand::next_float() {
  return nf_dist(generator);
}

float Rand::next_normal() {
  return std::max(0.f, std::min(1.f, nn_dist(generator)));
}

uint32_t Rand::next(uint32_t min, uint32_t max) {
  std::uniform_int_distribution<uint32_t> dist(min, max);
  return dist(generator);
}
uint64_t Rand::next(uint64_t min, uint64_t max) {
  std::uniform_int_distribution<uint64_t> dist(min, max);
  return dist(generator);
}
int Rand::next(int min, int max) {
  std::uniform_int_distribution<int> dist(min, max);
  return dist(generator);
}
float Rand::next(float min, float max) {
  std::uniform_real_distribution<float> dist(min, max);
  return dist(generator);
}
NoteValue Rand::next(NoteValue min, NoteValue max) {
  return NoteValue(Rand::next(uint64_t(min), uint64_t(max)));
}