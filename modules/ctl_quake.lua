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


function CTL_QUAKE.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value != "default" then
      local prob = CTL_QUAKE.MON_PROBS[opt.value]

      M.prob = prob
      M.crazy_prob = prob

      if prob >  80 then M.density = 1.0 ; M.skip_prob = 30 end
      if prob > 180 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["quake_mon_control"] =
{
  label = "Quake Monster Control"

  for_games = { quake=1 }
  for_modes = { sp=1, coop=1 }

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


function CTL_QUAKE.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value != "default" then
      local prob = CTL_QUAKE.WEAPON_PROBS[opt.value]

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


OB_MODULES["quake_weapon_control"] =
{
  label = "Quake Weapon Control"

  for_games = { quake=1 }
  for_modes = { sp=1, coop=1 }

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

