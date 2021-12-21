// Xoshiro256 Random Generator

#include "../fastPRNG/fastPRNG.h"

extern fastPRNG::fastXS64 xoshiro;

void xoshiro_Reseed(unsigned long long newseed);

unsigned long long xoshiro_UInt();

double xoshiro_Double();

int xoshiro_Between(int low, int high);
