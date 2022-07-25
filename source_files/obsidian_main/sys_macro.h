//------------------------------------------------------------------------
//  Macros
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#ifndef SYS_MACRO_H_
#define SYS_MACRO_H_

#include <type_traits>

// basic macros

// smallest distance between two points before being considered equal
#define DIST_EPSILON (1.0 / 128.0)

// smallest degrees between two angles before being considered equal
#define ANG_EPSILON (1.0 / 1024.0)

#ifndef M_PI
constexpr double M_PI = 3.14159265358979323846;
#endif

#ifndef MAX
template <typename A, typename B,
          typename = std::enable_if_t<std::is_convertible_v<B, A>>>
constexpr A MAX(A a, B b) {
    if (a > b) {
        return a;
    }
    return static_cast<A>(b);
}
#endif

#ifndef MIN
template <typename A, typename B,
          typename = std::enable_if_t<std::is_convertible_v<B, A>>>
constexpr A MIN(A a, B b) {
    if (a < b) {
        return a;
    }
    return static_cast<A>(b);
}
#endif

#ifndef ABS
template <typename T>
constexpr T ABS(T a) {
    if (a < 0) {
        return -a;
    }
    return a;
}
#endif

#ifndef SGN
template <typename T>
constexpr auto SGN(T x) {
    if (x < 0) {
        return -1;
    }
    if (x > 0) {
        return 1;
    }
    return 0;
}
#endif

#ifndef I_ROUND
template <typename T>
constexpr int I_ROUND(T x) {
    if (x < 0) {
        return x - 0.5;
    }
    return x + 0.5;
}
#endif

#ifndef CLAMP
template <typename T, typename L, typename U,
          typename = std::enable_if_t<std::conjunction_v<
              std::is_convertible<L, T>, std::is_convertible<U, T>>>>
constexpr T CLAMP(L low, T x, U high) {
    if (x < low) {
        return static_cast<T>(low);
    }
    if (x > high) {
        return static_cast<T>(high);
    }
    return x;
}
#endif

#endif  // SYS_MACRO_H_

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
