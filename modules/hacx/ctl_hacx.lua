---------------------------------------------------------------
--  MODULE: Hacx Control
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

CTL_HACX = {}

function CTL_HACX.monster_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    local M = GAME.MONSTERS[string.sub(opt.name, 7)]

    if M and PARAM[opt.name] ~= gui.gettext("Default") then
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


OB_MODULES["hacx_mon_control"] =
{

  name = "hacx_mon_control",

  label = _("HacX 1.2 Monster Control"),

  game = "hacx",
  engine = "idtech_1",
  port = "!limit_enforcing",

  hooks =
  {
    setup = CTL_HACX.monster_setup
  },

  options =
  {
     {
      name = "float_thug",
      label = _("Thug"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Thugs."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_android",
      label = _("Android"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Androids."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_stealth",
      label = _("Stealth Buzzer"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Stealth Buzzers."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_roam_mine",
      label = _("Roaming Mine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Roaming Mines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_phage",
      label = _("Phage"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Phages."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_buzzer",
      label = _("Buzzer"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Buzzers."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_i_c_e",
      label = _("ICE"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of ICEs."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_d_man",
      label = _("D-Man"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of D-Men."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },
	 
     {
      name = "float_monstruct",
      label = _("Monstruct"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Monstructs."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },
	 
     {
      name = "float_majong7",
      label = _("Majong 7"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Majong 7s."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },
	 
     {
      name = "float_terminatrix",
      label = _("Terminatrix"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Terminatrixes."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },
	 
     {
      name = "float_thorn",
      label = _("Thorn"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Thorns."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     },

     {
      name = "float_mecha",
      label = _("Mecha Maniac"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Mecha Maniacs."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group = "monsters"
     }
  },
}


----------------------------------------------------------------

CTL_HACX.WEAPON_PREF_CHOICES =
{
  "normal",  _("Normal"),
  "vanilla", _("Vanilla"),
  "none",    _("NONE"),
}


function CTL_HACX.weapon_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    if opt.name == "float_reznator" then 
      if PARAM["float_reznator"] and PARAM["float_reznator"] ~= gui.gettext("Default") then
        local info = GAME.NICE_ITEMS.reznator
        local mult = PARAM["float_reznator"] or 0
  
        if info.add_prob then info.add_prob = info.add_prob * mult end
        if info.start_prob then info.start_prob = info.start_prob * mult end
        if info.crazy_prob then info.crazy_prob = info.crazy_prob * mult end
        if info.closet_prob then info.closet_prob = info.closet_prob * mult end
        if info.secret_prob then info.secret_prob = info.secret_prob * mult end
        if info.storage_prob then info.storage_prob = info.storage_prob * mult end
      end    
      goto skip
    end

    local W = GAME.WEAPONS[string.sub(opt.name, 7)] -- Strip the float_ prefix from the weapon name for table lookup

    if W and PARAM[opt.name] ~= gui.gettext("Default") then
      W.add_prob = PARAM[opt.name] * 100
      W.pref     = W.add_prob * 0.28 + 1 -- Complete guesswork right now - Dasho

      -- loosen some of the normal restrictions
      W.level = 1
    end

    ::skip::

  end -- for opt

  if PARAM.weapon_prefs == "vanilla"
  or PARAM.weapon_prefs == "none" then
    for _,mon in pairs(GAME.MONSTERS) do
      mon.weapon_prefs = nil
    end
  end

  if PARAM.weapon_prefs == "vanilla" then
    GAME.MONSTERS["ICE"].weap_prefs = { zooka = 2.0 }
	GAME.MONSTERS["D-Man"].weap_prefs = { zooka = 2.0 }
	GAME.MONSTERS["Roaming Mine"].weap_prefs = { zooka = 2.0 }
  end

end


OB_MODULES["hacx_weapon_control"] =
{

  name = "hacx_weapon_control",

  label = _("HacX 1.2 Weapon Control"),

  game = "hacx",
  engine = "idtech_1",
  port = "!limit_enforcing",

  hooks =
  {
    setup = CTL_HACX.weapon_setup
  },

  options =
  {

     {
      name = "float_reznator",
      label = _("Hoig Reznator"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the likelihood of finding the Hoig Reznator."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },

     {
      name = "float_tazer",
      label = _("Tazer"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"), 
      tooltip = _("Control the amount of Tazers."),
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },

     {
      name = "float_cryogun",
      label = _("Cryogun"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Cryoguns."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },

     {
      name = "float_fu2",
      label = _("Uzi"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Uzis."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },
	 
     {
      name = "float_zooka",
      label = _("Photon 'Zooka"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Photon 'Zookas."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },
	 
     {
      name = "float_antigun",
      label = _("Anti-Gun"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Anti-Guns."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },
	 
     {
      name = "float_nuker",
      label = _("Nuker"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Nukers."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group = "pickups"
     },

    {
      name="weapon_prefs",
      label=_("Weapon Preferences"),
      choices=CTL_HACX.WEAPON_PREF_CHOICES,
      tooltip = _("Alters selection of weapons that are prefered to show up depending on enemy palette for a chosen map.\n\nNormal: Monsters have weapon preferences. Stronger weapons and ammo are more likely to appear directly with stronger enemies.\n\nVanilla: Vanilla Oblige-style preferences. Increases 'Zookas if the map has more ICEs, D-Mans, or roaming mines. \n\nNONE: No preferences at all. For those who like to live life dangerously with ICEs and only 'Zookas."),
      default="normal",
    },
  },
}