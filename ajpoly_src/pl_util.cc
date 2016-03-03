//------------------------------------------------------------------------
//
//  AJ-Polygonator (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "pl_local.h"

namespace ajpoly
{


/* result is angle value (degrees)
 */
double ComputeAngle(double dx, double dy)
{
	double angle;

	if (dx == 0)
		return (dy > 0) ? 90.0 : 270.0;

	angle = atan2((double) dy, (double) dx) * 180.0 / M_PI;

	if (angle < 0) 
		angle += 360.0;

	return angle;
}


char error_message[4000];


void SetErrorMsg(const char *str, ...)
{
	va_list args;

	va_start(args, str);
	vsnprintf(error_message, sizeof(error_message), str, args);
	va_end(args);

	error_message[sizeof(error_message) - 1] = 0;
}


//------------------------------------------------------------------------
//   API FUNCTIONS
//------------------------------------------------------------------------


const char * GetError()
{
	return error_message;
}


}  // namespace ajpoly

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
