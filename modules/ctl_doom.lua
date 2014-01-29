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
  "default", "DEFAULT",
  "none",    "None at all",
  "scarce",  "Scarce",
  "less",    "Less",
  "plenty",  "Plenty",
  "more",    "More",
  "heaps",   "Heaps",
  "insane",  "INSANE",
}

CTL_DOOM.MON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  insane = 2000
}

CTL_DOOM.DENSITIES =
{
  none   = 0.1
  scarce = 0.2
  less   = 0.4
  plenty = 0.7
  more   = 1.2
  heaps  = 3.3
  insane = 9.9
}


function CTL_DOOM.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value != "default" then
      M.prob    = CTL_DOOM.MON_PROBS[opt.value]
      M.density = CTL_DOOM.DENSITIES[opt.value]

      -- allow Spectres to be controlled individually
      M.replaces = nil

      -- loosen some of the normal restrictions
      M.skip_prob = nil
      M.crazy_prob = nil

      if M.prob > 40 then
        M.level = 1
      end
    end
  end -- for opt
end


OB_MODULES["doom_mon_control"] =
{
  label = "Doom Monster Control"

  game = { doom1=1, doom2=1 }
  playmode = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_DOOM.monster_setup
  }

  options =
  {
    zombie   = { label="Zombieman",      choices=CTL_DOOM.MON_CHOICES }
    shooter  = { label="Shotgun Guy",    choices=CTL_DOOM.MON_CHOICES }
    gunner   = { label="Chaingunner",    choices=CTL_DOOM.MON_CHOICES }
    ss_dude  = { label="SS Nazi",        choices=CTL_DOOM.MON_CHOICES }
    imp      = { label="Imp",            choices=CTL_DOOM.MON_CHOICES }

    skull    = { label="Lost Soul",      choices=CTL_DOOM.MON_CHOICES }
    demon    = { label="Demon",          choices=CTL_DOOM.MON_CHOICES }
    spectre  = { label="Spectre",        choices=CTL_DOOM.MON_CHOICES }
    pain     = { label="Pain Elemental", choices=CTL_DOOM.MON_CHOICES }
    caco     = { label="Cacodemon",      choices=CTL_DOOM.MON_CHOICES }
    knight   = { label="Hell Knight",    choices=CTL_DOOM.MON_CHOICES }

    revenant = { label="Revenant",       choices=CTL_DOOM.MON_CHOICES }
    mancubus = { label="Mancubus",       choices=CTL_DOOM.MON_CHOICES }
    arach    = { label="Arachnotron",    choices=CTL_DOOM.MON_CHOICES }
    vile     = { label="Archvile",       choices=CTL_DOOM.MON_CHOICES }
    baron    = { label="Baron of Hell",  choices=CTL_DOOM.MON_CHOICES }

    Cyberdemon = { label="Cyberdemon",   choices=CTL_DOOM.MON_CHOICES }
    Mastermind = { label="Mastermind",   choices=CTL_DOOM.MON_CHOICES }
  }
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
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  loveit = 1000
}

CTL_DOOM.WEAPON_PREFS =
{
  none   = 1
  scarce = 10
  less   = 25
  plenty = 40
  more   = 70
  heaps  = 100
  loveit = 170
}


function CTL_DOOM.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value != "default" then
      W.add_prob = CTL_DOOM.WEAPON_PROBS[opt.value]
      W.pref     = CTL_DOOM.WEAPON_PREFS[opt.value]

      -- loosen some of the normal restrictions
      W.level = 1
      W.start_prob = nil
    end
  end -- for opt
end


OB_MODULES["doom_weapon_control"] =
{
  label = "Doom Weapon Control"

  game = { doom1=1, doom2=1 }
  playmode = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_DOOM.weapon_setup
  }

  options =
  {
    berserk  = { label="Berserk",          choices=CTL_DOOM.WEAPON_CHOICES }
    saw      = { label="Saw",              choices=CTL_DOOM.WEAPON_CHOICES }
    shotty   = { label="Shotgun",          choices=CTL_DOOM.WEAPON_CHOICES }
    super    = { label="Super Shotty",     choices=CTL_DOOM.WEAPON_CHOICES }
    chain    = { label="Chaingun",         choices=CTL_DOOM.WEAPON_CHOICES }
    launch   = { label="Rocket Launcher",  choices=CTL_DOOM.WEAPON_CHOICES }
    plasma   = { label="Plasma Rifle",     choices=CTL_DOOM.WEAPON_CHOICES }
    bfg      = { label="B.F.G",            choices=CTL_DOOM.WEAPON_CHOICES }
  }
}

