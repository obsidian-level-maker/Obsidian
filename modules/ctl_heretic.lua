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
  "default", _("DEFAULT"),
  "none",    _("None at all"),
  "scarce",  _("Scarce"),
  "less",    _("Less"),
  "plenty",  _("Plenty"),
  "more",    _("More"),
  "heaps",   _("Heaps"),
  "insane",  _("INSANE"),
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

CTL_HERETIC.DENSITIES =
{
  none   = 0.1
  scarce = 0.2
  less   = 0.4
  plenty = 0.7
  more   = 1.2
  heaps  = 3.3
  insane = 9.9
}


function CTL_HERETIC.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value != "default" then
      M.prob    = CTL_HERETIC.MON_PROBS[opt.value]
      M.density = CTL_HERETIC.DENSITIES[opt.value]

      -- loosen some of the normal restrictions
      M.skip_prob = nil
      M.crazy_prob = nil

      if M.prob > 40 then
        M.level = 1
        M.weap_min_damage = nil
      end

      if M.prob > 200 then
        M.boss_type = nil
      end
    end
  end -- for opt
end


OB_MODULES["heretic_mon_control"] =
{
  label = _("Heretic Monster Control")

  game = "heretic"

  hooks =
  {
    setup = CTL_HERETIC.monster_setup
  }

  options =
  {
    gargoyle   = { label="Gargoyle",      choices=CTL_HERETIC.MON_CHOICES }
    fire_garg  = { label="Fire Gargoyle", choices=CTL_HERETIC.MON_CHOICES }
    warrior    = { label="Warrior",       choices=CTL_HERETIC.MON_CHOICES }
    warrior_ghost = { label="Warrior Ghost", choices=CTL_HERETIC.MON_CHOICES }

    golem       = { label="Golem",         choices=CTL_HERETIC.MON_CHOICES }
    golem_ghost = { label="Golem Ghost",   choices=CTL_HERETIC.MON_CHOICES }
    nitro       = { label="Nitro",         choices=CTL_HERETIC.MON_CHOICES }
    nitro_ghost = { label="Nitro Ghost",   choices=CTL_HERETIC.MON_CHOICES }

    disciple   = { label="Disciple",      choices=CTL_HERETIC.MON_CHOICES }
    sabreclaw  = { label="Sabreclaw",     choices=CTL_HERETIC.MON_CHOICES }
    weredragon = { label="Weredragon",    choices=CTL_HERETIC.MON_CHOICES }
    ophidian   = { label="Ophidian",      choices=CTL_HERETIC.MON_CHOICES }

    Ironlich  = { label="Ironlich",       choices=CTL_HERETIC.MON_CHOICES }
    Maulotaur = { label="Maulotaur",      choices=CTL_HERETIC.MON_CHOICES }
    D_Sparil  = { label="D'Sparil",       choices=CTL_HERETIC.MON_CHOICES }
  }
}


----------------------------------------------------------------


CTL_HERETIC.WEAPON_CHOICES =
{
  "default", _("DEFAULT"),
  "none",    _("None at all"),
  "scarce",  _("Scarce"),
  "less",    _("Less"),
  "plenty",  _("Plenty"),
  "more",    _("More"),
  "heaps",   _("Heaps"),
  "loveit",  _("I LOVE IT"),
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

CTL_HERETIC.WEAPON_PREFS =
{
  none   = 1
  scarce = 10
  less   = 25
  plenty = 40
  more   = 70
  heaps  = 100
  loveit = 170
}


function CTL_HERETIC.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value != "default" then
      W.add_prob = CTL_HERETIC.WEAPON_PROBS[opt.value]
      W.pref     = CTL_HERETIC.WEAPON_PREFS[opt.value]

      -- loosen some of the normal restrictions
      W.level = 1
    end
  end -- for opt
end


OB_MODULES["heretic_weapon_control"] =
{
  label = _("Heretic Weapon Control")

  game = "heretic"

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

