------------------------------------------------------------------------
--  REKKR THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

REKKR.THEMES =
{
  DEFAULTS =
  {   
    slump_config = 
    [[
      ;
      ; Sample SLIGE config file. (Semicolon starts a comment to end of line.)
      ;
      ; This is the SLIGE.CFG as shipped with SLIGE itself.  It contains a
      ; description of the default SLIGE configuration, as hardwired into
      ; the program.  So having this file in the current directory under the
      ; name SLIGE.CFG should produce exactly the same effect as not having
      ; any config file at all.  You can use this file as a base to build
      ; your own config files on (but if you do, you should change these
      ; comments; otherwise they'll be WRONG!).
      ;
      ; Dave Chess, dmchess@aol.com, chess@us.ibm.com

      ; The current implementation ignores everything before the
      ; [THEMES] line also, but that will change.

      [THEMES]        ; Anything after a ; is, remember, a comment

      ; We have three themes, one secret.  They should all be declared
      ; before any textures or flats or anything else.  The only valid
      ; modifier is "secret", which says that that theme should only be
      ; used on secret levels.  There should be at least one "secret"
      ; theme.

	  Theme RAM ; Rampart (castle-ish)

      ; Flats and textures and constructs and stuff are also in the [THEMES] section

      ; Textures are described by "Texture NAME <attributes>".  Obvious
      ; attributes include "wall", "door", and so on.  Some subtler ones:
      ;
      ; "core <theme>" means that this texture should be common in that theme.
      ; "comp <theme>" means that this texture is compatible with that theme, but
      ;    not to be used all that often.
      ; "switch <texture>" means "the given texture is a good switch to use in
      ;    a room that has walls of the current texture"
      ; "isswitch" means "the current texture is a good switch to use on any
      ;    wall in a room with a compatible theme"
      ; "subtle <texture>" means "the given texture is a subtle variant of the
      ;    current texture, suitable for hinting at secrets"
      ; "yhint N" means "when using a vertical misalignment to hint at
      ;    a secret door in a wall of this texture, use a y-offset of N".  If
      ;    N is zero, it means "this wall is too visually complex to hint via a
      ;    y-misalignment at all; hint some other way".  If no "yhint" is given,
      ;    the value 5 is used.
      ;  "noDoom2" means that the texture does not exist in the usual DOOM II
      ;    IWAD.  "noDoom0" means it doesn't exist in the DOOM 1.2 IWAD, and
      ;    "noDoom1" means it's not in the DOOM 1.666 or 1.89 IWAD.  If none
      ;    of these are specified, the texture is assumed to be in all.
      ;  "size <width> <height>" gives the size of the texture.  You can leave
      ;    this out if the height is 128, and the width is some reasonable
      ;    divisor of 256 (except for doors, where you should give the real
      ;    width so SLIGE can make them look nice).

	  ; Rampart walls
	  Texture DVSTON9 size 128 128 wall core RAM
    Texture DVSTON6 size 128 128 wall core RAM
    Texture DVSTON16 size 128 128 wall core RAM
    Texture DVSTON17 size 128 128 wall core RAM
    Texture DVBRKW4 size 64 128 wall comp RAM

	  ; Lab switches
	  Texture SW1GARG size 64 128 isswitch comp RAM

      ; And the lift texture
      Texture DVROCK6 size 128 128 lift comp RAM

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture DVDORB2 size 128 128 door comp RAM
	  Texture DVDORS size 64 128 door comp RAM

	  ; Rampart exit switches
	  Texture SW1GARG size 64 128 exitswitch comp RAM

      ; Lights, suitable for lighting recesses and stuff.
	  Texture DVLIGHT6 size 64 128 light comp RAM

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
	  Texture DVROCK28 size 128 128 plaque vtiles comp RAM

      ; Gratings
      Texture DVMIDM2 size 64 128 grating comp RAM

      ; Colors (suitable for marking key-locked things)
      Texture DVKEYCOR size 64 128 red comp RAM
      Texture DVKEYCOY size 64 128 yellow comp RAM
      Texture DVKEYCOB size 64 128 blue comp RAM

    ; Step kickplates
    Texture KS_LADH size 64 8 step comp RAM

    ; "Doorjambs"
    Texture DVBLACK size 64 128 jamb comp RAM

    ; Support textures, used in various places
    Texture DVDRK19 size 64 128 support comp RAM
	  Texture DVROCK70 size 128 128 support comp RAM

    ; Bunch of things for outside patios (no themes applied here)
	  Texture DVSTON9 size 128 128 outside

    ; Misc
    Texture DVMUSAW size 64 128 error

    ; Now the flats.  Keywords should all be pretty obvious...   *8)

    ; Teleport-gate floors
    Flat GATE1 gate comp RAM

    ; Rampart floors and ceilings
    Flat FLAT22 ceiling light comp RAM
    Flat CEIL1_3 ceiling outside comp RAM
	  Flat STEP1 floor comp RAM
    Flat FLAT4 ceiling comp RAM
    Flat FLAT4 floor outside comp RAM

    ; and nukage
    Flat NUKAGE1 nukage comp RAM
    Flat LAVA1 nukage red comp RAM

    ; Floors for outside areas not yet mentioned
    Flat FLOOR3_3 outside

    ; These are the defaults, but we'll list them anyway.
    Flat FWATER1 water
    Flat F_SKY1 sky

    ; Constructs: computers and crates and stuff that stand around in rooms
    ; This is pretty complex!  Fool with it at your peril.

    ; Family 1 is crates of various sizes and kinds
    Construct family 1 height 128 comp RAM
      top CEIL1_1
      Primary DVCRATES width 64

    ; Load the hardwired monster and object and so on data (required in
    ; this version of SLIGE; don't remove this!)
    Hardwired1

    ; Say which lamps we like in which themes, and where barrels are allowed
    ; Information like which Doom version each object is in, and which ones
    ; cast light, and which ones explode, is still hardwired.
    Thing 2028 comp RAM  ; floor lamp

    ; and that's it!
    ]]
  },

  rampart =
  {
    slump_config = 
    [[
      ;
      ; Sample SLIGE config file. (Semicolon starts a comment to end of line.)
      ;
      ; This is the SLIGE.CFG as shipped with SLIGE itself.  It contains a
      ; description of the default SLIGE configuration, as hardwired into
      ; the program.  So having this file in the current directory under the
      ; name SLIGE.CFG should produce exactly the same effect as not having
      ; any config file at all.  You can use this file as a base to build
      ; your own config files on (but if you do, you should change these
      ; comments; otherwise they'll be WRONG!).
      ;
      ; Dave Chess, dmchess@aol.com, chess@us.ibm.com

      ; The current implementation ignores everything before the
      ; [THEMES] line also, but that will change.

      [THEMES]        ; Anything after a ; is, remember, a comment

      ; We have three themes, one secret.  They should all be declared
      ; before any textures or flats or anything else.  The only valid
      ; modifier is "secret", which says that that theme should only be
      ; used on secret levels.  There should be at least one "secret"
      ; theme.

	  Theme RAM ; Rampart (castle-ish)

      ; Flats and textures and constructs and stuff are also in the [THEMES] section

      ; Textures are described by "Texture NAME <attributes>".  Obvious
      ; attributes include "wall", "door", and so on.  Some subtler ones:
      ;
      ; "core <theme>" means that this texture should be common in that theme.
      ; "comp <theme>" means that this texture is compatible with that theme, but
      ;    not to be used all that often.
      ; "switch <texture>" means "the given texture is a good switch to use in
      ;    a room that has walls of the current texture"
      ; "isswitch" means "the current texture is a good switch to use on any
      ;    wall in a room with a compatible theme"
      ; "subtle <texture>" means "the given texture is a subtle variant of the
      ;    current texture, suitable for hinting at secrets"
      ; "yhint N" means "when using a vertical misalignment to hint at
      ;    a secret door in a wall of this texture, use a y-offset of N".  If
      ;    N is zero, it means "this wall is too visually complex to hint via a
      ;    y-misalignment at all; hint some other way".  If no "yhint" is given,
      ;    the value 5 is used.
      ;  "noDoom2" means that the texture does not exist in the usual DOOM II
      ;    IWAD.  "noDoom0" means it doesn't exist in the DOOM 1.2 IWAD, and
      ;    "noDoom1" means it's not in the DOOM 1.666 or 1.89 IWAD.  If none
      ;    of these are specified, the texture is assumed to be in all.
      ;  "size <width> <height>" gives the size of the texture.  You can leave
      ;    this out if the height is 128, and the width is some reasonable
      ;    divisor of 256 (except for doors, where you should give the real
      ;    width so SLIGE can make them look nice).

	  ; Rampart walls
	  Texture DVSTON9 size 128 128 wall core RAM
    Texture DVSTON6 size 128 128 wall core RAM
    Texture DVSTON16 size 128 128 wall core RAM
    Texture DVSTON17 size 128 128 wall core RAM
    Texture DVBRKW4 size 64 128 wall comp RAM

	  ; Lab switches
	  Texture SW1GARG size 64 128 isswitch comp RAM

      ; And the lift texture
      Texture DVROCK6 size 128 128 lift comp RAM

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture DVDORB2 size 128 128 door comp RAM
	  Texture DVDORS size 64 128 door comp RAM

	  ; Rampart exit switches
	  Texture SW1GARG size 64 128 exitswitch comp RAM

      ; Lights, suitable for lighting recesses and stuff.
	  Texture DVVERT size 64 128 light comp RAM

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
	  Texture DVROCK28 size 128 128 plaque vtiles comp RAM

      ; Gratings
      Texture DVMIDM2 size 64 128 grating comp RAM

      ; Colors (suitable for marking key-locked things)
      Texture DVKEYCOR size 64 128 red comp RAM
      Texture DVKEYCOY size 64 128 yellow comp RAM
      Texture DVKEYCOB size 64 128 blue comp RAM

    ; Step kickplates
    Texture KS_LADH size 64 8 step comp RAM

    ; "Doorjambs"
    Texture DVBLACK size 64 128 jamb comp RAM

    ; Support textures, used in various places
    Texture DVDRK2 size 64 128 support comp RAM
	  Texture DVROCK70 size 128 128 support comp RAM

    ; Bunch of things for outside patios (no themes applied here)
	  Texture DVSTON9 size 128 128 outside

    ; Misc
    Texture DVMUSAW size 64 128 error

    ; Now the flats.  Keywords should all be pretty obvious...   *8)

    ; Teleport-gate floors
    Flat GATE1 gate comp RAM

    ; Rampart floors and ceilings
    Flat FLAT14 ceiling light comp RAM
    Flat CEIL1_3 ceiling outside comp RAM
	  Flat STEP1 floor comp RAM
    Flat FLAT4 ceiling comp RAM
    Flat FLAT4 floor outside comp RAM

    ; and nukage
    Flat NUKAGE1 nukage comp RAM
    Flat LAVA1 nukage red comp RAM

    ; Floors for outside areas not yet mentioned
    Flat FLOOR3_3 outside

    ; These are the defaults, but we'll list them anyway.
    Flat FWATER1 water
    Flat F_SKY1 sky

    ; Constructs: computers and crates and stuff that stand around in rooms
    ; This is pretty complex!  Fool with it at your peril.

    ; Family 1 is crates of various sizes and kinds
    Construct family 1 height 128 comp RAM
      top CEIL1_1
      Primary DVCRATES width 64

    ; Load the hardwired monster and object and so on data (required in
    ; this version of SLIGE; don't remove this!)
    Hardwired1

    ; Say which lamps we like in which themes, and where barrels are allowed
    ; Information like which Doom version each object is in, and which ones
    ; cast light, and which ones explode, is still hardwired.
    Thing 2028 comp RAM  ; floor lamp

    ; and that's it!
    ]]
  },
  
}
------------------------------------------------------------------------

function REKKR.slump_setup()
  if ob_match_game({game = {rekkr=1}}) then
    if OB_CONFIG.theme == "default" then
      PARAM.slump_config = REKKR.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" then
      local possible_configs = {}
      for _,tab in pairs(REKKR.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif REKKR.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = REKKR.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = REKKR.THEMES.DEFAULTS.slump_config
    end
  end
end

------------------------------------------------------------------------

OB_THEMES["rampart"] =
{
  label = _("Rampart"),
  game = "rekkr",
  name_class = "TECH",
  mixed_prob = 34
}