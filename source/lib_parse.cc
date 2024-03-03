//----------------------------------------------------------------------------
//  Lexer (tokenizer)
//----------------------------------------------------------------------------
//
//  Copyright (c) 2024 The OBSIDIAN Team.
//  Copyright (c) 2022-2024 The EDGE Team.
//  Copyright (c) 2022  Andrew Apted
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

#include "lib_parse.h"

#include <ctype.h>
#include <stdlib.h>

#include "lib_util.h"
#include "sys_debug.h"

namespace ajparse
{

TokenKind Lexer::Next(std::string &s)
{
    s.clear();

    SkipToNext();

    if (pos_ >= data_.size()) return kTokenEOF;

    unsigned char ch = (unsigned char)data_[pos_];

    if (ch == '"') return ParseString(s);

    if (ch == '-' || ch == '+' || IsDigitASCII(ch)) return ParseNumber(s);

    if (IsAlphaASCII(ch) || ch == '_' || ch >= 128) return ParseIdentifier(s);

    // anything else is a single-character symbol
    s.push_back(data_[pos_++]);

    return kTokenSymbol;
}

bool Lexer::Match(const char *s)
{
    SYS_ASSERT(s);
    SYS_ASSERT(s[0]);

    bool is_keyword = IsAlphanumericASCII(s[0]);

    SkipToNext();

    size_t ofs = 0;

    for (; *s != 0; s++, ofs++)
    {
        if (pos_ + ofs >= data_.size()) return false;

        unsigned char A = (unsigned char)data_[pos_ + ofs];
        unsigned char B = (unsigned char)s[0];

        // don't change a char when high-bit is set (for UTF-8)
        if (A < 128) A = ToLowerASCII(A);
        if (B < 128) B = ToLowerASCII(B);

        if (A != B) return false;
    }

    pos_ += ofs;

    // for a keyword, require a non-alphanumeric char after it.
    if (is_keyword && pos_ < data_.size())
    {
        unsigned char ch = (unsigned char)data_[pos_];

        if (IsAlphanumericASCII(ch) || ch >= 128) return false;
    }

    return true;
}

bool Lexer::MatchKeep(const char *s)
{
    SYS_ASSERT(s);
    SYS_ASSERT(s[0]);

    bool is_keyword = IsAlphanumericASCII(s[0]);

    SkipToNext();

    size_t ofs = 0;

    for (; *s != 0; s++, ofs++)
    {
        if (pos_ + ofs >= data_.size()) return false;

        unsigned char A = (unsigned char)data_[pos_ + ofs];
        unsigned char B = (unsigned char)s[0];

        // don't change a char when high-bit is set (for UTF-8)
        if (A < 128) A = ToLowerASCII(A);
        if (B < 128) B = ToLowerASCII(B);

        if (A != B) return false;
    }

    // for a keyword, require a non-alphanumeric char after it.
    if (is_keyword && pos_ + ofs < data_.size())
    {
        unsigned char ch = (unsigned char)data_[pos_ + ofs];

        if (IsAlphanumericASCII(ch) || ch >= 128) return false;
    }

    return true;
}

int Lexer::LastLine() { return line_; }

void Lexer::Rewind()
{
    pos_  = 0;
    line_ = 1;
}

size_t Lexer::GetPos() { return pos_; }

int LexInteger(const std::string &s)
{
    // strtol handles all the integer sequences of the UDMF spec
    return (int)strtol(s.c_str(), nullptr, 0);
}

double LexDouble(const std::string &s)
{
    // strtod handles all the floating-point sequences of the UDMF spec
    return strtod(s.c_str(), nullptr);
}

bool LexBoolean(const std::string &s)
{
    if (s.empty()) return false;

    return (s[0] == 't' || s[0] == 'T');
}

void Lexer::SkipToNext()
{
    while (pos_ < data_.size())
    {
        unsigned char ch = (unsigned char)data_[pos_];

        // bump line number at end of a line
        if (ch == '\n') line_ += 1;

        // skip whitespace and control chars
        if (ch <= 32 || ch == 127)
        {
            pos_++;
            continue;
        }

        if (ch == '/' && pos_ + 1 < data_.size())
        {
            // single line comment?
            if (data_[pos_ + 1] == '/')
            {
                pos_ += 2;

                while (pos_ < data_.size() && data_[pos_] != '\n') pos_++;

                continue;
            }

            // multi-line comment?
            if (data_[pos_ + 1] == '*')
            {
                pos_ += 2;

                while (pos_ < data_.size())
                {
                    if (pos_ + 1 < data_.size() && data_[pos_] == '*' &&
                        data_[pos_ + 1] == '/')
                    {
                        pos_ += 2;
                        break;
                    }

                    if (data_[pos_] == '\n') line_ += 1;

                    pos_++;
                }

                continue;
            }
        }

        // reached a token!
        return;
    }
}

TokenKind Lexer::ParseIdentifier(std::string &s)
{
    // NOTE: we lowercase the identifier put into 's'.

    for (;;)
    {
        unsigned char ch = (unsigned char)data_[pos_];

        // don't change a char when high-bit is set (for UTF-8)
        if (ch < 128) ch = ToLowerASCII(ch);

        if (!(IsAlphanumericASCII(ch) || ch == '_' || ch >= 128)) break;

        s.push_back((char)ch);
        pos_++;
    }

    SYS_ASSERT(s.size() > 0);

    return kTokenIdentifier;
}

TokenKind Lexer::ParseNumber(std::string &s)
{
    if (data_[pos_] == '-' || data_[pos_] == '+')
    {
        // no digits after the sign?
        if (pos_ + 1 >= data_.size() || !IsDigitASCII(data_[pos_ + 1]))
        {
            s.push_back(data_[pos_++]);
            return kTokenSymbol;
        }
    }

    for (;;)
    {
        s.push_back(data_[pos_++]);

        if (pos_ >= data_.size()) break;

        unsigned char ch = (unsigned char)data_[pos_];

        // this is fairly lax, but adequate for our purposes
        if (!(IsAlphanumericASCII(ch) || ch == '+' || ch == '-' || ch == '.'))
            break;
    }

    return kTokenNumber;
}

TokenKind Lexer::ParseString(std::string &s)
{
    // NOTE: we allow newlines ('\n') in the string, rather than produce an
    //       an unterminated-string error.

    pos_++;

    while (pos_ < data_.size())
    {
        unsigned char ch = (unsigned char)data_[pos_++];

        if (ch == '"') break;

        if (ch == '\\')
        {
            ParseEscape(s);
            continue;
        }

        // bump line number at end of a line
        if (ch == '\n') line_ += 1;

        // skip all control characters except TAB and NEWLINE
        if (ch < 32 && !(ch == '\t' || ch == '\n')) continue;

        if (ch == 127)  // DEL
            continue;

        s.push_back((char)ch);
    }

    return kTokenString;
}

void Lexer::ParseEscape(std::string &s)
{
    if (pos_ >= data_.size())
    {
        s.push_back('\\');
        return;
    }

    unsigned char ch = (unsigned char)data_[pos_];

    // avoid control chars, especially newline
    if (ch < 32 || ch == 127)
    {
        s.push_back('\\');
        return;
    }

    pos_++;

    // octal sequence?  1 to 3 digits.
    if ('0' <= ch && ch <= '7')
    {
        int val = (int)(ch - '0');

        ch = (unsigned char)data_[pos_];
        if ('0' <= ch && ch <= '7')
        {
            val = val * 8 + (int)(ch - '0');
            pos_++;
        }

        ch = (unsigned char)data_[pos_];
        if ('0' <= ch && ch <= '7')
        {
            val = val * 8 + (int)(ch - '0');
            pos_++;
        }

        s.push_back((char)val);
        return;
    }

    // hexadecimal sequence?  followed by 1 to 2 hex digits.
    if (ch == 'x' || ch == 'X')
    {
        char  buffer[16];
        char *p = buffer;

        *p++ = '0';
        *p++ = 'x';
        *p++ = '0';

        ch = (unsigned char)data_[pos_];
        if (IsXDigitASCII(ch))
        {
            *p++ = ch;
            pos_++;
        }

        ch = (unsigned char)data_[pos_];
        if (IsXDigitASCII(ch))
        {
            *p++ = ch;
            pos_++;
        }

        *p = 0;

        int val = (int)strtol(buffer, nullptr, 0);
        s.push_back((char)val);
        return;
    }

    switch (ch)
    {
        case 'a':
            s.push_back('\a');
            break;  // bell
        case 'b':
            s.push_back('\b');
            break;  // backspace
        case 'f':
            s.push_back('\f');
            break;  // form feed
        case 'n':
            s.push_back('\n');
            break;  // newline
        case 't':
            s.push_back('\t');
            break;  // tab
        case 'r':
            s.push_back('\r');
            break;  // carriage return
        case 'v':
            s.push_back('\v');
            break;  // vertical tab

        // the default is to reproduce the same character
        default:
            s.push_back(ch);
            break;
    }
}

}  // namespace ajparse

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
