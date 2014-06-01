//
// Menu button header file for the Fast Light Tool Kit (FLTK).
//
// Copyright 1998-2010 by Bill Spitzak and others.
//
// This library is free software. Distribution and use rights are outlined in
// the file "COPYING" which should have been included with this file.  If this
// file is missing or damaged, see the license at:
//
//     http://www.fltk.org/COPYING.php
//
// Please report all bugs and problems on the following page:
//
//     http://www.fltk.org/str.php
//

//----------------------------------------------------------------
//
// Modified 1/June/2014 by Andrew Apted, from FLTK 1.3.2
//
// Provides an Fl_Menu_Across, based on Fl_Menu_Button, which puts
// the menu to the right of the button (instead of under it).
//
//----------------------------------------------------------------

#ifndef Fl_Menu_ACROSS_H
#define Fl_Menu_ACROSS_H

#include <FL/Fl_Menu_.H>

class FL_EXPORT Fl_Menu_Across : public Fl_Menu_ {
protected:
  void draw();
public:
  int handle(int);
  const Fl_Menu_Item* popup();
  Fl_Menu_Across(int,int,int,int,const char * =0);
};

#endif

