//------------------------------------------------------------------------
//  Utility functions
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

#include "lib_util.h"
#include "main.h"
#include "headers.h"
#include "grapheme.h"
#include <chrono>
#ifndef _WIN32
#include <dirent.h>
#include <ftw.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#endif
#ifdef __MINGW32__
#include <sys/stat.h>
#endif

#ifdef _WIN32                                    // Windows API
static inline bool IsDirectorySeparator(const char c)
{
    return (c == '\\' || c == '/' || c == ':'); // Kester added ':'
}
bool IsPathAbsolute(std::string_view path)
{
    SYS_ASSERT(!path.empty());

    // Check for Drive letter, colon and slash...
    if (path.size() > 2 && path[1] == ':' && (path[2] == '\\' || path[2] == '/') && IsAlphaASCII(path[0]))
    {
        return true;
    }
    else if (path.size() == 2 && path[1] == ':' && IsAlphaASCII(path[0]))
    {
        return true;
    }

    // Check for share name...
    if (path.size() > 1 && path[0] == '\\' && path[1] == '\\')
        return true;

    return false;
}
FILE *FileOpen(std::string_view name, std::string_view mode)
{
    std::wstring wname = UTF8ToWString(name);
    std::wstring wmode = UTF8ToWString(mode);
    return _wfopen(wname.c_str(), wmode.c_str());
}
bool FileRename(std::string_view oldname, std::string_view newname)
{
    std::wstring woldname = UTF8ToWString(oldname);
    std::wstring wnewname = UTF8ToWString(newname);
    return _wrename(woldname.c_str(), wnewname.c_str()) == 0;
}
bool FileDelete(std::string_view name)
{
    SYS_ASSERT(!name.empty());
    std::wstring wname = UTF8ToWString(name);
    return _wremove(wname.c_str()) == 0;
}
std::string CurrentDirectoryGet()
{
    std::string    directory;
    const wchar_t *dir = _wgetcwd(nullptr, 0);
    if (dir)
        directory = WStringToUTF8(dir);
    return directory; // can be empty
}
static bool CurrentDirectorySet(std::string_view dir)
{
    SYS_ASSERT(!dir.empty());
    std::wstring wdir = UTF8ToWString(dir);
    return _wchdir(wdir.c_str()) == 0;
}
bool MakeDirectory(std::string_view dir)
{
    SYS_ASSERT(!dir.empty());
    std::wstring wdirectory = UTF8ToWString(dir);
    return _wmkdir(wdirectory.c_str()) == 0;
}
bool FileExists(std::string_view name)
{
    SYS_ASSERT(!name.empty());
    std::wstring wname = UTF8ToWString(name);
    return _waccess(wname.c_str(), 0) == 0;
}
#else // POSIX API
static inline bool IsDirectorySeparator(const char c)
{
    return (c == '\\' || c == '/');
}
bool IsPathAbsolute(std::string_view path)
{
    SYS_ASSERT(!path.empty());

    if (IsDirectorySeparator(path[0]))
        return true;
    else
        return false;
}
FILE *FileOpen(std::string_view name, std::string_view mode)
{
    SYS_ASSERT(!name.empty());
    return fopen(std::string(name).c_str(), std::string(mode).c_str());
}
bool FileRename(std::string_view oldname, std::string_view newname)
{
    return rename(oldname.c_str(), newname.c_str()) == 0;
}
bool FileDelete(std::string_view name)
{
    SYS_ASSERT(!name.empty());
    return remove(std::string(name).c_str()) == 0;
}
std::string CurrentDirectoryGet()
{
    std::string directory;
    const char *dir = getcwd(nullptr, 0);
    if (dir)
        directory = dir;
    return directory;
}
static bool CurrentDirectorySet(std::string_view dir)
{
    SYS_ASSERT(!dir.empty());
    return chdir(std::string(dir).c_str()) == 0;
}
bool MakeDirectory(std::string_view dir)
{
    SYS_ASSERT(!dir.empty());
    return (mkdir(std::string(dir).c_str(), 0774) == 0);
}
bool FileExists(std::string_view name)
{
    SYS_ASSERT(!name.empty());
    return access(std::string(name).c_str(), F_OK) == 0;
}
#endif

