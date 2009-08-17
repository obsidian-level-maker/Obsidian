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
  "scarce", "Scarce",
  "less",   "Less",
  "normal", "Normal",
  "more",   "More",
  "heaps",  "Heaps",
  "swarms", "Swarms",
  "insane", "INSANE",
}

MON_CONTROL_AMOUNTS =
{
  scarce = 0.02,
  less   = 0.3,
  normal = 1,
  more   = 3,
  heaps  = 15,
  swarms = 60,
  insane = 600,
}


function MonControl_setup(self)

  for name,opt = pairs(self.options) do
    local M = GAME.monsters[name]
    local factor = MON_CONTROL_AMOUNTS[opt.value]

    if M and factor then
      if not M.prob then M.prob = M.prob 
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
    zombie   = { label="Zombiemen",   priority=45, choices=MON_CONTROL_CHOICES },
    shooter  = { label="Shotgun Guy", priority=44, choices=MON_CONTROL_CHOICES },
    gunner   = { label="Chaingunner", priority=43, choices=MON_CONTROL_CHOICES },
    ss_dude  = { label="SS Nazi",     priority=42, choices=MON_CONTROL_CHOICES },
    imp      = { label="Imp",         priority=41, choices=MON_CONTROL_CHOICES },

    skull    = { label="Lost Soul",   priority=35, choices=MON_CONTROL_CHOICES },
    demon    = { label="Demon / Spectre", priority=34, choices=MON_CONTROL_CHOICES },
    pain     = { label="Pain Elemental",  priority=33, choices=MON_CONTROL_CHOICES },
    caco     = { label="Cacodemon",   priority=32, choices=MON_CONTROL_CHOICES },
    knight   = { label="Hell Knight", priority=31, choices=MON_CONTROL_CHOICES },

    revenant = { label="Revenant",    priority=25, choices=MON_CONTROL_CHOICES },
    mancubus = { label="Mancubus",    priority=24, choices=MON_CONTROL_CHOICES },
    arach    = { label="Arachnotron", priority=23, choices=MON_CONTROL_CHOICES },
    vile     = { label="Archvile",    priority=22, choices=MON_CONTROL_CHOICES },
    baron    = { label="Baron of Hell", priority=21, choices=MON_CONTROL_CHOICES },

    Cyberdemon = { label="Cyberdemon", priority=12, choices=MON_CONTROL_CHOICES },
    Mastermind = { label="Mastermind", priority=11, choices=MON_CONTROL_CHOICES },
}

