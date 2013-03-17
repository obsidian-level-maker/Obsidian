----------------------------------------------------------------
--  MODULE: Quake Control
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

CTL_QUAKE = {}

CTL_QUAKE.MON_CHOICES =
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

CTL_QUAKE.MON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  insane = 2000
}

CTL_QUAKE.DENSITIES =
{
  none   = 0.1
  scarce = 0.2
  less   = 0.4
  plenty = 0.7
  more   = 1.2
  heaps  = 3.3
  insane = 9.9
}


function CTL_QUAKE.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value != "default" then
      M.prob    = CTL_QUAKE.MON_PROBS[opt.value]
      M.density = CTL_QUAKE.DENSITIES[opt.value]

      -- allow Rottweilers to be controlled individually
      M.replaces = nil

      -- loosen some of the normal restrictions
      M.level = 1
      M.skip_prob = nil
      M.crazy_prob = nil
    end
  end -- for opt
end


OB_MODULES["quake_mon_control"] =
{
  label = "Quake Monster Control"

  game = { quake=1 }
  playmode = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_QUAKE.monster_setup
  }

  options =
  {
    dog      = { label="Rottweiler", choices=CTL_QUAKE.MON_CHOICES }
    fish     = { label="Rotfish",    choices=CTL_QUAKE.MON_CHOICES }
    grunt    = { label="Grunt",      choices=CTL_QUAKE.MON_CHOICES }
    enforcer = { label="Enforcer",   choices=CTL_QUAKE.MON_CHOICES }
    zombie   = { label="Zombie",     choices=CTL_QUAKE.MON_CHOICES }

    knight   = { label="Knight",       choices=CTL_QUAKE.MON_CHOICES }
    death_kt = { label="Death Knight", choices=CTL_QUAKE.MON_CHOICES }
    scrag    = { label="Scrag",        choices=CTL_QUAKE.MON_CHOICES }
    tarbaby  = { label="Spawn",        choices=CTL_QUAKE.MON_CHOICES }

    ogre     = { label="Ogre",      choices=CTL_QUAKE.MON_CHOICES }
    fiend    = { label="Fiend",     choices=CTL_QUAKE.MON_CHOICES }
    vore     = { label="Vore",      choices=CTL_QUAKE.MON_CHOICES }
    shambler = { label="Schambler", choices=CTL_QUAKE.MON_CHOICES }
  }
}


----------------------------------------------------------------


CTL_QUAKE.WEAPON_CHOICES =
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

CTL_QUAKE.WEAPON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  loveit = 1000
}

CTL_QUAKE.WEAPON_PREFS =
{
  none   = 1
  scarce = 10
  less   = 25
  plenty = 40
  more   = 70
  heaps  = 100
  loveit = 170
}


function CTL_QUAKE.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value != "default" then
      W.add_prob = CTL_QUAKE.WEAPON_PROBS[opt.value]
      W.pref     = CTL_QUAKE.WEAPON_PREFS[opt.value]

      -- loosen some of the normal restrictions
      W.level = 1
      W.start_prob = nil
    end
  end -- for opt
end


OB_MODULES["quake_weapon_control"] =
{
  label = "Quake Weapon Control"

  game = { quake=1 }
  playmode = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_QUAKE.weapon_setup
  }

  options =
  {
    ssg      = { label="Double Shotgun",   choices=CTL_QUAKE.WEAPON_CHOICES }
    nailgun  = { label="Nailgun",          choices=CTL_QUAKE.WEAPON_CHOICES }
    nailgun2 = { label="Perforator",       choices=CTL_QUAKE.WEAPON_CHOICES }
    grenade  = { label="Grenade Launcher", choices=CTL_QUAKE.WEAPON_CHOICES }
    rocket   = { label="Rocket Launcher",  choices=CTL_QUAKE.WEAPON_CHOICES }
    zapper   = { label="Thunderbolt",      choices=CTL_QUAKE.WEAPON_CHOICES }
  }
}

