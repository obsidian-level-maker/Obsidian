//----------------------------------------------------------------------------
//
// File:        geometry.hpp
// Date:        26-October-1994
// Programmer:  Marc Rousseau
//
// Description:
//
// Copyright (c) 1994-2004 Marc Rousseau, All Rights Reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
//
// Revision History:
//
//----------------------------------------------------------------------------

#ifndef GEOMETRY_HPP_
#define GEOMETRY_HPP_

#if ! defined ( COMMON_HPP_ )
    #include "common.hpp"
#endif

struct sPoint;
struct sRectangle;

struct sPoint {
    long x;
    long y;
    sPoint ()						{ x = 0;   y = 0; }
    sPoint ( long _x, long _y )				{ x = _x;  y = _y; }
    bool isInside ( const sRectangle & ) const;
    bool operator == ( const sPoint &o ) const 		{ return ( x == o.x ) && ( y == o.y ); }
    bool operator != ( const sPoint &o ) const		{ return ( x != o.x ) || ( y != o.y ); }
};

struct sLine {
    sPoint start;
    sPoint end;
    sLine () : start (), end ()                         {}
    sLine ( const sPoint &s, const sPoint &e )		{ start = s; end = e; }
    int rise () const					{ return end.y - start.y; }
    int run () const					{ return end.x - start.x; }
    float slope () const				{ return rise () / ( float ) run (); }
    bool endMatches ( const sLine & ) const;
    bool isInside ( const sRectangle & ) const;
    bool intersects ( const sRectangle & ) const;
    bool intersects ( const sLine & ) const;
};

struct sRectangle {
    int xLeft, xRight;
    int yTop, yBottom;
    sRectangle ();
    sRectangle ( long, long, long, long );
    sRectangle ( const sPoint &, const sPoint & );
    void include ( const sPoint & );
    void include ( const sRectangle & );
    long left () const					{ return xLeft; }
    long right () const					{ return xRight; }
    long top () const					{ return yTop; }
    long bottom () const				{ return yBottom; }
    long width () const					{ return xRight - xLeft; }
    long height () const				{ return yTop - yBottom; }
    sPoint center () const				{ return sPoint (( xLeft + xRight ) / 2, ( yTop + yBottom ) / 2 ); }
    sPoint tl () const	       				{ return sPoint ( xLeft, yTop ); }
    sPoint bl () const	       				{ return sPoint ( xLeft, yBottom ); }
    sPoint tr () const	       				{ return sPoint ( xRight, yTop ); }
    sPoint br () const	       				{ return sPoint ( xRight, yBottom ); }
    bool isInside ( const sRectangle & ) const;
    bool intersects ( const sRectangle & ) const;
};

inline sRectangle::sRectangle ()
{
    xLeft = yTop = xRight = yBottom = 0;
}

#endif