// Universal Functions

std::string GetStem(std::string_view path)
{
    SYS_ASSERT(!path.empty());
    // back up until a slash or the start
    for (int p = path.size() - 1; p > 1; p--)
    {
        if (IsDirectorySeparator(path[p - 1]))
        {
            path.remove_prefix(p);
            break;
        }
    }
    // back up until a dot
    for (int p = path.size() - 2; p >= 0; p--)
    {
        const char ch = path[p];
        if (IsDirectorySeparator(ch))
            break;

        if (ch == '.')
        {
            // handle filenames that being with a dot
            // (un*x style hidden files)
            if (p == 0 || IsDirectorySeparator(path[p - 1]))
                break;

            path.remove_suffix(path.size() - p);
            break;
        }
    }
    std::string filename(path);
    return filename;
}

std::string GetFilename(std::string_view path)
{
    SYS_ASSERT(!path.empty());
    // back up until a slash or the start
    for (int p = path.size() - 1; p > 0; p--)
    {
        if (IsDirectorySeparator(path[p - 1]))
        {
            path.remove_prefix(p);
            break;
        }
    }
    std::string filename(path);
    return filename;
}

std::string PathAppend(std::string_view parent, std::string_view child)
{
    SYS_ASSERT(!parent.empty() && !child.empty());

    if (IsDirectorySeparator(parent.back()))
        parent.remove_suffix(1);

    std::string new_path(parent);

    new_path.push_back('/');

    if (IsDirectorySeparator(child[0]))
        child.remove_prefix(1);

    new_path.append(child);

    return new_path;
}

std::string GetDirectory(std::string_view path)
{
    SYS_ASSERT(!path.empty());
    std::string directory;
    // back up until a slash or the start
    for (int p = path.size() - 1; p >= 0; p--)
    {
        if (IsDirectorySeparator(path[p]))
        {
            directory = path.substr(0, p);
            break;
        }
    }

    return directory; // nothing
}

std::string GetExtension(std::string_view path)
{
    SYS_ASSERT(!path.empty());
    std::string extension;
    // back up until a dot
    for (int p = path.size() - 1; p >= 0; p--)
    {
        const char ch = path[p];
        if (IsDirectorySeparator(ch))
            break;

        if (ch == '.')
        {
            // handle filenames that being with a dot
            // (un*x style hidden files)
            if (p == 0 || IsDirectorySeparator(path[p - 1]))
                break;

            extension = path.substr(p);
            break;
        }
    }
    return extension; // can be empty
}

void ReplaceExtension(std::string &path, std::string_view ext)
{
    SYS_ASSERT(!path.empty() && !ext.empty());
    int extpos = -1;
    // back up until a dot
    for (int p = path.size() - 1; p >= 0; p--)
    {
        char &ch = path[p];
        if (IsDirectorySeparator(ch))
            break;

        if (ch == '.')
        {
            // handle filenames that being with a dot
            // (un*x style hidden files)
            if (p == 0 || IsDirectorySeparator(path[p - 1]))
                break;

            extpos = p;
            break;
        }
    }
    if (extpos == -1) // No extension found, add it
        path.append(ext);
    else
    {
        while (path.size() > extpos)
        {
            path.pop_back();
        }
        path.append(ext);
    }
}

