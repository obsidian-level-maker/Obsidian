#ifndef OBSIDIAN_DEFINES_H_
#define OBSIDIAN_DEFINES_H_

#if defined(__GNUC__) || defined(__clang__)
#define ALWAYS_INLINE __attribute__((always_inline))
#elif defined(_MSC_VER)
#define ALWAYS_INLINE __forceinline
#else
#define ALWAYS_INLINE
#endif

#endif
