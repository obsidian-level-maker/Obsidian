------------------------------------------------------------------------
--  MODULE: Procedural Texture Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

-- WARNING: This is not finished yet. If you are interested in adding
-- patch definitions below, don't - the system is still likely to change.

PROC_TEX = { }

PROC_TEX.TEXTURE_SCOPE_CHOICES =
{
  "vanilla", _("Vanilla Only"),
  "epic", _("Include Epic Textures"),
}

PROC_TEX.BLENDING_OPTIONS =
{
  "Translucent",
  "Add",
  "Subtract",
}

PROC_TEX.GRAPHICS =
{
  -- Base textures are textures with no inherent
  -- detail whatsoever - as in they qualify as just
  -- colored noise. This will be used as a basis for
  -- recolors and mixtures with more detailed textures.
  BASE =
  {
    -- flats
    CEIL4_2 = { c = "blue", d = { 64,64 } },
    CEIL4_3 = { c = "blue", d = { 64,64 } },
    CEIL5_1 = { c = "black", d = { 64,64 } },
    CEIL5_2 = { c = "brown", d = { 64,64 } },
    CRATOP1 = { c = "gray", d = { 64,64 } },
    CRATOP2 = { c = "brown", d = { 64,64 } },

    FLAT1 = { c = "gray", d = { 64,64 } },
    FLAT14 = { c = "blue", d = { 64,64 } },
    FLAT19 = { c = "gray", d = { 64,64 } },
    FLAT23 = { c = "gray", d = { 64,64 } },

    FLAT5_3 = { c = "red", d = { 64,64 } },
    FLAT5_4 = { c = "gray", d = { 64,64 } },
    FLAT5_5 = { c = "brown", d = { 64,64 } },

    FLOOR1_6 = { c = "red", d = { 64,64 } },
    FLOOR3_3 = { c = "brown", d = { 64,64 } },
    FLOOR6_1 = { c = "red", d = { 64,64 } },
    FLOOR6_2 = { c = "gray", d = { 64,64 } },
    FLOOR7_1 = { c = "brown", d = { 64,64 } },
    FLOOR7_2 = { c = "green", d = { 64,64 } },

    GRASS1 = { c = "green", d = { 64,64 } },
    GRASS2 = { c = "green", d = { 64,64 } },
    RROCK03 = { c = "brown", d = { 64,64 } },
    RROCK20 = { c = "green", d = { 64,64 } },

    -- walls
    ASHWALL2 = { c = "black", d = { 64,128 } },
    ASHWALL3 = { c = "brown", d = { 64,128 } },
    ASHWALL4 = { c = "brown", d = { 64,128 } },
    ASHWALL6 = { c = "green", d = { 64,128 } },
    ASHWALL7 = { c = "brown", d = { 64,128 } },
    BROWN144 = { c = "brown", d = { 128,128 } },
    BROWNHUG = { c = "brown", d = { 64,128 } },
    COMPBLUE = { c = "blue", d = { 64,128 } },
    GRAYBIG = { c = "gray", d = { 128,128 } },
    REDWALL = { c = "red", d = { 128,128 } },
    SHAWN2 = { c = "gray", d = { 64,128 } },
    SKIN2 = { c = "red", d = { 128,128 } },
    STUCCO = { c = "brown", d = { 64,128 } },
    TANROCK2 = { c = "brown", d = { 64,128 } },
    TANROCK3 = { c = "brown", d = { 64,128 } },
    TANROCK4 = { c = "brown", d = { 64,128 } },
    TANROCK5 = { c = "brown", d = { 64,128 } },
    TANROCK7 = { c = "brown", d = { 64,128 } },
    TANROCK8 = { c = "brown", d = { 64,128 } },
    ZIMMER1 = { c = "green", d = { 64,128 } },
    ZIMMER2 = { c = "green", d = { 64,128 } },
    ZIMMER3 = { c = "brown", d = { 64,128 } },
    ZIMMER4 = { c = "brown", d = { 64,128 } },
    ZIMMER7 = { c = "green", d = { 64,128 } },
    ZIMMER8 = { c = "gray", d = { 64,128 } },
  },

  -- Accents are textures with detail already existing over them
  ACCENTS =
  {
    TILES =
    {
      -- flats
      CEIL1_1 = { d = { 64,64 } },
      CEIL3_1 = { d = { 64,64 } },
      CEIL3_2 = { d = { 64,64 } },
      CEIL3_3 = { d = { 64,64 } },
      COMP01 = { d = { 64,64 } },
      DEM1_6 = { d = { 64,64 } },
      FLAT18 = { d = { 64,64 } },
      FLAT20 = { d = { 64,64 } },
      FLAT3 = { d = { 64,64 } },
      FLAT4 = { d = { 64,64 } },
      FLAT5 = { d = { 64,64 } },
      FLAT5_1 = { d = { 64,64 } },
      FLAT5_2 = { d = { 64,64 } },
      FLOOR3_3 = { d = { 64,64 } },
      FLOOR4_6 = { d = { 64,64 } },

      -- walls
      CEMENT7 = { d = { 64,128 } },
      CEMENT9 = { d = { 64,128 } },
    },

    BRICK =
    {
      -- flats
      CEIL3_5 = { d = { 64,64 } },
      FLAT8 = { d = { 64,64 } },
      FLOOR5_4 = { d = { 64,64 } },
      MFLR8_1 = { d = { 64,64 } },
      RROCK10 = { d = { 64,64 } },
      RROCK14 = { d = { 64,64 } },
      RROCK15 = { d = { 64,64 } },
      SLIME13 = { d = { 64,64 } },

      -- walls
      BIGBRIK1 = { d = { 64,128 } },
      BIGBRIK2 = { d = { 64,128 } },
      BIGDOOR5 = { d = { 128,128 } },
      BRICK1 = { d = { 64,128 } },
      BRICK10 = { d = { 64,128 } },
      BRICK11 = { d = { 64,128 } },
      BRICK12 = { d = { 64,128 } },
      BRICK3 = { d = { 64,128 } },
      GRAY1 = { d = { 64,128 } },
      GRAY4 = { d = { 64,128 } },
      GRAY5 = { d = { 64,128 } },
      GRAY7 = { d = { 256,128 } },
    },

    CRACKS =
    {
      -- flats
      FLAT1_1 = { d = { 64,64 } },
      FLAT1_2 = { d = { 64,64 } },
      FLAT5_7 = { d = { 64,64 } },
      FLAT5_8 = { d = { 64,64 } },
      GRNROCK = { d = { 64,64 } },
      RROCK04 = { d = { 64,64 } },
      RROCK11 = { d = { 64,64 } },
      RROCK12 = { d = { 64,64 } },
      RROCK13 = { d = { 64,64 } },

      -- walls
      BSTONE1 = { d = { 64,128 } },
      BSTONE2 = { d = { 64,128 } },
    },

    PANELS =
    {
      -- flats
      FLAT9 = { d = { 64,64 } },
      FLOOR0_1 = { d = { 64,64 } },
      FLOOR0_5 = { d = { 64,64 } },
      FLOOR4_1 = { d = { 64,64 } },
      FLOOR4_5 = { d = { 64,64 } },
      FLOOR4_8 = { d = { 64,64 } },
      FLOOR5_3 = { d = { 64,64 } },
      SLIME14 = { d = { 64,64 } },
      SLIME15 = { d = { 64,64 } },
      SLIME16 = { d = { 64,64 } },
      STEP1 = { d = { 64,64 } },
      STEP2 = { d = { 64,64 } },

      -- walls
      BRONZE1 = { d = { 64,128 } },
      BRONZE2 = { d = { 64,128 } },
      BRONZE3 = { d = { 64,128 } },
      BROWN1 = { d = { 128,128 } },
      BROWN96 = { d = { 128,128 } },
      BROWNGRN = { d = { 64,128 } },
      BROWNPIP = { d = { 128,128 } },
      COMPSPAN = { d = { 32,128 } },
      DOOR1 = { d = { 64,72 } },
      GRAYTALL = { d = { 128,128 } },
    },

    WEIRD =
    {
      -- flats
      RROCK19 = { d = { 64,64 } },
      SFLR6_1 = { d = { 64,64 } },

      -- walls
      BRICK4 = { d = { 64,128 } },
    },
  },

  -- Textures that can be added directly over the initial mixture
  -- {i.e. using SUPPORT3 to border the sides},
  FRAMES =
  {

  },
}

function PROC_TEX.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end
end

function generate_textures()
  function generate_hex_color()
  end
end

----------------------------------------------------------------

--[[OB_MODULES["proc_tex"] =
{
  label = _("Procedural Textures")

  side = "left",
  priority = 69.5,

  game = "doomish",

  hooks =
  {
    setup = PROC_TEX.setup
    get_levels = PROC_TEX.generate_textures
  },

  options =
  {
    texture_scope =
    {
      label = _("Scope")
      choices = PROC_TEX.TEXTURE_SCOPE_CHOICES
      tooltip = "That one guy",
      default = "vanilla",
    },
  },
}]]
