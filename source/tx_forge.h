//------------------------------------------------------------------------
//  Spectral Synthesis (from ppmforge.c)
//------------------------------------------------------------------------

#pragma once

void TX_SpectralSynth(unsigned long long seed, float *buf, int width, double fracdim = 2.4, double powscale = 1.2);

void TX_TestSynth(unsigned long long seed);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
