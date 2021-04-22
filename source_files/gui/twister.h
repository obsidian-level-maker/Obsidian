/*
Twister Engine Random Generator

By Dashodanger, 2020

This is meant to be a replacement for the AJ_Random library that
uses the Mersenne Twister Engine for random number generation. A
version of this was used in ObHack for its number generation, but
now it is part of the C++11 standard. Function names will be as 
similar to AJ_Randomas possible in order to minimize changes to 
other sections of code
*/

#include <ctime>
#include <random>

void twister_Init();

void twister_Reseed(unsigned long long random);

unsigned long long twister_UInt();

double twister_Double();

int twister_Between(int low, int high);
