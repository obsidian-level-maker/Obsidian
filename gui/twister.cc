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

int bits;
std::independent_bits_engine<std::mt19937, 31, uint_fast32_t> twister1;
std::mt19937 twister2;

void twister_Init() {
    bits = sizeof(uintmax_t) * 8;
    twister1.seed(std::time(nullptr));
    if (bits == 64)
        twister2.seed(std::time(nullptr)); 
}

void twister_Reseed(uintmax_t random) {
    twister1.seed(random);
    if (bits == 64)
        twister2.seed(random); 
}

uintmax_t twister_UInt() {
    if (bits == 32)
    {
        return twister1();
    }
    else
    {
        return (uintmax_t) twister1() << 32 | twister2();    
    }
}

double twister_Double() {
    if (bits == 32)
    {
        return ldexp(twister1(), -31);
    }
    else
    {
       return ldexp((uintmax_t) twister1() << 32 | twister2(), -63);    
    }
}
