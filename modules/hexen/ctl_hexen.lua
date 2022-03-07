---------------------------------------------------------------
--  MODULE: Hexen Control
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

CTL_HEXEN = {}

function CTL_HEXEN.monster_setup(self)

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


OB_MODULES["hexen_mon_control"] =
{

  name = "hexen_mon_control",

  label = _("Hexen Monster Control"),

  game = "hexen",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_HEXEN.monster_setup
  },

  options =
  {

     {
      name = "float_ettin",
      label = _("Ettin"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_afrit",
      label = _("Afrit"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_centaur1",
      label = _("Centaur"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_centaur2",
      label = _("Slaughtaur"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_serpent1",
      label = _("Stalker"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_serpent2",
      label = _("Stalker w/ projectile"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_wendigo",
      label = _("Wendigo"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },

     {
      name = "float_demon1",
      label = _("Green Serpent"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_demon2",
      label = _("Brown Serpent"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_bishop",
      label = _("Bishop"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_reiver",
      label = _("Reiver"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_reiver_b",
      label = _("Buried Reiver"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	  
     {
      name = "float_Heresiarch",
      label = _("Heresiarch"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_Zedek",
      label = _("Zedek"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_Traductus",
      label = _("Traductus"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
	 
     {
      name = "float_Menelkir",
      label = _("Menelkir"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 20,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None at all)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "20:20 (INSANE),",
      randomize_group = "monsters"
     },
  },
}