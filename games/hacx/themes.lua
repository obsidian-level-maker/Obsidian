------------------------------------------------------------------------
--  HACX THEMES
------------------------------------------------------------------------

HACX.THEMES =
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

	  Theme PRS ; Prison theme
	  Theme OTA ; Digi-Ota theme

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

	  ; Prison walls
	  Texture MIDSPACE size 128 128 wall core PRS
	  Texture METAL6 size 128 128 wall core PRS subtle METAL5
	  Texture MIDBARS1 size 128 128 wall core PRS subtle METAL7
	  
	  ; Prison switches
	  Texture SW1STARG size 128 128 isswitch comp PRS comp OTA
	  Texture SW1BRNGN size 128 128 isswitch comp PRS comp OTA
	  
	  ; Digi-Ota walls
	  Texture HW165 size 128 128 wall core OTA
	  Texture STUCCO2 size 128 128 wall core OTA
	  Texture TANROCK2 size 128 128 wall core OTA

	  ; And the lift texture
	  Texture BIGDOOR1 size 128 128 lift comp PRS comp OTA

	  ; Doors of all kinds.  "size" gives the width and height of the texture,
	  ; and "locked" means that it's a good texture to use on a door that only
	  ; opens with a switch, not a touch.
	  Texture BIGDOOR4 size 128 128 door comp PRS comp OTA

	  ; Prison exit switches
	  Texture DOORRED size 128 128 exitswitch comp PRS comp OTA

	  ; Lights, suitable for lighting recesses and stuff.
	  Texture HW208 size 8 64 light comp PRS comp OTA
	  Texture HW215 size 64 8 light comp PRS comp OTA
	  Texture HW221 size 8 32 light comp PRS comp OTA

	  ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
	  ; "vtiles" means that it's OK to pile one on top of another, as when
	  ;    making the big central pillar in an arena.
	  ; "half_plaque" means that the upper half of this texture can be used
	  ;    by itself, as well as the whole thing.
	  Texture SPCDOOR1 size 128 128 plaque comp PRS
	  Texture STUCCO size 128 128 plaque vtiles comp OTA
	  Texture STUCCO1 size 128 128 plaque vtiles comp OTA
	  Texture STUCCO3 size 128 128 plaque comp OTA

	  ; Gratings
	  Texture SPACEW3 size 128 128 grating comp PRS
	  Texture HW203 size 128 128 grating comp PRS comp OTA
	  Texture TEKGREN2 size 128 128 grating comp OTA

	  ; Colors (suitable for marking key-locked things)
	  Texture HW510 size 8 128 red comp PRS comp OTA
	  Texture HW511 size 8 128 yellow comp PRS comp OTA
	  Texture HW512 size 8 128 blue comp PRS comp OTA

	  ; Step kickplates
	  Texture HW216 size 64 8 step comp PRS comp OTA

	  ; "Doorjambs"
	  Texture HW513 size 16 128 jamb comp PRS comp OTA

	  ; Support textures, used in various places
	  Texture BIGBRIK3 size 128 128 support comp PRS comp OTA

	  ; Bunch of things for outside patios (no themes applied here)
	  Texture PANEL2 size 128 128 outside
	  Texture PANEL3 size 128 128 outside

	  ; Misc
	  Texture BROWNGRN size 128 128 error

	  ; Now the flats.  Keywords should all be pretty obvious...   *8)

	  ; Teleport-gate floors
	  Flat BLOOD1 gate comp PRS comp OTA

	  ; Prison floors and ceilings
	  Flat FLOOR0_1 floor comp PRS
	  Flat CEIL3_2 ceiling comp PRS
	  Flat CEIL4_3 ceiling comp PRS
	  Flat SFLR6_1 ceiling light comp PRS
	  Flat SFLR6_4 ceiling light comp PRS
	  Flat TLITE6_5 floor comp PRS
	  Flat DEM1_3 floor comp PRS
	  Flat FLOOR6_1 ceiling comp PRS

	  ; Digi-Ota floors and ceilings
	  Flat FLOOR5_2 floor comp OTA
	  Flat FLOOR0_5 floor comp OTA
	  Flat FLAT5_2 floor comp OTA
	  Flat MFLR8_2 ceiling comp OTA
	  Flat MFLR8_3 ceiling comp OTA
	  Flat FLAT5_3 ceiling comp OTA

	  ; and nukage
	  Flat SLIME01 nukage comp PRS comp OTA
	  Flat SLIME09 nukage comp PRS comp OTA
	  Flat LAVA1 nukage red comp PRS comp OTA

	  ; Floors for outside areas not yet mentioned
	  Flat CONS1_7 outside
	  Flat FLAT23 outside

	  ; These are the defaults, but we'll list them anyway.
	  Flat FWATER1 water
	  Flat F_SKY1 sky

	  ; Constructs: computers and crates and stuff that stand around in rooms
	  ; This is pretty complex!  Fool with it at your peril.

	  ; Family 1 is crates of various sizes and kinds
	  Construct family 1 height 128 comp PRS comp OTA
	  top FLOOR0_2
	  Primary BRICK10 width 128

	  ; Load the hardwired monster and object and so on data (required in
	  ; this version of SLIGE; don't remove this!)
	  Hardwired1

	  ; Say which lamps we like in which themes, and where barrels are allowed
	  ; Information like which Doom version each object is in, and which ones
	  ; cast light, and which ones explode, is still hardwired.
	  Thing 2028 comp PRS comp OTA ; floor lamp

    ; and that's it!
    ]]
  },

  prison =
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

	  Theme PRS ; Prison theme

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

	  ; Prison walls
	  Texture MIDSPACE size 128 128 wall core PRS
	  Texture METAL6 size 128 128 wall core PRS subtle METAL5
	  Texture MIDBARS1 size 128 128 wall core PRS subtle METAL7
	  
	  ; Prison switches
	  Texture SW1STARG size 128 128 isswitch comp PRS
	  Texture SW1BRNGN size 128 128 isswitch comp PRS
	  
	  ; And the lift texture
	  Texture BIGDOOR1 size 128 128 lift comp PRS

	  ; Doors of all kinds.  "size" gives the width and height of the texture,
	  ; and "locked" means that it's a good texture to use on a door that only
	  ; opens with a switch, not a touch.
	  Texture BIGDOOR4 size 128 128 door comp PRS

	  ; Prison exit switches
	  Texture DOORRED size 128 128 exitswitch comp PRS

	  ; Lights, suitable for lighting recesses and stuff.
	  Texture HW208 size 8 64 light comp PRS
	  Texture HW215 size 64 8 light comp PRS
	  Texture HW221 size 8 32 light comp PRS

	  ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
	  ; "vtiles" means that it's OK to pile one on top of another, as when
	  ;    making the big central pillar in an arena.
	  ; "half_plaque" means that the upper half of this texture can be used
	  ;    by itself, as well as the whole thing.
	  Texture SPCDOOR1 size 128 128 plaque comp PRS

	  ; Gratings
	  Texture SPACEW3 size 128 128 grating comp PRS
	  Texture HW203 size 128 128 grating comp PRS

	  ; Colors (suitable for marking key-locked things)
	  Texture HW510 size 8 128 red comp PRS
	  Texture HW511 size 8 128 yellow comp PRS
	  Texture HW512 size 8 128 blue comp PRS

	  ; Step kickplates
	  Texture HW216 size 64 8 step comp PRS

	  ; "Doorjambs"
	  Texture HW513 size 16 128 jamb comp PRS

	  ; Support textures, used in various places
	  Texture BIGBRIK3 size 128 128 support comp PRS

	  ; Bunch of things for outside patios (no themes applied here)
	  Texture PANEL2 size 128 128 outside
	  Texture PANEL3 size 128 128 outside

	  ; Misc
	  Texture BROWNGRN size 128 128 error

	  ; Now the flats.  Keywords should all be pretty obvious...   *8)

	  ; Teleport-gate floors
	  Flat BLOOD1 gate comp PRS

	  ; Prison floors and ceilings
	  Flat FLOOR0_1 floor comp PRS
	  Flat CEIL3_2 ceiling comp PRS
	  Flat CEIL4_3 ceiling comp PRS
	  Flat SFLR6_1 ceiling light comp PRS
	  Flat SFLR6_4 ceiling light comp PRS
	  Flat TLITE6_5 floor comp PRS
	  Flat DEM1_3 floor comp PRS
	  Flat FLOOR6_1 ceiling comp PRS

	  ; and nukage
	  Flat SLIME01 nukage comp PRS
	  Flat SLIME09 nukage comp PRS
	  Flat LAVA1 nukage red comp PRS

	  ; Floors for outside areas not yet mentioned
	  Flat CONS1_7 outside
	  Flat FLAT23 outside

	  ; These are the defaults, but we'll list them anyway.
	  Flat FWATER1 water
	  Flat F_SKY1 sky

	  ; Constructs: computers and crates and stuff that stand around in rooms
	  ; This is pretty complex!  Fool with it at your peril.

	  ; Family 1 is crates of various sizes and kinds
	  Construct family 1 height 128 comp PRS
	  top FLOOR0_2
	  Primary BRICK10 width 128

	  ; Load the hardwired monster and object and so on data (required in
	  ; this version of SLIGE; don't remove this!)
	  Hardwired1

	  ; Say which lamps we like in which themes, and where barrels are allowed
	  ; Information like which Doom version each object is in, and which ones
	  ; cast light, and which ones explode, is still hardwired.
	  Thing 2028 comp PRS ; floor lamp

    ; and that's it!
    ]]

  },

  digi_ota =
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

	  Theme OTA ; Digi-Ota theme

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

  
	  ; Digi-Ota switches
	  Texture SW1STARG size 128 128 isswitch comp OTA
	  Texture SW1BRNGN size 128 128 isswitch comp OTA
	  
	  ; Digi-Ota walls
	  Texture HW165 size 128 128 wall core OTA
	  Texture STUCCO2 size 128 128 wall core OTA
	  Texture TANROCK2 size 128 128 wall core OTA

	  ; And the lift texture
	  Texture BIGDOOR1 size 128 128 lift comp OTA

	  ; Doors of all kinds.  "size" gives the width and height of the texture,
	  ; and "locked" means that it's a good texture to use on a door that only
	  ; opens with a switch, not a touch.
	  Texture BIGDOOR4 size 128 128 door comp OTA

	  ; Prison exit switches
	  Texture DOORRED size 128 128 exitswitch comp OTA

	  ; Lights, suitable for lighting recesses and stuff.
	  Texture HW208 size 8 64 light comp OTA
	  Texture HW215 size 64 8 light comp OTA
	  Texture HW221 size 8 32 light comp OTA

	  ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
	  ; "vtiles" means that it's OK to pile one on top of another, as when
	  ;    making the big central pillar in an arena.
	  ; "half_plaque" means that the upper half of this texture can be used
	  ;    by itself, as well as the whole thing.
	  Texture STUCCO size 128 128 plaque vtiles comp OTA
	  Texture STUCCO1 size 128 128 plaque vtiles comp OTA
	  Texture STUCCO3 size 128 128 plaque comp OTA

	  ; Gratings
	  Texture HW203 size 128 128 grating comp OTA
	  Texture TEKGREN2 size 128 128 grating comp OTA

	  ; Colors (suitable for marking key-locked things)
	  Texture HW510 size 8 128 red comp OTA
	  Texture HW511 size 8 128 yellow comp OTA
	  Texture HW512 size 8 128 blue comp OTA

	  ; Step kickplates
	  Texture HW216 size 64 8 step comp OTA

	  ; "Doorjambs"
	  Texture HW513 size 16 128 jamb comp OTA

	  ; Support textures, used in various places
	  Texture BIGBRIK3 size 128 128 support comp OTA

	  ; Bunch of things for outside patios (no themes applied here)
	  Texture PANEL2 size 128 128 outside
	  Texture PANEL3 size 128 128 outside

	  ; Misc
	  Texture BROWNGRN size 128 128 error

	  ; Now the flats.  Keywords should all be pretty obvious...   *8)

	  ; Teleport-gate floors
	  Flat BLOOD1 gate comp OTA

	  ; Digi-Ota floors and ceilings
	  Flat FLOOR5_2 floor comp OTA
	  Flat FLOOR0_5 floor comp OTA
	  Flat FLAT5_2 floor comp OTA
	  Flat MFLR8_2 ceiling comp OTA
	  Flat MFLR8_3 ceiling comp OTA
	  Flat FLAT5_3 ceiling comp OTA

	  ; and nukage
	  Flat SLIME01 nukage comp OTA
	  Flat SLIME09 nukage comp OTA
	  Flat LAVA1 nukage red comp OTA

	  ; Floors for outside areas not yet mentioned
	  Flat CONS1_7 outside
	  Flat FLAT23 outside

	  ; These are the defaults, but we'll list them anyway.
	  Flat FWATER1 water
	  Flat F_SKY1 sky

	  ; Constructs: computers and crates and stuff that stand around in rooms
	  ; This is pretty complex!  Fool with it at your peril.

	  ; Family 1 is crates of various sizes and kinds
	  Construct family 1 height 128 comp OTA
	  top FLOOR0_2
	  Primary BRICK10 width 128

	  ; Load the hardwired monster and object and so on data (required in
	  ; this version of SLIGE; don't remove this!)
	  Hardwired1

	  ; Say which lamps we like in which themes, and where barrels are allowed
	  ; Information like which Doom version each object is in, and which ones
	  ; cast light, and which ones explode, is still hardwired.
	  Thing 2028 comp OTA ; floor lamp

    ; and that's it!
    ]]

  }

}

function HACX.slump_setup()
  if ob_match_game({game = {hacx=1}}) then
    if OB_CONFIG.theme == "default" then
      PARAM.slump_config = HACX.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" then
      local possible_configs = {}
      for _,tab in pairs(HACX.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif HACX.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = HACX.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = HACX.THEMES.DEFAULTS.slump_config
    end
  end
end

------------------------------------------------------------------------

OB_THEMES["prison"] =
{
  label = _("Prison"),
  game = "hacx",
  name_class = "PRISON",
  mixed_prob = 50
}

OB_THEMES["digi_ota"] =
{
  label = _("Digi-Ota"),
  game = "hacx",
  name_class = "DIGI_OTA",
  mixed_prob = 50
}