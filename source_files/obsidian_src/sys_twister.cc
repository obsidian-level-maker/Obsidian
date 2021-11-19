/*
Twister Engine Random Generator

By Dashodanger, 2020

This is meant to be a replacement for the AJ_Random library that
uses the Mersenne Twister Engine for random number generation. A
version of this was used in ObHack for its number generation, but
now it is part of the C++11 standard. Usage will be as
similar to AJ_Random as possible in order to minimize changes in
other sections of code.
*/

#include "sys_twister.h"

using namespace XoshiroCpp;

Xoshiro256PlusPlus xoshiro(std::chrono::system_clock::to_time_t(std::chrono::system_clock::now()));

unsigned long long twister_UInt() { return xoshiro(); }

double twister_Double() { return DoubleFromBits(xoshiro()); }

int twister_Between(int low, int high) {
    std::uniform_int_distribution<> roll(low, high);
    return roll(xoshiro);
}
