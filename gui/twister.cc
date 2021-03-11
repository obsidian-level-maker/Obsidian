/* 
Twister Engine Random Generator

By Dashodanger, 2020

This is meant to be a replacement for the AJ_Random library that
uses the Mersenne Twister Engine for random number generation. A
version of this was used in ObHack for its number generation, but
now it is part of the C++11 standard, with both 32 and 64-bit
variants available. Function names will be as similar to AJ_Random
as possible in order to minimize changes in other sections of code
*/

#include <random>
#include <ctime>

std::independent_bits_engine<std::mt19937, 31, uint_fast32_t> twister;

void twister_Init() {
    twister.seed(std::time(nullptr));
}

void twister_Reseed(uint_fast32_t random) {
    twister.seed(random);
}

uint_fast32_t twister_UInt() {
    return twister();
}

double twister_Double() {
    return ldexp(twister(), -31);
}
