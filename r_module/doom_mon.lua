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

CTL_DOOM = {}

CTL_DOOM.MON_CHOICES =
{
  "default", "CHANGE",
  "none",    "Remove",
  "scarce",  "No Change",
  "less",    "Weaker",
  "plenty",  "Stronger",
  "more",    "Less",
  "heaps",   "More",
}

CTL_DOOM.MON_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}


function CTL_DOOM.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value ~= "default" then
      local prob = CTL_DOOM.MON_PROBS[opt.value]

      -- allow Spectres to be controlled individually
      M.replaces = nil

      M.prob = prob
      M.crazy_prob = prob

      if prob >  80 then M.density = 1.0 ; M.skip_prob = 30 end
      if prob > 180 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["doom_mon_control"] =
{
  label = "Doom Monster Control",

  for_games = { doom1=1, doom2=1 },
  for_modes = { sp=1, coop=1 },

  hooks =
  {
    setup = CTL_DOOM.monster_setup,
  },

  options =
  {
    zombie   = { label="Zombieman",      choices=CTL_DOOM.MON_CHOICES },
    shooter  = { label="Shotgun Guy",    choices=CTL_DOOM.MON_CHOICES },
    gunner   = { label="Chaingunner",    choices=CTL_DOOM.MON_CHOICES },
    ss_dude  = { label="SS Nazi",        choices=CTL_DOOM.MON_CHOICES },
    imp      = { label="Imp",            choices=CTL_DOOM.MON_CHOICES },

    skull    = { label="Lost Soul",      choices=CTL_DOOM.MON_CHOICES },
    demon    = { label="Demon",          choices=CTL_DOOM.MON_CHOICES },
    spectre  = { label="Spectre",        choices=CTL_DOOM.MON_CHOICES },
    pain     = { label="Pain Elemental", choices=CTL_DOOM.MON_CHOICES },
    caco     = { label="Cacodemon",      choices=CTL_DOOM.MON_CHOICES },
    knight   = { label="Hell Knight",    choices=CTL_DOOM.MON_CHOICES },

    revenant = { label="Revenant",       choices=CTL_DOOM.MON_CHOICES },
    mancubus = { label="Mancubus",       choices=CTL_DOOM.MON_CHOICES },
    arach    = { label="Arachnotron",    choices=CTL_DOOM.MON_CHOICES },
    vile     = { label="Archvile",       choices=CTL_DOOM.MON_CHOICES },
    baron    = { label="Baron of Hell",  choices=CTL_DOOM.MON_CHOICES },

    Cyberdemon = { label="Cyberdemon",   choices=CTL_DOOM.MON_CHOICES },
    Mastermind = { label="Mastermind",   choices=CTL_DOOM.MON_CHOICES },
  },
}


----------------------------------------------------------------


CTL_DOOM.WEAPON_CHOICES =
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

CTL_DOOM.WEAPON_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  loveit = 1000,
}


function CTL_DOOM.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value ~= "default" then
      local prob = CTL_DOOM.WEAPON_PROBS[opt.value]

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


OB_MODULES["doom_weapon_control"] =
{
  label = "Doom Weapon Control",

  for_games = { doom1=1, doom2=1 },
  for_modes = { sp=1, coop=1 },

  hooks =
  {
    setup = CTL_DOOM.weapon_setup,
  },

  options =
  {
    berserk  = { label="Berserk",          choices=CTL_DOOM.WEAPON_CHOICES },
    saw      = { label="Saw",              choices=CTL_DOOM.WEAPON_CHOICES },
    shotty   = { label="Shotgun",          choices=CTL_DOOM.WEAPON_CHOICES },
    super    = { label="Super Shotty",     choices=CTL_DOOM.WEAPON_CHOICES },
    chain    = { label="Chaingun",         choices=CTL_DOOM.WEAPON_CHOICES },
    launch   = { label="Rocket Launcher",  choices=CTL_DOOM.WEAPON_CHOICES },
    plasma   = { label="Plasma Rifle",     choices=CTL_DOOM.WEAPON_CHOICES },
    bfg      = { label="B.F.G",            choices=CTL_DOOM.WEAPON_CHOICES },
  },
}

