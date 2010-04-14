----------------------------------------------------------------
--  MODULE: Doom Control
----------------------------------------------------------------
--
--  Copyright (C) 2009-2010 Andrew Apted
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

DOOM.MON_CONTROL_CHOICES =
{
  "default", "DEFAULT",
  "none",    "None at all",
  "scarce",  "Scarce",
  "less",    "Less",
  "plenty",  "Plenty",
  "more",    "More",
  "heaps",   "Heaps",
  "insane",  "INSANE",
}

DOOM.MON_CONTROL_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}


function DOOM.mon_control_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.monsters[name]

    if M and opt.value ~= "default" then
      local prob = DOOM.MON_CONTROL_PROBS[opt.value]

      -- allow Spectres to be controlled individually
      M.replaces = nil

      M.prob = prob
      M.crazy_prob = prob

      if prob >  80 then M.density = 1.0 ; M.skip_prob = 30 end
      if prob > 180 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["mon_control"] =
{
  label = "Monster Control (DOOM)",

  for_games = { doom1=1, doom2=1 },
  for_modes = { sp=1, coop=1 },

  hooks =
  {
    setup = DOOM.mon_control_setup,
  },

  options =
  {
    zombie   = { label="Zombieman",      choices=DOOM.MON_CONTROL_CHOICES },
    shooter  = { label="Shotgun Guy",    choices=DOOM.MON_CONTROL_CHOICES },
    gunner   = { label="Chaingunner",    choices=DOOM.MON_CONTROL_CHOICES },
    ss_dude  = { label="SS Nazi",        choices=DOOM.MON_CONTROL_CHOICES },
    imp      = { label="Imp",            choices=DOOM.MON_CONTROL_CHOICES },

    skull    = { label="Lost Soul",      choices=DOOM.MON_CONTROL_CHOICES },
    demon    = { label="Demon",          choices=DOOM.MON_CONTROL_CHOICES },
    spectre  = { label="Spectre",        choices=DOOM.MON_CONTROL_CHOICES },
    pain     = { label="Pain Elemental", choices=DOOM.MON_CONTROL_CHOICES },
    caco     = { label="Cacodemon",      choices=DOOM.MON_CONTROL_CHOICES },
    knight   = { label="Hell Knight",    choices=DOOM.MON_CONTROL_CHOICES },

    revenant = { label="Revenant",       choices=DOOM.MON_CONTROL_CHOICES },
    mancubus = { label="Mancubus",       choices=DOOM.MON_CONTROL_CHOICES },
    arach    = { label="Arachnotron",    choices=DOOM.MON_CONTROL_CHOICES },
    vile     = { label="Archvile",       choices=DOOM.MON_CONTROL_CHOICES },
    baron    = { label="Baron of Hell",  choices=DOOM.MON_CONTROL_CHOICES },

    Cyberdemon = { label="Cyberdemon",   choices=DOOM.MON_CONTROL_CHOICES },
    Mastermind = { label="Mastermind",   choices=DOOM.MON_CONTROL_CHOICES },
  },
}


----------------------------------------------------------------


DOOM.WEAP_CONTROL_CHOICES =
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

DOOM.WEAP_CONTROL_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  loveit = 1000,
}


function DOOM.weap_control_setup(self)
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
  label = "weap_c Control (DOOM)",

  for_games = { doom1=1, doom2=1 },
  for_modes = { sp=1, coop=1 },

  hooks =
  {
    setup = DOOM.weap_control_setup,
  },

  options =
  {
    berserk  = { label="Berserk",          choices=DOOM.WEAP_CONTROL_CHOICES },
    saw      = { label="Saw",              choices=DOOM.WEAP_CONTROL_CHOICES },
    shotty   = { label="Shotgun",          choices=DOOM.WEAP_CONTROL_CHOICES },
    super    = { label="Super Shotty",     choices=DOOM.WEAP_CONTROL_CHOICES },
    chain    = { label="Chaingun",         choices=DOOM.WEAP_CONTROL_CHOICES },
    launch   = { label="Rocket Launcher",  choices=DOOM.WEAP_CONTROL_CHOICES },
    plasma   = { label="Plasma Rifle",     choices=DOOM.WEAP_CONTROL_CHOICES },
    bfg      = { label="B.F.G",            choices=DOOM.WEAP_CONTROL_CHOICES },
  },
}