#ifdef _WIN32
std::wstring UTF8ToWString(std::string_view instring)
{
    size_t                  utf8pos = 0;
    const char             *utf8ptr = instring.data();
    size_t                  utf8len = instring.size();
    std::wstring            outstring;
    uint32_t                u32c;
    while (utf8pos < utf8len)
    {
        u32c       = 0;
        size_t res = grapheme_decode_utf8(utf8ptr+utf8pos, utf8len, &u32c);
        if (res < 0)
            Main::FatalError("Failed to convert %s to a wide string!\n", std::string(instring).c_str());
        else
            utf8pos += res;
        if (u32c < 0x10000)
            outstring.push_back((wchar_t)u32c);
        else // Make into surrogate pair if needed
        {
            u32c -= 0x10000;
            outstring.push_back((wchar_t)(u32c >> 10) + 0xD800);
            outstring.push_back((wchar_t)(u32c & 0x3FF) + 0xDC00);
        }
    }
    return outstring;
}
std::string WStringToUTF8(std::wstring_view instring)
{
    std::string      outstring;
    size_t           inpos = 0;
    size_t           inlen = instring.size();
    const wchar_t   *inptr = instring.data();
    char             u8c[4];
    while (inpos < inlen)
    {
        uint32_t u32c = 0;
        if ((*(inptr + inpos) & 0xD800) == 0xD800)                              // High surrogate
        {
            if (inpos + 1 < inlen && (*(inptr + inpos + 1) & 0xDC00) == 0xDC00) // Low surrogate
            {
                u32c = ((*(inptr + inpos) - 0xD800) * 0x400) + (*(inptr + inpos + 1) - 0xDC00) + 0x10000;
                inpos += 2;
            }
            else // Assume an unpaired surrogate is malformed
            {
                // print what was safely converted if present
                if (!outstring.empty())
                    Main::FatalError("Failure to convert %s from a wide string!\n", outstring.c_str());
                else
                    Main::FatalError("Wide string to UTF-8 conversion failure!\n");
            }
        }
        else
        {
            u32c = *(inptr + inpos);
            inpos++;
        }
        memset(u8c, 0, 4);
        grapheme_encode_utf8((uint_least32_t)u32c, &u8c[0], 4);
        if (u8c[0])
            outstring.push_back(u8c[0]);
        if (u8c[1])
            outstring.push_back(u8c[1]);
        if (u8c[2])
            outstring.push_back(u8c[2]);
        if (u8c[3])
            outstring.push_back(u8c[3]);
    }
    return outstring;
}
#endif


int StringCompare(std::string_view A, std::string_view B)
{
    size_t        A_pos = 0;
    size_t        B_pos = 0;
    size_t        A_end = A.size();
    size_t        B_end = B.size();
    unsigned char AC    = 0;
    unsigned char BC    = 0;

    for (;; A_pos++, B_pos++)
    {
        if (A_pos >= A_end)
            AC = 0;
        else
            AC = (int)(unsigned char)A[A_pos];
        if (B_pos >= B_end)
            BC = 0;
        else
            BC = (int)(unsigned char)B[B_pos];

        if (AC != BC)
            return AC - BC;

        if (A_pos == A_end)
            return 0;
    }
}

int StringPrefixCompare(std::string_view A, std::string_view B)
{
    size_t        A_pos = 0;
    size_t        B_pos = 0;
    size_t        A_end = A.size();
    size_t        B_end = B.size();
    unsigned char AC    = 0;
    unsigned char BC    = 0;

    for (;; A_pos++, B_pos++)
    {
        if (A_pos >= A_end)
            AC = 0;
        else
            AC = (int)(unsigned char)A[A_pos];
        if (B_pos >= B_end)
            BC = 0;
        else
            BC = (int)(unsigned char)B[B_pos];

        if (B_pos == B_end)
            return 0;

        if (AC != BC)
            return AC - BC;
    }
}

int StringCaseCompare(std::string_view A, std::string_view B)
{
    size_t        A_pos = 0;
    size_t        B_pos = 0;
    size_t        A_end = A.size();
    size_t        B_end = B.size();
    unsigned char AC    = 0;
    unsigned char BC    = 0;

    for (;; A_pos++, B_pos++)
    {
        if (A_pos >= A_end)
            AC = 0;
        else
        {
            AC = (int)(unsigned char)A[A_pos];
            if (AC > '@' && AC < '[')
                AC ^= 0x20;
        }
        if (B_pos >= B_end)
            BC = 0;
        else
        {
            BC = (int)(unsigned char)B[B_pos];
            if (BC > '@' && BC < '[')
                BC ^= 0x20;
        }

        if (AC != BC)
            return AC - BC;

        if (A_pos == A_end)
            return 0;
    }
}

