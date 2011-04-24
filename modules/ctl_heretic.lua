----------------------------------------------------------------
--  MODULE: Heretic Control
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

CTL_HERETIC = {}

CTL_HERETIC.MON_CHOICES =
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

CTL_HERETIC.MON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  insane = 2000
}


function CTL_HERETIC.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value != "default" then
      local prob = CTL_HERETIC.MON_PROBS[opt.value]

      M.prob = prob
      M.crazy_prob = prob

      if prob >  80 then M.density = 1.0 ; M.skip_prob = 30 end
      if prob > 180 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["heretic_mon_control"] =
{
  label = "Heretic Monster Control"

  for_games = { heretic=1 }
  for_modes = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_HERETIC.monster_setup
  }

  options =
  {
    gargoyle   = { label="Gargoyle",        choices=CTL_HERETIC.MON_CHOICES }
    fire_garg  = { label="Gargoyle Leader", choices=CTL_HERETIC.MON_CHOICES }
    sabreclaw  = { label="Sabreclaw",  choices=CTL_HERETIC.MON_CHOICES }

    knight     = { label="Warrior",         choices=CTL_HERETIC.MON_CHOICES }
--  knight_inv = { label="Warrior Ghost",   choices=CTL_HERETIC.MON_CHOICES }
    mummy      = { label="Golem",           choices=CTL_HERETIC.MON_CHOICES }
--  mummy_inv  = { label="Golem Ghost",     choices=CTL_HERETIC.MON_CHOICES }
    leader     = { label="Golem Leader",    choices=CTL_HERETIC.MON_CHOICES }
--  leader_inv = { label="Golem Leader Ghost", choices=CTL_HERETIC.MON_CHOICES }

    disciple   = { label="Disciple",   choices=CTL_HERETIC.MON_CHOICES }
    weredragon = { label="Weredragon", choices=CTL_HERETIC.MON_CHOICES }
    ohpibian   = { label="Mancubus",   choices=CTL_HERETIC.MON_CHOICES }

    Ironlich  = { label="Ironlich",    choices=CTL_HERETIC.MON_CHOICES }
    Maulotaur = { label="Maulotaur",   choices=CTL_HERETIC.MON_CHOICES }
    D_Sparil  = { label="D'Sparil",    choices=CTL_HERETIC.MON_CHOICES }
  }
}


----------------------------------------------------------------


CTL_HERETIC.WEAPON_CHOICES =
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

CTL_HERETIC.WEAPON_PROBS =
{
  none   = 0
  scarce = 2
  less   = 15
  plenty = 50
  more   = 120
  heaps  = 300
  loveit = 1000
}


function CTL_HERETIC.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value != "default" then
      local prob = CTL_HERETIC.WEAPON_PROBS[opt.value]

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


OB_MODULES["heretic_weapon_control"] =
{
  label = "Heretic Weapon Control"

  for_games = { heretic=1 }
  for_modes = { sp=1, coop=1 }

  hooks =
  {
    setup = CTL_HERETIC.weapon_setup
  }

  options =
  {
    gauntlets  = { label="Gauntlets",    choices=CTL_HERETIC.WEAPON_CHOICES }
    crossbow   = { label="Crossbow",     choices=CTL_HERETIC.WEAPON_CHOICES }
    claw       = { label="Dragon Claw",  choices=CTL_HERETIC.WEAPON_CHOICES }
    hellstaff  = { label="Hellstaff",    choices=CTL_HERETIC.WEAPON_CHOICES }
    phoenix    = { label="Phoenix Rod",  choices=CTL_HERETIC.WEAPON_CHOICES }
    firemace   = { label="Fire Mace",    choices=CTL_HERETIC.WEAPON_CHOICES }
  }
}

