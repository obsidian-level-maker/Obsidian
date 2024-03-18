//------------------------------------------------------------------------
//  OBSIDIAN Endian handling
//----------------------------------------------------------------------------
//
//  Copyright (c) 2024 The OBSIDIAN Team.
//  Copyright (c) 2003-2024 The EDGE Team.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//----------------------------------------------------------------------------

#pragma once

#include <stdint.h>
#include <stdlib.h>

// Used to swap values.  Try to use superfast macros on systems
// that support them, otherwise use regular C++ functions.
#if defined(__GNUC__) || defined(__clang__)
static inline uint16_t __Swap16(uint16_t n)
{
    return __builtin_bswap16(n);
}
static inline uint32_t __Swap32(uint32_t n)
{
    return __builtin_bswap32(n);
}
static inline uint64_t __Swap64(uint64_t n)
{
    return __builtin_bswap64(n);
}
#elif defined(_MSC_VER)
static inline uint16_t __Swap16(uint16_t n)
{
    return _byteswap_ushort(n);
}
static inline uint32_t __Swap32(uint32_t n)
{
    return _byteswap_ulong(n);
}
static inline uint64_t __Swap64(uint64_t n)
{
    return _byteswap_uint64(n);
}
#else
static inline uint16_t __Swap16(uint16_t n)
{
    uint16_t a;
    a = (n & 0xFF) << 8;
    a |= (n >> 8) & 0xFF;
    return a;
}
static inline uint32_t __Swap32(uint32_t n)
{
    uint32_t a;
    a = (n & 0xFFU) << 24;
    a |= (n & 0xFF00U) << 8;
    a |= (n >> 8) & 0xFF00U;
    a |= (n >> 24) & 0xFFU;
    return a;
}
static inline uint64_t __Swap64(uint64_t n)
{
    uint64_t a;
    a = (n & 0xFFULL) << 56;
    a |= (n & 0xFF00ULL) << 40;
    a |= (n & 0xFF0000ULL) << 24;
    a |= (n & 0xFF000000ULL) << 8;
    a |= (n >> 8) & 0xFF000000ULL;
    a |= (n >> 24) & 0xFF0000ULL;
    a |= (n >> 40) & 0xFF00ULL;
    a |= (n >> 56) & 0xFFULL;
    return a;
}
#endif

#if defined(__LITTLE_ENDIAN__) || defined(__i386__) || defined(__ia64__) || defined(WIN32) || defined(__alpha__) ||    \
    defined(__alpha) || defined(__arm__) || (defined(__mips__) && defined(__MIPSEL__)) || defined(__SYMBIAN32__) ||    \
    defined(__x86_64__) || defined(__arm64__) || defined(__aarch64__)

inline uint16_t AlignedLittleEndianU16(const uint16_t x)
{
    return x;
}
inline int16_t AlignedLittleEndianS16(const uint16_t x)
{
    return (int16_t)x;
}
inline uint32_t AlignedLittleEndianU32(const uint32_t x)
{
    return x;
}
inline int32_t AlignedLittleEndianS32(const uint32_t x)
{
    return (int32_t)x;
}
inline uint64_t AlignedLittleEndianU64(const uint64_t x)
{
    return x;
}
inline int64_t AlignedLittleEndianS64(const uint64_t x)
{
    return (int64_t)x;
}
inline float AlignedLittleEndianFloat(const float x)
{
    return x;
}

inline uint16_t AlignedBigEndianU16(const uint16_t x)
{
    return __Swap16(x);
}
inline int16_t AlignedBigEndianS16(const uint16_t x)
{
    return (int16_t)__Swap16(x);
}
inline uint32_t AlignedBigEndianU32(const uint32_t x)
{
    return __Swap32(x);
}
inline int32_t AlignedBigEndianS32(const uint32_t x)
{
    return (int32_t)__Swap32(x);
}
inline uint64_t AlignedBigEndianU64(const uint64_t x)
{
    return __Swap64(x);
}
inline int64_t AlignedBigEndianS64(const uint64_t x)
{
    return (int64_t)__Swap64(x);
}
inline float AlignedBigEndianFloat(const float x)
{
    union {
        float    f;
        uint32_t u;
    } in, out;
    in.f  = x;
    out.u = AlignedBigEndianU32(in.u);
    return out.f;
}
#else

inline uint16_t AlignedLittleEndianU16(const uint16_t x)
{
    return __Swap16(x);
}
inline int16_t AlignedLittleEndianS16(const uint16_t x)
{
    return (int16_t)__Swap16(x);
}
inline uint32_t AlignedLittleEndianU32(const uint32_t x)
{
    return __Swap32(x);
}
inline int32_t AlignedLittleEndianS32(const uint32_t x)
{
    return (int32_t)__Swap32(x);
}
inline uint64_t AlignedLittleEndianU64(const uint64_t x)
{
    return __Swap64(x);
}
inline int64_t AlignedLittleEndianS64(const uint64_t x)
{
    return (int64_t)__Swap64(x);
}
inline float AlignedLittleEndianFloat(const float x)
{
    union {
        float    f;
        uint32_t u;
    } in, out;
    in.f  = x;
    out.u = AlignedLittleEndianU32(in.u);
    return out.f;
}

inline uint16_t AlignedBigEndianU16(const uint16_t x)
{
    return x;
}
inline int16_t AlignedBigEndianS16(const uint16_t x)
{
    return (int16_t)x;
}
inline uint32_t AlignedBigEndianU32(const uint32_t x)
{
    return x;
}
inline int32_t AlignedBigEndianS32(const uint32_t x)
{
    return (int32_t)x;
}
inline uint64_t AlignedBigEndianU64(const uint64_t x)
{
    return x;
}
inline int64_t AlignedBigEndianS64(const uint64_t x)
{
    return (int64_t)x;
}
inline float AlignedBigEndianFloat(const float x)
{
    return x;
}
#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
