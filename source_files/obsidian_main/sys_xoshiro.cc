/*
Xoshiro256 Random Generator

By Dashodanger, 2020

This is meant to be a replacement for the AJ_Random library that
uses the fastPRNG xoshiro256 implementation for random number generation.
Usage will be as similar to AJ_Random as possible in order to minimize
changes in other sections of code.
*/

#include "../fastPRNG/fastPRNG.h"

fastPRNG::fastXS64 xoshiro;

void xoshiro_Reseed(unsigned long long newseed) { xoshiro.seed(newseed); }

unsigned long long xoshiro_UInt() {
    long long rand_num = (long long)(xoshiro.xoshiro256p());
    if (rand_num >= 0) {
        return rand_num;
    }
    return -rand_num;
}

double xoshiro_Double() { return xoshiro.xoshiro256p_UNI<double>(); }

// This probably isn't super efficient, but it is rarely used and shouldn't make
// a huge overall hit to performance - Dasho
int xoshiro_Between(int low, int high) {
    return (int)(xoshiro.xoshiro256p_Range<float>(low, high));
}
