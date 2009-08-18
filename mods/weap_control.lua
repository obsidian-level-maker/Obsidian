----------------------------------------------------------------
--  MODULE: Weapon Control
----------------------------------------------------------------
--
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

WEAP_CONTROL_CHOICES =
{
--  "none",   "NONE",
  "normal", "Normal",
  "scarce", "Scarce",
  "less",   "Less",
  "more",   "More",
  "heaps",  "Heaps",
  "loveit", "I LOVE IT",
}

WEAP_CONTROL_AMOUNTS =
{
--  none =   0,
  scarce = 1,
  less   = 15,
  normal = 50,
  more   = 120,
  heaps  = 300,
  loveit = 1000,
}


function WeapControl_setup(self)

  for name,opt in pairs(self.options) do
    local W = GAME.weapons[name]
    local factor = WEAP_CONTROL_AMOUNTS[opt.value]

    if W and factor then
      W.start_prob = factor
      W.add_prob   = factor

      -- adjust usage preference as well
      if W.pref and factor > 0 then
        W.pref = W.pref * ((factor / 50) ^ 0.6)
      end
    end
  end -- for opt

end


OB_MODULES["weap_control"] =
{
  label = "Weapon Control (DOOM)",

  for_games = { doom1=1, doom2=1, freedoom=1 },
  for_modes = { sp=1, coop=1 },

  setup_func = WeapControl_setup,

  options =
  {
    berserk  = { label="Berserk",          choices=WEAP_CONTROL_CHOICES },
    saw      = { label="Saw",              choices=WEAP_CONTROL_CHOICES },
    shotty   = { label="Shotgun",          choices=WEAP_CONTROL_CHOICES },
    super    = { label="Super Shotty",     choices=WEAP_CONTROL_CHOICES },
    chain    = { label="Chaingun",         choices=WEAP_CONTROL_CHOICES },
    launch   = { label="Rocket Launcher",  choices=WEAP_CONTROL_CHOICES },
    plasma   = { label="Plasma Rifle",     choices=WEAP_CONTROL_CHOICES },
    bfg      = { label="B.F.G",            choices=WEAP_CONTROL_CHOICES },
  },
}