int StringPrefixCaseCompare(std::string_view A, std::string_view B)
{
    size_t        A_pos = 0;
    size_t        B_pos = 0;
    size_t        A_end = A.size();
    size_t        B_end = B.size();
    unsigned char AC    = 0;
    unsigned char BC    = 0;

    for (;; A_pos++, B_pos++)
    {
        if (A_pos >= A_end)
            AC = 0;
        else
        {
            AC = (int)(unsigned char)A[A_pos];
            if (AC > '@' && AC < '[')
                AC ^= 0x20;
        }
        if (B_pos >= B_end)
            BC = 0;
        else
        {
            BC = (int)(unsigned char)B[B_pos];
            if (BC > '@' && BC < '[')
                BC ^= 0x20;
        }

        if (B_pos == B_end)
            return 0;

        if (AC != BC)
            return AC - BC;
    }
}

void StringRemoveCRLF(std::string *str) {
    if (!str->empty()) {
        if (str->back() == '\n') {
            str->pop_back();
        }
        if (str->back() == '\r') {
            str->pop_back();
        }
    }
}

void StringReplaceChar(std::string *str, char old_ch, char new_ch) {
    // when 'new_ch' is zero, the character is simply removed

    SYS_ASSERT(old_ch != '\0');

    while (true) {
        auto it = std::find(str->begin(), str->end(), old_ch);
        if (it == str->end()) {
            // found them all
            break;
        }
        if (new_ch == '\0') {
            str->erase(it);
        } else {
            *it = new_ch;
        }
    }
}

std::string StringFormat(std::string_view fmt, ...)
{
	/* Algorithm: keep doubling the allocated buffer size
	 * until the output fits. Based on code by Darren Salt.
	 */
	int buf_size = 128;

	for (;;)
	{
		char *buf = new char[buf_size];

		va_list args;

		va_start(args, fmt);
		int out_len = vsnprintf(buf, buf_size, fmt.data(), args);
		va_end(args);

		// old versions of vsnprintf() simply return -1 when
		// the output doesn't fit.
		if (out_len >= 0 && out_len < buf_size)
		{
			std::string result(buf);
			delete[] buf;

			return result;
		}

		delete[] buf;

		buf_size *= 2;
	}
}

std::string NumToString(unsigned long long int value) {
    return StringFormat("%llu", value);;
}

std::string NumToString(int value) {
    return StringFormat("%d", value);
}

std::string NumToString(double value) { 
    return StringFormat("%f", value); 
}

int StringToInt(const std::string &value) {
    return atoi(value.c_str());
}

double StringToDouble(const std::string &value) { 
    return strtod(value.data(), nullptr);
}

char *mem_gets(char *buf, int size, const char **str_ptr) {
    // This is like fgets() but reads lines from a string.
    // The pointer at 'str_ptr' will point to the next line
    // after this call (or the trailing NUL).
    // Lines which are too long will be truncated (silently).
    // Returns NULL when at end of the string.

    SYS_ASSERT(str_ptr && *str_ptr);
    SYS_ASSERT(size >= 4);

    const char *p = *str_ptr;

    if (!*p) {
        return NULL;
    }

    char *dest = buf;
    char *dest_end = dest + (size - 2);

    for (; *p && *p != '\n'; p++) {
        if (dest < dest_end) {
            *dest++ = *p;
        }
    }

    if (*p == '\n') {
        *dest++ = *p++;
    }

    *dest = 0;

    *str_ptr = p;

    return buf;
}

//------------------------------------------------------------------------

/* Thomas Wang's 32-bit Mix function */
uint32_t IntHash(uint32_t key) {
    key += ~(key << 15);
    key ^= (key >> 10);
    key += (key << 3);
    key ^= (key >> 6);
    key += ~(key << 11);
    key ^= (key >> 16);

    return key;
}

uint32_t StringHash(const std::string &str) {
    uint32_t hash = 0;

    if (!str.empty()) {
        for (auto c : str) {
            hash = (hash << 5) - hash + c;
        }
    }

    return hash;
}

uint64_t StringHash64(const std::string &str) {
    uint32_t hash1 = 0;
    uint32_t hash2 = 0;

    if (!str.empty()) {
        for (auto c : str) {
            hash1 = (hash1 << 5) - hash1 + c;
        }
        for (size_t c = str.size()-1; c > 0; c--) {
            hash2 = (hash2 << 5) - hash2 + str.at(c);
        }
    }

    return (uint64_t)(((uint64_t)hash1 << 32) | hash2);
}

