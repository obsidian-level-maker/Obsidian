//------------------------------------------------------------------------
//  Main defines
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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

#ifndef __OBLIGE_MAIN_H__
#define __OBLIGE_MAIN_H__

#define OBLIGE_TITLE  "OBLIGE Level Maker"

#define OBLIGE_VERSION  "3.60"
#define OBLIGE_HEX_VER  0x360

extern const char *install_path;
extern const char *working_path;
extern const char *data_path;

extern bool batch_mode;
extern bool create_backups;
extern bool hide_module_panel;
extern bool debug_messages;

extern const char *batch_output_file;


void Main_FatalError(const char *msg, ...);
void Main_ProgStatus(const char *msg, ...);
void Main_Ticker();


class game_interface_c
{
  /* this is an abstract base class */

public:
  game_interface_c()
  { }

  virtual ~game_interface_c()
  { }

  /*** MAIN ***/

  virtual bool Start() = 0;
  // this selects an output filename or directory and prepares
  // for building a set of levels.  Returns false if an error
  // occurs (or the user simply Cancel'd).

  virtual bool Finish(bool build_ok) = 0;
  // this is called after all levels are done.  The 'build_ok'
  // value is the result from the LUA script, and is false if
  // an error occurred or the user clicked Abort.
  //
  // For DOOM this will run glBSP node builder, for QUAKE it will
  // put all the BSP files into the final PAK file.
  //
  // Returns false on error.  Note that Finish() is never
  // called if Start() fails.

  /*** CSG2 ***/

  virtual void BeginLevel() = 0;
  // this will set things up in preparation for the next level
  // being built.  It is called after the CSG2 code sets itself
  // up and hence could alter some CSG2 parameters, other than
  // that there is lttle need to do anything here.

  virtual void EndLevel() = 0;
  // called when all the brushes and entities have been added
  // but before the CSG2 performs a cleanup.  Typically the
  // game-specific code will call CSG2_MergeAreas() and convert
  // the result to the game-specific level format.

  virtual void Property(const char *key, const char *value) = 0;
  // sets a certain property, especially "level_name" which is
  // required by most games (like DOOM and QUAKE).  Unknown
  // properties are ignored.
};


extern game_interface_c * game_object;


/* interface for each game format */

game_interface_c * Doom_GameObject();
game_interface_c * Nukem_GameObject();
game_interface_c * Quake1_GameObject();
game_interface_c * Wolf_GameObject();
// game_interface_c * Quake2_GameObject();


#endif /* __OBLIGE_MAIN_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
