//------------------------------------------------------------------------
//  CRC : Cyclic Rendundancy Check
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------
//
//  This is the Adler-32 algorithm as described in RFC-1950.
//
//------------------------------------------------------------------------

#ifndef __LIB_CRC_H__
#define __LIB_CRC_H__

class crc32_c
{
public:
	u32_t raw;

private:
	static const u32_t INIT_VALUE = 1;

public:
	crc32_c() : raw(INIT_VALUE) { }
	crc32_c(const crc32_c &rhs) { raw = rhs.raw; }
	~crc32_c() { }

	crc32_c& operator= (const crc32_c &rhs);

	crc32_c& operator+= (u8_t value);
	crc32_c& operator+= (s8_t value);
	crc32_c& operator+= (u16_t value);
	crc32_c& operator+= (s16_t value);
	crc32_c& operator+= (u32_t value);
	crc32_c& operator+= (s32_t value);
	crc32_c& operator+= (float value);
	crc32_c& operator+= (bool value);

	crc32_c& AddBlock(const u8_t *data, int len);
	crc32_c& AddCStr(const char *str);

	void Reset(void) { raw = INIT_VALUE; }
};

//------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------

inline crc32_c& crc32_c::operator= (const crc32_c &rhs)
{
	raw = rhs.raw; return *this;
}

inline crc32_c& crc32_c::operator+= (s8_t value)
{
	*this += (u8_t) value; return *this;
}
inline crc32_c& crc32_c::operator+= (s16_t value)
{
	*this += (u16_t) value; return *this;
}
inline crc32_c& crc32_c::operator+= (s32_t value)
{
	*this += (u32_t) value; return *this;
}
inline crc32_c& crc32_c::operator+= (bool value)
{
	*this += (value ? (u8_t)1 : (u8_t)0); return *this;
}

#endif // __LIB_CRC_H__

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
