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

#pragma once

#include <string>

namespace ajparse
{

enum TokenKind
{
    kTokenEOF = 0,
    kTokenError,
    kTokenIdentifier,
    kTokenSymbol,
    kTokenNumber,
    kTokenString
};

class Lexer
{
  public:
    Lexer(const std::string &data) : data_(data), pos_(0), line_(1)
    {
    }

    ~Lexer()
    {
    }

    // parse the next token, storing contents into given string.
    // returns kTokenEOF at the end of the data, and kTokenError when a
    // problem is encountered (s will be an error message).
    TokenKind Next(std::string &s);

    // check if the next token is an identifier or symbol matching the
    // given string.  the match is not case sensitive.  if it matches,
    // the token is consumed and true is returned.  if not, false is
    // returned and the position is unchanged.
    bool Match(const char *s);

    // as above, but the token is never consumed
    bool MatchKeep(const char *s);

    // give the line number for the last token returned by Next() or
    // the token implicitly checked by Match().  can be used to show
    // where in the file an error occurred.
    int LastLine();

    // rewind to the very beginning.
    void Rewind();

    // get current lexer position
    size_t GetPos();

  private:
    const std::string &data_;

    size_t pos_;
    int    line_;

    void SkipToNext();

    TokenKind ParseIdentifier(std::string &s);
    TokenKind ParseNumber(std::string &s);
    TokenKind ParseString(std::string &s);

    void ParseEscape(std::string &s);
};

// helpers for converting numeric tokens.
int    LexInteger(const std::string &s);
double LexDouble(const std::string &s);
bool   LexBoolean(const std::string &s);

} // namespace ajparse

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
