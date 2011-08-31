----------------------------------------------------------------
--  MODULE: Quake II Control
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

CTL_QUAKE2 = {}

CTL_QUAKE2.MON_CHOICES =
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

CTL_QUAKE2.MON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  insane = 2000
}


function CTL_QUAKE2.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value != "default" then
      local prob = CTL_QUAKE2.MON_PROBS[opt.value]

      M.prob = prob
      M.crazy_prob = prob

      if prob >  80 then M.density = 1.0 ; M.skip_prob = 30 end
      if prob > 180 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["quake2_mon_control"] =
{
  label = "Quake2 Monster Control"

  for_games = { quake2=1 }
  for_modes = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_QUAKE2.monster_setup
  }

  options =
  {
    guard      = { label="Guard",       choices=CTL_QUAKE2.MON_CHOICES }
    guard_sg   = { label="Guard w/ SG", choices=CTL_QUAKE2.MON_CHOICES }
    guard_mg   = { label="Guard w/ MG", choices=CTL_QUAKE2.MON_CHOICES }
    enforcer   = { label="Enforcer",    choices=CTL_QUAKE2.MON_CHOICES }
    flyer      = { label="Flyer",       choices=CTL_QUAKE2.MON_CHOICES }

    shark      = { label="Shark",       choices=CTL_QUAKE2.MON_CHOICES }
    parasite   = { label="Parasite",    choices=CTL_QUAKE2.MON_CHOICES }
    maiden     = { label="Maiden",      choices=CTL_QUAKE2.MON_CHOICES }
    technician = { label="Technician",  choices=CTL_QUAKE2.MON_CHOICES }
    beserker   = { label="Beserker",    choices=CTL_QUAKE2.MON_CHOICES }
    icarus     = { label="Icarus",      choices=CTL_QUAKE2.MON_CHOICES }

    medic      = { label="Medic",     choices=CTL_QUAKE2.MON_CHOICES }
    mutant     = { label="Mutant",    choices=CTL_QUAKE2.MON_CHOICES }
    brain      = { label="Brain",     choices=CTL_QUAKE2.MON_CHOICES }
    grenader   = { label="Grenader",  choices=CTL_QUAKE2.MON_CHOICES }
    gladiator  = { label="Gladiator", choices=CTL_QUAKE2.MON_CHOICES }

    tank       = { label="Tank",            choices=CTL_QUAKE2.MON_CHOICES }
    tank_cmdr  = { label="Tank Commander",  choices=CTL_QUAKE2.MON_CHOICES }
    Super_tank = { label="Super Tank",      choices=CTL_QUAKE2.MON_CHOICES }
    Huge_flyer = { label="Super Flyer",     choices=CTL_QUAKE2.MON_CHOICES }

    -- Jorg ?
    -- Makron ?
  }
}


----------------------------------------------------------------


CTL_QUAKE2.WEAPON_CHOICES =
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

CTL_QUAKE2.WEAPON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  loveit = 1000
}


function CTL_QUAKE2.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value != "default" then
      local prob = CTL_QUAKE2.WEAPON_PROBS[opt.value]

      W.add_prob = prob

      -- adjust usage preference as well
      if W.pref and prob > 0 then
        W.pref = W.pref * ((prob / 50) ^ 0.6)
      end

      -- allow it to appear as often as the user wants
      W.level = 1
      W.start_prob = nil
    end
  end -- for opt
end


OB_MODULES["quake2_weapon_control"] =
{
  label = "Quake2 Weapon Control"

  for_games = { quake2=1 }
  for_modes = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_QUAKE2.weapon_setup
  }

  options =
  {
    shotty   = { label="Shotgun",          choices=CTL_QUAKE2.WEAPON_CHOICES }
    ssg      = { label="Super Shotty",     choices=CTL_QUAKE2.WEAPON_CHOICES }
    machine  = { label="Machinegun",       choices=CTL_QUAKE2.WEAPON_CHOICES }
    chain    = { label="Chaingun",         choices=CTL_QUAKE2.WEAPON_CHOICES }
    grenade  = { label="Grenade Launcher", choices=CTL_QUAKE2.WEAPON_CHOICES }
    rocket   = { label="Rocket Launcher",  choices=CTL_QUAKE2.WEAPON_CHOICES }
    rail     = { label="Railgun",          choices=CTL_QUAKE2.WEAPON_CHOICES }
    hyper    = { label="Hyper-Blaster",    choices=CTL_QUAKE2.WEAPON_CHOICES }
    bfg      = { label="BFG 10K",          choices=CTL_QUAKE2.WEAPON_CHOICES }
  }
}