double PerpDist(double x, double y, double x1, double y1, double x2,
                double y2) {
    x -= x1;
    y -= y1;
    x2 -= x1;
    y2 -= y1;

    double len = sqrt(x2 * x2 + y2 * y2);

    SYS_ASSERT(len > 0);

    return (x * y2 - y * x2) / len;
}

double AlongDist(double x, double y, double x1, double y1, double x2,
                 double y2) {
    x -= x1;
    y -= y1;
    x2 -= x1;
    y2 -= y1;

    double len = sqrt(x2 * x2 + y2 * y2);

    SYS_ASSERT(len > 0);

    return (x * x2 + y * y2) / len;
}

double CalcAngle(double sx, double sy, double ex, double ey) {
    // result is Degrees (0 <= angle < 360).
    // East  (increasing X) -->  0 degrees
    // North (increasing Y) --> 90 degrees

    ex -= sx;
    ey -= sy;

    if (fabs(ex) < 0.0001) {
        return (ey > 0) ? 90.0 : 270.0;
    }

    if (fabs(ey) < 0.0001) {
        return (ex > 0) ? 0.0 : 180.0;
    }

    double angle = atan2(ey, ex) * 180.0 / M_PI;

    if (angle < 0) {
        angle += 360.0;
    }

    return angle;
}

double DiffAngle(double A, double B) {
    // A + result = B
    // result ranges from -180 to +180

    double D = B - A;

    while (D > 180.0) {
        D = D - 360.0;
    }
    while (D < -180.0) {
        D = D + 360.0;
    }

    return D;
}

double ComputeDist(double sx, double sy, double ex, double ey) {
    return sqrt((ex - sx) * (ex - sx) + (ey - sy) * (ey - sy));
}

double ComputeDist(double sx, double sy, double sz, double ex, double ey,
                   double ez) {
    return sqrt((ex - sx) * (ex - sx) + (ey - sy) * (ey - sy) +
                (ez - sz) * (ez - sz));
}

double PointLineDist(double x, double y, double x1, double y1, double x2,
                     double y2) {
    x -= x1;
    y -= y1;
    x2 -= x1;
    y2 -= y1;

    double len_squared = (x2 * x2 + y2 * y2);

    SYS_ASSERT(len_squared > 0);

    double along_frac = (x * x2 + y * y2) / len_squared;

    // three cases:
    //   (a) off the "left" side (closest to start point)
    //   (b) off the "right" side (closest to end point)
    //   (c) in-between : use the perpendicular distance

    if (along_frac <= 0) {
        return sqrt(x * x + y * y);

    } else if (along_frac >= 1) {
        return ComputeDist(x, y, x2, y2);

    } else {
        // perp dist
        return fabs(x * y2 - y * x2) / sqrt(len_squared);
    }
}

void CalcIntersection(double nx1, double ny1, double nx2, double ny2,
                      double px1, double py1, double px2, double py2, double *x,
                      double *y) {
    // NOTE: lines are extended to infinity to find the intersection

    double a = PerpDist(nx1, ny1, px1, py1, px2, py2);
    double b = PerpDist(nx2, ny2, px1, py1, px2, py2);

    // BIG ASSUMPTION: lines are not parallel or colinear
    SYS_ASSERT(fabs(a - b) > 1e-6);

    // determine the intersection point
    double along = a / (a - b);

    *x = nx1 + along * (nx2 - nx1);
    *y = ny1 + along * (ny2 - ny1);
}

std::pair<double, double> AlongCoord(const double along, const double px1,
                                     const double py1, const double px2,
                                     const double py2) {
    const double len = ComputeDist(px1, py1, px2, py2);

    return {
        px1 + along * (px2 - px1) / len,
        py1 + along * (py2 - py1) / len,
    };
}

bool VectorSameDir(const double dx1, const double dy1, const double dx2,
                   const double dy2) {
    return dx1 * dx2 + dy1 * dy2 >= 0;
}

//------------------------------------------------------------------------

uint32_t TimeGetMillies()
{
    return (uint32_t)std::chrono::duration_cast<std::chrono::milliseconds>(
               std::chrono::system_clock::now().time_since_epoch())
        .count();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
