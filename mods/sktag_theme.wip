----------------------------------------------------------------
--  MODULE: Skulltag Themes
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2009 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

SKULLTAG_MATERIALS =
{
  -- textures

  N_SUBV01 = { t="N_SUBV01", f="FLOOR0_2" },
  N_SUBV02 = { t="N_SUBV02", f="FLOOR0_2" },
  N_SUBV03 = { t="N_SUBV03", f="FLAT1" },
  N_SUBV04 = { t="N_SUBV04", f="FLAT1" },
  N_SUBV05 = { t="N_SUBV05", f="FLAT3" },
  N_SUBV06 = { t="N_SUBV06", f="FLAT3" },
  N_SUBV07 = { t="N_SUBV07", f="FLOOR4_1" },
  N_SUBV08 = { t="N_SUBV08", f="FLOOR4_1" },

  -- flats

  FAN1     = { t="METAL",   f="FAN1" },
  NFMTSQ03 = { t="BROWN96", f="NFMTSQ03" },
  TLITE6_7 = { t="METAL",   f="TLITE6_7" },
}


SKULLTAG_THEMES = 
{
  TECH1 =
  {
    building =
    {
      walls =
      {
        N_SUBV01=3, N_SUBV02=1, N_SUBV03=9, N_SUBV04=3,
        N_SUBV05=9, N_SUBV06=3, N_SUBV07=3, N_SUBV08=1,
      },

      floors =
      {
        NFMTSQ03=50,
      },
    },

    ceil_lights =
    {
      TLITE6_7=20,
      FAN1=60, -- not really a light
    },
  },
}


function SkulltagTheme_setup(self)
  -- TODO
end


OB_MODULES["sktag_theme"] =
{
  label = "Skulltag : Flats and Textures",

  for_games = { doom1=1, doom2=1 },
  for_engines = { skulltag=1 },

  setup_func = SkulltagTheme_setup,

  tables =
  {
    "materials", SKULLTAG_MATERIALS,
    "themes",    SKULLTAG_THEMES,
  },
}

