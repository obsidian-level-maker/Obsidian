------------------------------------------------------------------------
--  MODULE: Otex Support
------------------------------------------------------------------------
--
--  Copyright (C) ukiro
--  Copyright (C) 2021 MsrSgtShooterPerson
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
-------------------------------------------------------------------

OTEX_TEXTURES = { }

OTEX_TEXTURES.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No"),
}

OTEX_TEXTURES.MATERIALS =
{
  -- bunker

  -- walls
  OBNKRA01 = {t = "OBNRKA01", f = "0BNKRE00"},
  OBNKRA20 = {t = "OBNRKA20", f = "0BNKRE00"},
  OBNKRA30 = {t = "OBNRKA30", f = "0BNKRE00"},
  OBNKRA33 = {t = "OBNRKA33", f = "0BNKRE33"},
  OBNKRA39 = {t = "OBNRKA39", f = "0BNKRE33"},
  OBNKRA40 = {t = "OBNRKA40", f = "0BNKRE00"},
  OBNKRA49 = {t = "OBNRKA49", f = "0BNKRE33"}

  -- flats
}

OTEX_TEXTURES.ROOM_THEMES =
{
  any_bunker =
  {
    env = "building",

    prob = 50,
  }
}

function OTEX_TEXTURES.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  OTEX_TEXTURES.merge_materials()
  PARAM.epic_textures_activated = true
end

function OTEX_TEXTURES.merge_materials()
end

----------------------------------------------------------------

--[[OB_MODULES["OTEX_textures"] =
{
  label = _("ZDoom: OTEX Texture Pack"),

  side = "left",
  priority = 69,

  engine = { zdoom=1, gzdoom=1},

  game = "doomish",

  hooks =
  {
    setup = OTEX_TEXTURES.setup,
  },

  tooltip = "If enabled, adds textures from ukiro's OTEX texture pack.",
}]]
