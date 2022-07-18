---------------------------------------------------------------
--  MODULE: Harmony Control
----------------------------------------------------------------
--
--  Copyright (C) 2009-2010 Andrew Apted
--  Copyright (C) 2020-2021 MsrSgtShooterPerson
--  Copyright (C) 2021 Cubebert
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

CTL_HARMONY = {}

function CTL_HARMONY.monster_setup(self)

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


OB_MODULES["harmony_mon_control"] =
{

  name = "harmony_mon_control",

  label = _("Harmony Monster Control"),

  game = "harmony",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_HARMONY.monster_setup
  },

  options =
  {

    {
      name = "float_beastling",
      label = _("Beastling"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Beastlings.", 
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
      name = "float_critter",
      label = _("Critter"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Critters.", 
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
      name = "float_follower",
      label = _("Follower"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Followers.", 
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
      name = "float_predator",
      label = _("Predator"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Predators.", 
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
      name = "float_centaur",
      label = _("Centaur"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Centaurs.", 
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
      name = "float_mutant",
      label = _("Mutant"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Mutants.", 
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
      name = "float_phage",
      label = _("Phage"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Phages.", 
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
      name = "float_echidna",
      label = _("Echidna"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Echidnae.", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE)",
      randomize_group = "monsters"
     }
  },
}


----------------------------------------------------------------

CTL_HARMONY.WEAPON_PREF_CHOICES =
{
  "normal",  _("Normal"),
  "vanilla", _("Vanilla"),
  "none",    _("NONE"),
}


function CTL_HARMONY.weapon_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    local W = GAME.WEAPONS[string.sub(opt.name, 7)] -- Strip the float_ prefix from the weapon name for table lookup

    if W and PARAM[opt.name] ~= "Default" then
      W.add_prob = PARAM[opt.name] * 100
      W.pref     = W.add_prob * 0.28 + 1 -- Complete guesswork right now - Dasho

      -- loosen some of the normal restrictions
      W.level = 1
    end
  end -- for opt

  if PARAM.weapon_prefs == "vanilla"
  or PARAM.weapon_prefs == "none" then
    for _,mon in pairs(GAME.MONSTERS) do
      mon.weapon_prefs = nil
    end
  end

  if PARAM.weapon_prefs == "vanilla" then
    GAME.MONSTERS["Beastling"].weap_prefs = { launcher = 2.0 }
  end

end


OB_MODULES["harmony_weapon_control"] =
{

  name = "harmony_weapon_control",

  label = _("Harmony Weapon Control"),

  game = "harmony",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_HARMONY.weapon_setup
  },

  options =
  {

     {
      name = "float_minigun",
      label = _("Minigun"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Miniguns.", 
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
      name = "float_shotgun",
      label = _("Compensator"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Compensators.", 
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
      name = "float_launcher",
      label = _("Grenade Launcher"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Grenade Launchers.", 
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
      name = "float_entropy",
      label = _("Entropy Thrower"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default",
      tooltip = "Control the amount of Entropy Throwers.", 
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
      name="weapon_prefs",
      label=_("Weapon Preferences"),
      choices=CTL_HARMONY.WEAPON_PREF_CHOICES,
      tooltip="Alters selection of weapons that are prefered to show up depending on enemy palette for a chosen map.\n\n" ..
      "Normal: Monsters have weapon preferences. Stronger weapons and ammo are more likely to appear directly with stronger enemies.\n\n" ..
      "Vanilla: Vanilla Oblige-style preferences. Increases grenade launchers if the map has more beastlings. \n\n" ..
      "NONE: No preferences at all. For those who like to live life dangerously with Phages and only miniguns.",
      default="normal",
    },
  },
}