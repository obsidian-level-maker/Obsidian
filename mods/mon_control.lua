----------------------------------------------------------------
--  MODULE: Monster Control
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

MON_CONTROL_CHOICES =
{
  "normal", "Normal",
  "scarce", "Scarce",
  "less",   "Less",
  "more",   "More",
  "heaps",  "Heaps",
  "insane", "INSANE",
}

MON_CONTROL_AMOUNTS =
{
  scarce = 1,
  less   = 15,
  normal = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}


function MonControl_setup(self)

  for name,opt in pairs(self.options) do
    local M = GAME.monsters[name]
    local factor = MON_CONTROL_AMOUNTS[opt.value]

    if M and factor then
      M.prob = factor
      M.crazy_prob = factor

      if factor >  80 then M.density = 1.0 end
      if factor > 180 then M.always_use = true end
    end
  end -- for opt

end


OB_MODULES["mon_control"] =
{
  label = "Monster Control (DOOM)",

  for_games = { doom1=1, doom2=1 },
  for_modes = { sp=1, coop=1 },

  setup_func = MonControl_setup,

  options =
  {
    zombie   = { label="Zombieman",      choices=MON_CONTROL_CHOICES },
    shooter  = { label="Shotgun Guy",    choices=MON_CONTROL_CHOICES },
    gunner   = { label="Chaingunner",    choices=MON_CONTROL_CHOICES },
    ss_dude  = { label="SS Nazi",        choices=MON_CONTROL_CHOICES },
    imp      = { label="Imp",            choices=MON_CONTROL_CHOICES },

    skull    = { label="Lost Soul",      choices=MON_CONTROL_CHOICES },
    demon    = { label="Demon / Spectre", choices=MON_CONTROL_CHOICES },
    pain     = { label="Pain Elemental", choices=MON_CONTROL_CHOICES },
    caco     = { label="Cacodemon",      choices=MON_CONTROL_CHOICES },
    knight   = { label="Hell Knight",    choices=MON_CONTROL_CHOICES },

    revenant = { label="Revenant",       choices=MON_CONTROL_CHOICES },
    mancubus = { label="Mancubus",       choices=MON_CONTROL_CHOICES },
    arach    = { label="Arachnotron",    choices=MON_CONTROL_CHOICES },
    vile     = { label="Archvile",       choices=MON_CONTROL_CHOICES },
    baron    = { label="Baron of Hell",  choices=MON_CONTROL_CHOICES },

    Cyberdemon = { label="Cyberdemon",   choices=MON_CONTROL_CHOICES },
    Mastermind = { label="Mastermind",   choices=MON_CONTROL_CHOICES },
  },
}

