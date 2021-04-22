/*
Twister Engine Random Generator

By Dashodanger, 2020

This is meant to be a replacement for the AJ_Random library that
uses the Mersenne Twister Engine for random number generation. A
version of this was used in ObHack for its number generation, but
now it is part of the C++11 standard. Function names will be as
similar to AJ_Random as possible in order to minimize changes in
other sections of code.
*/

#include <ctime>
#include <random>

std::independent_bits_engine<
    std::mersenne_twister_engine<unsigned long long, 64, 312, 156, 31,
                                 0xb5026f5aa96619e9, 29, 0x5555555555555555, 17,
                                 0x71d67fffeda60000, 37, 0xfff7eee000000000, 43,
                                 6364136223846793005>,
    63, unsigned long long>
    twister;

void twister_Init() { twister.seed(std::time(nullptr)); }

void twister_Reseed(unsigned long long random) { twister.seed(random); }

unsigned long long twister_UInt() { return twister(); }

double twister_Double() { return ldexp(twister(), -63); }

int twister_Between(int low, int high) {
    std::uniform_int_distribution<> roll(low, high);
    return roll(twister);
}
