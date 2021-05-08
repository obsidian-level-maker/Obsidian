------------------------------------------------------------------------
--  MODULE: Procedural Gotcha Fine Tune
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2021 MsrSgtShooterPerson
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

PROCEDURAL_GOTCHA_FINE_TUNE = {}

PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_MAP_SIZES =
{
  "large", _("Large"),
  "regular", _("Regular"),
  "small", _("Small"),
  "tiny", _("Tiny")
}

function PROCEDURAL_GOTCHA_FINE_TUNE.setup(self)
  for name,opt in pairs(self.options) do
    if opt.valuator then
      if opt.valuator == "button" then
        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
      elseif opt.valuator == "slider" then
        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
      end
    else
      PARAM[name] = self.options[name].value
    end
  end
end

OB_MODULES["procedural_gotcha"] =
{

  name = "procedural_gotcha",

  label = _("Procedural Gotcha Options"),

  engine = "!vanilla",
  side = "right",
  priority = 92,

  hooks =
  {
    setup = PROCEDURAL_GOTCHA_FINE_TUNE.setup
  },

  tooltip=_(
    "This module allows you to fine tune the Procedural Gotcha experience if you have Procedural Gotchas enabled. Does not affect prebuilts. It is recommended to pick higher scales on one of the two options, but not both at once for a balanced challenge."),

  options =
  {
    float_gotcha_qty =
    {
      name="float_gotcha_qty",
      label=_("Extra Quantity"),
      valuator = "slider",
      units = "x Monsters",
      min = 0.2,
      max = 10,
      increment = 0.1,
      default = 1.2,
      nan = "1:No Change,",
      tooltip = "Offset monster strength from your default quantity of choice plus the increasing level ramp. If your quantity choice is to reduce the monsters, the monster quantity will cap at a minimum of 0.1 (Scarce quantity setting).",
    },

    float_gotcha_strength =
    {
      name="float_gotcha_strength",
      label=_("Extra Strength"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 16,
      increment = 1,
      default = 4,
      nan = "0:NONE," ..
      "2:2 (Stronger)," ..
      "4:4 (Harder)," ..
      "6:6 (Tougher)," ..
      "8:8 (CRAZIER)," ..
      "16:16 (NIGHTMARISH),",
      tooltip = "Offset monster quantity from your default strength of choice plus the increasing level ramp.",
    },

    gotcha_map_size =
    {
      name="gotcha_map_size",
      label=_("Map Size"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_MAP_SIZES,
      default = "small",
      tooltip = "Size of the procedural gotcha. Start and arena room sizes are relative to map size as well.",
    },

    bool_gotcha_boss_fight =
    {
      name = "bool_gotcha_boss_fight",
      label=_("Force Boss Fight"),
      valuator = "button",
      default = 1,
      tooltip = "EXPERIMENTAL: Forces procedural gotchas to have guaranteed boss fights.",
    },
  },
}
