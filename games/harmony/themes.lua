------------------------------------------------------------------------
--  HARMONY THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--  --Adapted from MsrSgtShooterPerson's Doom themes.lua file
    --Into a singular theme (Castle) for Heretic
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HARMONY.THEMES =
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

      Theme MIL
      Theme RED secret


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

      ; MIL walls ; note that in MIL the walls all have explicit switches
      Texture BRONZE4 wall core MIL subtle BRONZE3 switch SW1TEK noDoom0 noDoom1
      Texture STARTAN1 wall core MIL subtle STARTAN2 switch SW1STRTN noDoom2
      Texture STARTAN3 wall core MIL subtle STARG3 switch SW1STRTN
      Texture STARTAN2 wall core MIL subtle STARBR2 switch SW1STRTN
      Texture STARG3 wall core MIL subtle STARGR1 switch SW1STRTN
      Texture STARG2 wall core MIL subtle STARG1 switch SW1STRTN
      Texture STARG1 wall core MIL subtle STARG2 switch SW1STRTN
      Texture BROWN96 wall core MIL subtle BROWNGRN switch SW1DIRT
      Texture TEKGREN2 wall core MIL subtle TEKGREN1 switch SW1TEK noDoom0 noDoom1
      Texture BROWN1 wall core MIL switch SW1BRN2
      Texture STONE wall core MIL subtle GRAY1 switch SW1GRAY
      Texture STONE6 wall comp MIL subtle STONE7 switch SW1STON6 noDoom0 noDoom1
      Texture BROWNGRN wall core MIL subtle BROWN96 switch SW1BRNGN
      Texture SLADWALL wall core MIL subtle BROWNGRN switch SW1SLAD
      Texture PIPEWAL2 wall comp MIL subtle PIPEWAL1 switch SW1COMP noDoom0 noDoom1
      Texture GRAYALT wall core MIL switch SW1GRAY noDoom0 noDoom1 custom
      Texture TEKVINE wall comp MIL subtle TEKWALL1 switch SW1TEK yhint 0 noDoom0 noDoom1 custom
      Texture SPACEW4 wall comp MIL switch SW1TEK noDoom0 noDoom1
      Texture METAL5 wall comp MIL subtle METAL3 switch SW1MET2 noDoom0 noDoom1
      Texture METAL2 switch SW1MET2 noDoom0 noDoom1
      Texture COMPUTE3 wall comp MIL switch SW1STRTN noDoom2
      Texture TEKWALL4 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture TEKWALL1 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture GRAY1 wall comp MIL subtle ICKWALL3 switch SW1GRAY
      Texture GRAY7 wall comp MIL subtle GRAY1 switch SW1GRAY1
      Texture ICKWALL3 wall comp MIL subtle ICKWALL7 switch SW2GRAY
      Texture BROVINE2 wall comp MIL switch SW1SLAD yhint 2
      Texture METAL1 wall comp MIL switch SW1METAL
      Texture STARBR2 wall comp MIL subtle STARTAN2 switch SW1STRTN


      ; And the lift texture
      Texture PLAT1 size 128 128 lift comp MIL


      ; RED walls
      Texture SP_HOT1 wall core RED
      Texture REDWALL wall core RED
      Texture FIREBLU1 wall core RED subtle FIREMAG1 yhint 0
      Texture SW1HOT isswitch comp RED
      ; a wall version of SKY3, just for fun.  You can comment this
      ; out if you think it looks ugly.
      Texture SKY3_W wall comp RED realname SKY3

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture TEKBRON2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR4 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR3 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR1 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture DOORHI size 64 128 door comp MIL noDoom2
      Texture DOOR3 size 64 72 door comp MIL 
      Texture DOOR1 size 64 72 door comp MIL 
      Texture WOODSKUL size 64 128 door comp RED noDoom2
      Texture WOODMET2 size 64 128 door comp RED noDoom0 noDoom1
      Texture WOODGARG size 64 128 door comp RED
      Texture BIGDOOR4 size 128 128 door comp MIL 
      Texture BIGDOOR3 size 128 128 door comp MIL 
      Texture BIGDOOR2 size 128 128 door comp MIL 
      Texture BIGDOOR1 size 128 96 door comp MIL
      Texture BIGDOOR7 size 128 128 door comp RED 
      Texture BIGDOOR6 size 128 112 door comp RED 
      Texture BIGDOOR5 size 128 128 door comp RED
      Texture METAL size 64 128 door comp RED
      ; Our two custom locked-door textures
      Texture DOORSKUL size 64 72 door locked comp MIL noDoom0 noDoom1 custom
      Texture SLDOOR1 size 64 128 door locked comp MIL realname SP_DUDE5 custom

      ; Exit switches, suitable for use on any level-ending switch.  All are
      ; custom, and Doom2-only.
      Texture EXITSWIR exitswitch comp RED noDoom0 noDoom1 custom
      Texture EXITSWIT exitswitch comp MIL noDoom0 noDoom1 custom

      ; Lights, suitable for lighting recesses and stuff.
      Texture BFALL1 size 8 128 light comp RED noDoom0 noDoom1
      Texture LITEREDL size 8 128 light comp RED realname LITERED noDoom2
      Texture TEKLITE light comp MIL noDoom0 noDoom1
      Texture LITE4 light comp MIL noDoom2
      Texture LITE5 light comp MIL
      Texture LITE3 light comp MIL

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
      Texture SILVER3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture SPACEW3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture COMPSTA2 plaque vtiles half_plaque comp MIL
      Texture COMPSTA1 plaque vtiles half_plaque comp MIL
      Texture COMP2 plaque vtiles half_plaque comp MIL
      Texture COMPTALL plaque vtiles comp MIL
      Texture COMPUTE1 plaque vtiles half_plaque comp MIL noDoom2
      Texture PLANET1 plaque vtiles half_plaque comp MIL noDoom2
      Texture SKIN2 plaque vtiles comp RED
      Texture GSTFONT1 plaque comp RED
      Texture FIREMAG1 plaque comp red
      ; Some people think these next two look silly;
      ; you can comment them out if you want to.
      ; Texture SKY1 plaque  
      ; Texture SKY3 plaque comp RED

      ; Gratings
      Texture BRNBIGC grating comp MIL noDoom2
      Texture MIDSPACE grating comp MIL noDoom0 noDoom1
      Texture MIDVINE1 grating comp MIL comp RED noDoom2
      Texture MIDBARS1 grating comp MIL comp RED  noDoom0 noDoom1
      Texture MIDGRATE grating comp MIL comp RED 

      ; Colors (suitable for marking key-locked things)
      Texture LITERED size 8 128 red comp MIL noDoom2
      Texture DOORRED size 8 128 red comp MIL 
      Texture DOORRED2 size 16 128 red  comp RED 
      Texture DOORYEL size 8 128 yellow comp MIL 
      Texture DOORYEL2 size 16 128 yellow comp RED 
      Texture LITEBLU4 size 16 128 blue comp MIL
      Texture LITEBLU1 size 8 128 blue comp MIL
      Texture DOORBLU size 8 128 blue comp MIL 
      Texture DOORBLU2 size 16 128 blue comp RED 

      ; Step kickplates
      Texture STEP6 size 256 16 step comp MIL 
      Texture STEP5 size 256 16 step comp MIL 
      Texture STEP4 size 256 16 step comp MIL
      Texture STEP3 size 256 8 step comp MIL 
      Texture STEP2 size 256 8 step comp MIL
      Texture STEP1 size 256 8 step comp MIL 

      ; "Doorjambs"
      Texture FIRELAVA jamb comp RED
      Texture DOORTRAK jamb comp MIL
      Texture DOORSTOP jamb comp MIL
      ; Texture PIPE2 jamb comp MIL   ; PIPE2 is also a wall texture

      ; Support textures, used in various places
      Texture SKSNAKE2 support comp RED
      Texture ROCKRED1 support comp RED
      Texture COMPSPAN support comp MIL 
      Texture SUPPORT2 support comp MIL 
      Texture SHAWN2 support comp MIL  
      Texture ASHWALL3 support  noDoom0 noDoom1
      Texture ASHWALL support  noDoom2
      Texture BROWNHUG support  comp MIL  
      Texture METAL support comp RED

      ; Bunch of things for outside patios (no themes applied here)
      Texture ZIMMER1 outside noDoom0 noDoom1
      Texture ZIMMER2 outside noDoom0 noDoom1
      Texture ZIMMER3 outside noDoom0 noDoom1
      Texture ZIMMER4 outside noDoom0 noDoom1
      Texture ZIMMER5 outside noDoom0 noDoom1
      Texture ZIMMER7 outside noDoom0 noDoom1
      Texture ZIMMER8 outside noDoom0 noDoom1
      Texture TANROCK5 outside noDoom0 noDoom1
      Texture TANROCK4 outside noDoom0 noDoom1
      Texture TANROCK2 outside noDoom0 noDoom1
      Texture STUCCO outside noDoom0 noDoom1
      Texture STONE6 outside noDoom0 noDoom1
      Texture ROCK1 outside noDoom0 noDoom1
      Texture MODWALL1 outside noDoom0 noDoom1
      Texture BSTONE1 outside noDoom0 noDoom1
      Texture BRICK4 outside noDoom0 noDoom1
      Texture ASHWALL7 outside noDoom0 noDoom1
      Texture ASHWALL6 outside noDoom0 noDoom1
      Texture ASHWALL4 outside noDoom0 noDoom1
      Texture ASHWALL2 outside noDoom0 noDoom1
      Texture SP_ROCK1 outside
      Texture GRAYVINE outside
      Texture ICKWALL3 outside
      Texture BROWN144 outside
      Texture GSTONE1 outside
      Texture GSTVINE1 outside
      Texture BRICK10 outside NoDoom0 NoDoom1
      Texture ASHWALL3 outside NoDoom0 NoDoom1
      Texture ASHWALL outside NoDoom2
      Texture BROWNHUG outside

      ; Misc
      Texture EXITSIGN gateexitsign
      Texture REDWALL error

      ; This silly texture has the switch in the wrong half!
      Texture SW1DIRT ybias 72
      Texture SW1MET2 ybias 64

      ; Now the flats.  Keywords should all be pretty obvious...   *8)

      ; Teleport-gate floors
      Flat SLGATE1 gate  comp MIL  comp RED custom
      Flat GATE4 gate comp MIL comp RED 
      Flat GATE3 gate comp MIL comp RED 
      Flat GATE2 gate comp MIL comp RED 
      Flat GATE1 gate comp MIL comp RED 

      ; Floors and ceilings for MIL theme
      Flat SLLITE1 ceiling light comp MIL custom
      Flat TLITE6_6 ceiling light comp MIL
      Flat TLITE6_5 ceiling light comp MIL
      Flat FLOOR7_1 ceiling outside comp MIL
      Flat FLOOR5_2 ceiling comp MIL
      Flat CEIL3_1 ceiling comp MIL
      Flat CEIL3_2 ceiling comp MIL
      Flat CEIL3_5 ceiling comp MIL
      Flat FLAT14 floor comp MIL
      Flat FLOOR4_1 floor comp MIL
      Flat FLOOR4_8 floor comp MIL
      Flat FLOOR5_1 floor comp MIL
      Flat FLOOR3_3 floor ceiling comp MIL 
      Flat FLOOR0_2 floor comp MIL
      Flat FLOOR0_1 floor comp MIL
      Flat FLAT1_2 floor outside comp MIL
      Flat FLAT5 floor comp MIL
      Flat SLIME14 floor comp MIL noDoom0 noDoom1
      Flat SLIME15 floor comp MIL noDoom0 noDoom1
      Flat SLIME16 floor comp MIL noDoom0 noDoom1
      ; and nukage
      Flat NUKAGE1 nukage comp MIL
      Flat SLIME01 nukage comp MIL noDoom0 noDoom1

      ; Floors and ceilings for (secret) RED theme
      Flat SLSPARKS floor comp RED custom
      Flat SFLR6_4 floor ceiling comp RED
      Flat TLITE6_5 ceiling light comp RED
      Flat FLOOR6_1 floor ceiling red comp RED
      Flat FLOOR1_7 ceiling light comp RED
      Flat FLOOR1_6 floor ceiling red comp RED
      Flat FLAT5_3 floor ceiling red comp RED
      Flat LAVA1 nukage comp RED
      Flat BLOOD1 nukage red comp RED
      Flat RROCK05 nukage comp RED noDoom0 noDoom1

      ; Floors for outside areas not yet mentioned
      Flat SLGRASS1 outside custom
      Flat SLIME13 outside noDoom0 noDoom1
      Flat RROCK19 outside noDoom0 noDoom1
      Flat RROCK16 outside noDoom0 noDoom1
      Flat RROCK11 outside noDoom0 noDoom1
      Flat GRNROCK outside noDoom0 noDoom1
      Flat GRASS2 outside noDoom0 noDoom1
      Flat GRASS1 outside noDoom0 noDoom1
      Flat MFLR8_4 outside
      Flat MFLR8_3 outside
      Flat MFLR8_2 outside
      Flat FLAT5_7 outside
      Flat FLAT10 outside

      ; These are the defaults, but we'll list them anyway.
      Flat FWATER1 water
      Flat F_SKY1 sky

      ; Constructs: computers and crates and stuff that stand around in rooms
      ; This is pretty complex!  Fool with it at your peril.

      ; Family 1 is silver-colored computers; short ones and tall ones
      Construct family 1 height 64 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary COMPUTE1 yoffsets 0 64
        Primary COMPSTA2
        Primary COMPSTA1
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16
      Construct family 1 height 128 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary SILVER3
        Primary COMPUTE1 yoffsets 0 64
        Secondary SILVER2 width 64
        Secondary SILVER1 width 64
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16

      ; Family 2 is dark-colored computers; short and tall
      Construct family 2 height 64 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 yoffsets 0 64 width 64
        Primary COMPTALL yoffsets 0 64 width 256
        Primary COMP2 yoffsets 0 64 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16
      Construct family 2 height 128 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 width 64
        Primary COMPTALL width 256
        Primary COMP2 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16

      ; Family 3 is crates of various sizes and kinds
      Construct family 3 height 64  comp MIL 
        top CRATOP2
        Primary CRATWIDE yoffsets 64 64
        Primary CRATE1 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATWIDE
        Primary CRATE2 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 32  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 16  comp MIL 
        top CRATOP1
        Primary CRATINY width 16

      ; And Family 4 is bookcases; works only in Doom2
      Construct family 4 height 128 noDoom0 noDoom1
        top FLAT5_1 top CRATOP2 top CEIL5_2 top CEIL3_3 top CEIL1_1
        Secondary PANEL5 width 64
        Secondary PANCASE2 width 64
        Secondary PANCASE1 width 64
        Secondary PANBORD2 width 16
        Secondary PANBORD1 width 32
        Primary PANBOOK width 64

      ; Mask-adjustments for the construct textures that need it
      Texture PANEL5 noDoom0 noDoom1
      Texture PANCASE2 noDoom0 noDoom1
      Texture PANCASE1 noDoom0 noDoom1
      Texture PANBORD2 noDoom0 noDoom1
      Texture PANBORD1 noDoom0 noDoom1
      Texture METAL7 noDoom0 noDoom1
      Texture METAL6 noDoom0 noDoom1
      Texture METAL2 noDoom0 noDoom1
      Texture COMP2 noDoom2
      Texture SILVER2 noDoom0 noDoom1
      Texture SILVER1 noDoom0 noDoom1

      ; Load the hardwired monster and object and so on data (required in
      ; this version of SLIGE; don't remove this!)
      Hardwired1

      ; Say which lamps we like in which themes, and where barrels are allowed
      ; Information like which Doom version each object is in, and which ones
      ; cast light, and which ones explode, is still hardwired.
      Thing 2035 comp MIL  ; barrel
      Thing 34  comp MIL    ; candle
      ;Thing 44     ; tall blue torch
      ;Thing 45     ; tall green torch
      Thing 46 comp RED  ; tall red torch
      ;Thing 55 comp RED    ; short blue torch
      ;Thing 56 comp RED    ; short green torch
      Thing 57 comp RED  ; short red torch
      Thing 48 comp MIL             ; electric pillar
      Thing 2028 comp MIL
      Thing 85 comp MIL
      Thing 86 comp MIL
      Thing 70 comp MIL     ; flaming barrel
      ;Thing 35              ; candelabra

      ; and that's it!
    ]]
  },


  ndf_base =
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

      Theme MIL
      Theme RED secret


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

      ; MIL walls ; note that in MIL the walls all have explicit switches
      Texture BRONZE4 wall core MIL subtle BRONZE3 switch SW1TEK noDoom0 noDoom1
      Texture STARTAN1 wall core MIL subtle STARTAN2 switch SW1STRTN noDoom2
      Texture STARTAN3 wall core MIL subtle STARG3 switch SW1STRTN
      Texture STARTAN2 wall core MIL subtle STARBR2 switch SW1STRTN
      Texture STARG3 wall core MIL subtle STARGR1 switch SW1STRTN
      Texture STARG2 wall core MIL subtle STARG1 switch SW1STRTN
      Texture STARG1 wall core MIL subtle STARG2 switch SW1STRTN
      Texture BROWN96 wall core MIL subtle BROWNGRN switch SW1DIRT
      Texture TEKGREN2 wall core MIL subtle TEKGREN1 switch SW1TEK noDoom0 noDoom1
      Texture BROWN1 wall core MIL switch SW1BRN2
      Texture STONE wall core MIL subtle GRAY1 switch SW1GRAY
      Texture STONE6 wall comp MIL subtle STONE7 switch SW1STON6 noDoom0 noDoom1
      Texture BROWNGRN wall core MIL subtle BROWN96 switch SW1BRNGN
      Texture SLADWALL wall core MIL subtle BROWNGRN switch SW1SLAD
      Texture PIPEWAL2 wall comp MIL subtle PIPEWAL1 switch SW1COMP noDoom0 noDoom1
      Texture GRAYALT wall core MIL switch SW1GRAY noDoom0 noDoom1 custom
      Texture TEKVINE wall comp MIL subtle TEKWALL1 switch SW1TEK yhint 0 noDoom0 noDoom1 custom
      Texture SPACEW4 wall comp MIL switch SW1TEK noDoom0 noDoom1
      Texture METAL5 wall comp MIL subtle METAL3 switch SW1MET2 noDoom0 noDoom1
      Texture METAL2 switch SW1MET2 noDoom0 noDoom1
      Texture COMPUTE3 wall comp MIL switch SW1STRTN noDoom2
      Texture TEKWALL4 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture TEKWALL1 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture GRAY1 wall comp MIL subtle ICKWALL3 switch SW1GRAY
      Texture GRAY7 wall comp MIL subtle GRAY1 switch SW1GRAY1
      Texture ICKWALL3 wall comp MIL subtle ICKWALL7 switch SW2GRAY
      Texture BROVINE2 wall comp MIL switch SW1SLAD yhint 2
      Texture METAL1 wall comp MIL switch SW1METAL
      Texture STARBR2 wall comp MIL subtle STARTAN2 switch SW1STRTN


      ; And the lift texture
      Texture PLAT1 size 128 128 lift comp MIL


      ; RED walls
      Texture SP_HOT1 wall core RED
      Texture REDWALL wall core RED
      Texture FIREBLU1 wall core RED subtle FIREMAG1 yhint 0
      Texture SW1HOT isswitch comp RED
      ; a wall version of SKY3, just for fun.  You can comment this
      ; out if you think it looks ugly.
      Texture SKY3_W wall comp RED realname SKY3

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture TEKBRON2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR4 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR3 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR1 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture DOORHI size 64 128 door comp MIL noDoom2
      Texture DOOR3 size 64 72 door comp MIL 
      Texture DOOR1 size 64 72 door comp MIL 
      Texture WOODSKUL size 64 128 door comp RED noDoom2
      Texture WOODMET2 size 64 128 door comp RED noDoom0 noDoom1
      Texture WOODGARG size 64 128 door comp RED
      Texture BIGDOOR4 size 128 128 door comp MIL 
      Texture BIGDOOR3 size 128 128 door comp MIL 
      Texture BIGDOOR2 size 128 128 door comp MIL 
      Texture BIGDOOR1 size 128 96 door comp MIL
      Texture BIGDOOR7 size 128 128 door comp RED 
      Texture BIGDOOR6 size 128 112 door comp RED 
      Texture BIGDOOR5 size 128 128 door comp RED
      Texture METAL size 64 128 door comp RED
      ; Our two custom locked-door textures
      Texture DOORSKUL size 64 72 door locked comp MIL noDoom0 noDoom1 custom
      Texture SLDOOR1 size 64 128 door locked comp MIL realname SP_DUDE5 custom

      ; Exit switches, suitable for use on any level-ending switch.  All are
      ; custom, and Doom2-only.
      Texture EXITSWIR exitswitch comp RED noDoom0 noDoom1 custom
      Texture EXITSWIT exitswitch comp MIL noDoom0 noDoom1 custom

      ; Lights, suitable for lighting recesses and stuff.
      Texture BFALL1 size 8 128 light comp RED noDoom0 noDoom1
      Texture LITEREDL size 8 128 light comp RED realname LITERED noDoom2
      Texture TEKLITE light comp MIL noDoom0 noDoom1
      Texture LITE4 light comp MIL noDoom2
      Texture LITE5 light comp MIL
      Texture LITE3 light comp MIL

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
      Texture SILVER3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture SPACEW3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture COMPSTA2 plaque vtiles half_plaque comp MIL
      Texture COMPSTA1 plaque vtiles half_plaque comp MIL
      Texture COMP2 plaque vtiles half_plaque comp MIL
      Texture COMPTALL plaque vtiles comp MIL
      Texture COMPUTE1 plaque vtiles half_plaque comp MIL noDoom2
      Texture PLANET1 plaque vtiles half_plaque comp MIL noDoom2
      Texture SKIN2 plaque vtiles comp RED
      Texture GSTFONT1 plaque comp RED
      Texture FIREMAG1 plaque comp red
      ; Some people think these next two look silly;
      ; you can comment them out if you want to.
      ; Texture SKY1 plaque  
      ; Texture SKY3 plaque comp RED

      ; Gratings
      Texture BRNBIGC grating comp MIL noDoom2
      Texture MIDSPACE grating comp MIL noDoom0 noDoom1
      Texture MIDVINE1 grating comp MIL comp RED noDoom2
      Texture MIDBARS1 grating comp MIL comp RED  noDoom0 noDoom1
      Texture MIDGRATE grating comp MIL comp RED 

      ; Colors (suitable for marking key-locked things)
      Texture LITERED size 8 128 red comp MIL noDoom2
      Texture DOORRED size 8 128 red comp MIL 
      Texture DOORRED2 size 16 128 red  comp RED 
      Texture DOORYEL size 8 128 yellow comp MIL 
      Texture DOORYEL2 size 16 128 yellow comp RED 
      Texture LITEBLU4 size 16 128 blue comp MIL
      Texture LITEBLU1 size 8 128 blue comp MIL
      Texture DOORBLU size 8 128 blue comp MIL 
      Texture DOORBLU2 size 16 128 blue comp RED 

      ; Step kickplates
      Texture STEP6 size 256 16 step comp MIL 
      Texture STEP5 size 256 16 step comp MIL 
      Texture STEP4 size 256 16 step comp MIL
      Texture STEP3 size 256 8 step comp MIL 
      Texture STEP2 size 256 8 step comp MIL
      Texture STEP1 size 256 8 step comp MIL 

      ; "Doorjambs"
      Texture FIRELAVA jamb comp RED
      Texture DOORTRAK jamb comp MIL
      Texture DOORSTOP jamb comp MIL
      ; Texture PIPE2 jamb comp MIL   ; PIPE2 is also a wall texture

      ; Support textures, used in various places
      Texture SKSNAKE2 support comp RED
      Texture ROCKRED1 support comp RED
      Texture COMPSPAN support comp MIL 
      Texture SUPPORT2 support comp MIL 
      Texture SHAWN2 support comp MIL  
      Texture ASHWALL3 support  noDoom0 noDoom1
      Texture ASHWALL support  noDoom2
      Texture BROWNHUG support  comp MIL  
      Texture METAL support comp RED

      ; Bunch of things for outside patios (no themes applied here)
      Texture ZIMMER1 outside noDoom0 noDoom1
      Texture ZIMMER2 outside noDoom0 noDoom1
      Texture ZIMMER3 outside noDoom0 noDoom1
      Texture ZIMMER4 outside noDoom0 noDoom1
      Texture ZIMMER5 outside noDoom0 noDoom1
      Texture ZIMMER7 outside noDoom0 noDoom1
      Texture ZIMMER8 outside noDoom0 noDoom1
      Texture TANROCK5 outside noDoom0 noDoom1
      Texture TANROCK4 outside noDoom0 noDoom1
      Texture TANROCK2 outside noDoom0 noDoom1
      Texture STUCCO outside noDoom0 noDoom1
      Texture STONE6 outside noDoom0 noDoom1
      Texture ROCK1 outside noDoom0 noDoom1
      Texture MODWALL1 outside noDoom0 noDoom1
      Texture BSTONE1 outside noDoom0 noDoom1
      Texture BRICK4 outside noDoom0 noDoom1
      Texture ASHWALL7 outside noDoom0 noDoom1
      Texture ASHWALL6 outside noDoom0 noDoom1
      Texture ASHWALL4 outside noDoom0 noDoom1
      Texture ASHWALL2 outside noDoom0 noDoom1
      Texture SP_ROCK1 outside
      Texture GRAYVINE outside
      Texture ICKWALL3 outside
      Texture BROWN144 outside
      Texture GSTONE1 outside
      Texture GSTVINE1 outside
      Texture BRICK10 outside NoDoom0 NoDoom1
      Texture ASHWALL3 outside NoDoom0 NoDoom1
      Texture ASHWALL outside NoDoom2
      Texture BROWNHUG outside

      ; Misc
      Texture EXITSIGN gateexitsign
      Texture REDWALL error

      ; This silly texture has the switch in the wrong half!
      Texture SW1DIRT ybias 72
      Texture SW1MET2 ybias 64

      ; Now the flats.  Keywords should all be pretty obvious...   *8)

      ; Teleport-gate floors
      Flat SLGATE1 gate  comp MIL  comp RED custom
      Flat GATE4 gate comp MIL comp RED 
      Flat GATE3 gate comp MIL comp RED 
      Flat GATE2 gate comp MIL comp RED 
      Flat GATE1 gate comp MIL comp RED 

      ; Floors and ceilings for MIL theme
      Flat SLLITE1 ceiling light comp MIL custom
      Flat TLITE6_6 ceiling light comp MIL
      Flat TLITE6_5 ceiling light comp MIL
      Flat FLOOR7_1 ceiling outside comp MIL
      Flat FLOOR5_2 ceiling comp MIL
      Flat CEIL3_1 ceiling comp MIL
      Flat CEIL3_2 ceiling comp MIL
      Flat CEIL3_5 ceiling comp MIL
      Flat FLAT14 floor comp MIL
      Flat FLOOR4_1 floor comp MIL
      Flat FLOOR4_8 floor comp MIL
      Flat FLOOR5_1 floor comp MIL
      Flat FLOOR3_3 floor ceiling comp MIL 
      Flat FLOOR0_2 floor comp MIL
      Flat FLOOR0_1 floor comp MIL
      Flat FLAT1_2 floor outside comp MIL
      Flat FLAT5 floor comp MIL
      Flat SLIME14 floor comp MIL noDoom0 noDoom1
      Flat SLIME15 floor comp MIL noDoom0 noDoom1
      Flat SLIME16 floor comp MIL noDoom0 noDoom1
      ; and nukage
      Flat NUKAGE1 nukage comp MIL
      Flat SLIME01 nukage comp MIL noDoom0 noDoom1

      ; Floors and ceilings for (secret) RED theme
      Flat SLSPARKS floor comp RED custom
      Flat SFLR6_4 floor ceiling comp RED
      Flat TLITE6_5 ceiling light comp RED
      Flat FLOOR6_1 floor ceiling red comp RED
      Flat FLOOR1_7 ceiling light comp RED
      Flat FLOOR1_6 floor ceiling red comp RED
      Flat FLAT5_3 floor ceiling red comp RED
      Flat LAVA1 nukage comp RED
      Flat BLOOD1 nukage red comp RED
      Flat RROCK05 nukage comp RED noDoom0 noDoom1

      ; Floors for outside areas not yet mentioned
      Flat SLGRASS1 outside custom
      Flat SLIME13 outside noDoom0 noDoom1
      Flat RROCK19 outside noDoom0 noDoom1
      Flat RROCK16 outside noDoom0 noDoom1
      Flat RROCK11 outside noDoom0 noDoom1
      Flat GRNROCK outside noDoom0 noDoom1
      Flat GRASS2 outside noDoom0 noDoom1
      Flat GRASS1 outside noDoom0 noDoom1
      Flat MFLR8_4 outside
      Flat MFLR8_3 outside
      Flat MFLR8_2 outside
      Flat FLAT5_7 outside
      Flat FLAT10 outside

      ; These are the defaults, but we'll list them anyway.
      Flat FWATER1 water
      Flat F_SKY1 sky

      ; Constructs: computers and crates and stuff that stand around in rooms
      ; This is pretty complex!  Fool with it at your peril.

      ; Family 1 is silver-colored computers; short ones and tall ones
      Construct family 1 height 64 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary COMPUTE1 yoffsets 0 64
        Primary COMPSTA2
        Primary COMPSTA1
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16
      Construct family 1 height 128 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary SILVER3
        Primary COMPUTE1 yoffsets 0 64
        Secondary SILVER2 width 64
        Secondary SILVER1 width 64
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16

      ; Family 2 is dark-colored computers; short and tall
      Construct family 2 height 64 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 yoffsets 0 64 width 64
        Primary COMPTALL yoffsets 0 64 width 256
        Primary COMP2 yoffsets 0 64 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16
      Construct family 2 height 128 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 width 64
        Primary COMPTALL width 256
        Primary COMP2 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16

      ; Family 3 is crates of various sizes and kinds
      Construct family 3 height 64  comp MIL 
        top CRATOP2
        Primary CRATWIDE yoffsets 64 64
        Primary CRATE1 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATWIDE
        Primary CRATE2 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 32  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 16  comp MIL 
        top CRATOP1
        Primary CRATINY width 16

      ; And Family 4 is bookcases; works only in Doom2
      Construct family 4 height 128 noDoom0 noDoom1
        top FLAT5_1 top CRATOP2 top CEIL5_2 top CEIL3_3 top CEIL1_1
        Secondary PANEL5 width 64
        Secondary PANCASE2 width 64
        Secondary PANCASE1 width 64
        Secondary PANBORD2 width 16
        Secondary PANBORD1 width 32
        Primary PANBOOK width 64

      ; Mask-adjustments for the construct textures that need it
      Texture PANEL5 noDoom0 noDoom1
      Texture PANCASE2 noDoom0 noDoom1
      Texture PANCASE1 noDoom0 noDoom1
      Texture PANBORD2 noDoom0 noDoom1
      Texture PANBORD1 noDoom0 noDoom1
      Texture METAL7 noDoom0 noDoom1
      Texture METAL6 noDoom0 noDoom1
      Texture METAL2 noDoom0 noDoom1
      Texture COMP2 noDoom2
      Texture SILVER2 noDoom0 noDoom1
      Texture SILVER1 noDoom0 noDoom1

      ; Load the hardwired monster and object and so on data (required in
      ; this version of SLIGE; don't remove this!)
      Hardwired1

      ; Say which lamps we like in which themes, and where barrels are allowed
      ; Information like which Doom version each object is in, and which ones
      ; cast light, and which ones explode, is still hardwired.
      Thing 2035 comp MIL  ; barrel
      Thing 34  comp MIL    ; candle
      ;Thing 44     ; tall blue torch
      ;Thing 45     ; tall green torch
      Thing 46 comp RED  ; tall red torch
      ;Thing 55 comp RED    ; short blue torch
      ;Thing 56 comp RED    ; short green torch
      Thing 57 comp RED  ; short red torch
      Thing 48 comp MIL             ; electric pillar
      Thing 2028 comp MIL
      Thing 85 comp MIL
      Thing 86 comp MIL
      Thing 70 comp MIL     ; flaming barrel
      ;Thing 35              ; candelabra

      ; and that's it!
    ]]
  },

}

function HARMONY.slump_setup()
  if ob_match_game({game = {harmony=1}}) then
    if OB_CONFIG.theme == "default" then
      PARAM.slump_config = HARMONY.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" then
      local possible_configs = {}
      for _,tab in pairs(HARMONY.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif HARMONY.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = HARMONY.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = HARMONY.THEMES.DEFAULTS.slump_config
    end
  end
end

------------------------------------------------------------------------


OB_THEMES["ndf_base"] =
{
  label = _("NDF Base"),
  game = "harmony",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

