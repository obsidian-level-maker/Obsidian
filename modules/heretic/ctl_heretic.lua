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

function CTL_HERETIC.monster_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    local M = GAME.MONSTERS[string.sub(opt.name, 7)]

    if M and PARAM[opt.name] ~= "Default" then
      M.prob    = PARAM[opt.name] * 100
      M.density = M.prob * .006 + .1

      -- allow Spectres to be controlled individually
      M.replaces = nil

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
  end

end


OB_MODULES["heretic_mon_control"] =
{

  name = "heretic_mon_control",

  label = _("Heretic Monster Control"),

  game = "heretic",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_HERETIC.monster_setup
  },

  options =
  {

     {
      name = "float_gargoyle",
      label = _("Gargoyle"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_fire_garg",
      label = _("Fire Gargoyle"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_warrior",
      label = _("Warrior"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_warrior_ghost",
      label = _("Warrior Ghost"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_golem",
      label = _("Golem"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_golem_ghost",
      label = _("Golem Ghost"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_nitro",
      label = _("Nitro"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_nitro_ghost",
      label = _("Nitro Ghost"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_disciple",
      label = _("Disciple"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_sabreclaw",
      label = _("Sabreclaw"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_weredragon",
      label = _("Weredragon"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_ophidian",
      label = _("Ophidian"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_Ironlich",
      label = _("Ironlich"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_Maulotaur",
      label = _("Maulotaur"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     },

     {
      name = "float_D_Sparil",
      label = _("D'Sparil"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     }
  }
}


----------------------------------------------------------------

function CTL_HERETIC.weapon_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    local W = GAME.WEAPONS[string.sub(opt.name, 7)] -- Strip the float_ prefix from the weapon name for table lookup

    if W and PARAM[opt.name] ~= "Default" then
      W.add_prob = PARAM[opt.name] * 100
      W.pref     = W.add_prob * 0.28 + 1 -- Complete guesswork right now - Dasho

      -- loosen some of the normal restrictions
      W.level = 1
    end
  end
  
end


OB_MODULES["heretic_weapon_control"] =
{

  name = "heretic_weapon_control",

  label = _("Heretic Weapon Control"),

  game = "heretic",

  hooks =
  {
    setup = CTL_HERETIC.weapon_setup
  },

  options =
  {

     {
      name = "float_gauntlets",
      label = _("Gauntlets"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT)",
      randomize_group = "pickups"
     },
     
     {
      name = "float_crossbow",
      label = _("Crossbow"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT)",
      randomize_group = "pickups"
     },
     
     {
      name = "float_claw",
      label = _("Dragon Claw"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT)",
      randomize_group = "pickups"
     },

     {
      name = "float_hellstaff",
      label = _("Hellstaff"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT)",
      randomize_group = "pickups"
     },
     
     {
      name = "float_phoenix",
      label = _("Phoenix Rod"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT)",
      randomize_group = "pickups"
     },

     {
      name = "float_firemace",
      label = _("Fire Mace"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT)",
      randomize_group = "pickups"
     }
  }
}

