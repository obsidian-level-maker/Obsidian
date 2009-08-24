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
  "default", "DEFAULT",
  "none",    "None at all",
  "scarce",  "Scarce",
  "less",    "Less",
  "plenty",  "Plenty",
  "more",    "More",
  "heaps",   "Heaps",
  "loveit",  "I LOVE IT",
}

WEAP_CONTROL_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  loveit = 1000,
}


function Weap_Control_Setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.weapons[name]

    if W and opt.value ~= "default" then
      local prob = WEAP_CONTROL_PROBS[opt.value]

      W.start_prob = prob
      W.add_prob   = prob

      -- adjust usage preference as well
      if W.pref and prob > 0 then
        W.pref = W.pref * ((prob / 50) ^ 0.6)
      end

      -- allow it to appear as often as the user wants
      W.rarity = nil
    end
  end -- for opt
end


OB_MODULES["weap_control"] =
{
  label = "Weapon Control (DOOM)",

  for_games = { doom1=1, doom2=1, freedoom=1 },
  for_modes = { sp=1, coop=1 },

  setup_func = Weap_Control_Setup,

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

