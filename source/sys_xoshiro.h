// Xoshiro256 Random Generator

#include "../../libraries/fastPRNG/fastPRNG.h"

extern fastPRNG::fastXS64 xoshiro;

void xoshiro_Reseed(uint64_t newseed);

uint64_t xoshiro_UInt();

double xoshiro_Double();

int xoshiro_Between(int low, int high);
