---------------------------------------------------------------
--  MODULE: Chex Quest 3 Control
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

CTL_CHEX3 = {}

function CTL_CHEX3.monster_setup(self)

  for _,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          local value = tonumber(OB_CONFIG[opt.name])
          if not value then
            PARAM[opt.name] = OB_CONFIG[opt.name]
          else
            if opt.increment < 1 then
              PARAM[opt.name] = value
            else
              PARAM[opt.name] = int(value)
            end
          end
        elseif opt.valuator == "button" then
          PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
        end
      else
        PARAM[opt.name] = OB_CONFIG[opt.name]
      end
      if RANDOMIZE_GROUPS then
        for _,group in pairs(RANDOMIZE_GROUPS) do
          if opt.randomize_group and opt.randomize_group == group then
            if opt.valuator then
              if opt.valuator == "button" then
                  PARAM[opt.name] = rand.sel(50, 1, 0)
                  goto done
              elseif opt.valuator == "slider" then
                  if opt.increment < 1 then
                    PARAM[opt.name] = rand.range(opt.min, opt.max)
                  else
                    PARAM[opt.name] = rand.irange(opt.min, opt.max)
                  end
                  goto done
              end
            else
              local index
              repeat
                index = rand.irange(1, #opt.choices)
              until (index % 2 == 1)
              PARAM[opt.name] = opt.choices[index]
              goto done
            end
          end
        end
      end
      ::done::
    else
	    if opt.valuator then
		    if opt.valuator == "button" then
		        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
		    elseif opt.valuator == "slider" then
		        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
		    end
      else
        PARAM[opt.name] = opt.value
	    end
	  end

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
  end -- for opt
end


OB_MODULES["chex3_mon_control"] =
{
  name = "chex3_mon_control",

  label = _("Chex Quest 3 Monster Control"),

  game = "chex3",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_CHEX3.monster_setup
  },

  options =
  {
     {
      name = "float_commonus",
      label = _("Commonus"),
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
      name = "float_bipedicus",
      label = _("Bipedicus"),
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
      name = "float_armored_biped",
      label = _("Armored Bipedicus"),
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
      name = "float_quadrumpus",
      label = _("Quadrumpus"),
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
      name = "float_cycloptis",
      label = _("Cycloptis"),
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
      name = "float_larva",
      label = _("Larva"),
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
      name = "float_flemmine",
      label = _("Flem Mine"),
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
      name = "float_stridicus",
      label = _("Stridicus"),
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
      name = "float_super_cyclop",
      label = _("Super Cycloptis"),
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
     }
  },
}


----------------------------------------------------------------

CTL_CHEX3.WEAPON_PREF_CHOICES =
{
  "normal",  _("Normal"),
  "vanilla", _("Vanilla"),
  "none",    _("NONE"),
}


function CTL_CHEX3.weapon_setup(self)

  for _,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          local value = tonumber(OB_CONFIG[opt.name])
          if not value then
            PARAM[opt.name] = OB_CONFIG[opt.name]
          else
            if opt.increment < 1 then
              PARAM[opt.name] = value
            else
              PARAM[opt.name] = int(value)
            end
          end
        elseif opt.valuator == "button" then
          PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
        end
      else
        PARAM[opt.name] = OB_CONFIG[opt.name]
      end
      if RANDOMIZE_GROUPS then
        for _,group in pairs(RANDOMIZE_GROUPS) do
          if opt.randomize_group and opt.randomize_group == group then
            if opt.valuator then
              if opt.valuator == "button" then
                  PARAM[opt.name] = rand.sel(50, 1, 0)
                  goto done
              elseif opt.valuator == "slider" then
                  if opt.increment < 1 then
                    PARAM[opt.name] = rand.range(opt.min, opt.max)
                  else
                    PARAM[opt.name] = rand.irange(opt.min, opt.max)
                  end
                  goto done
              end
            else
              local index
              repeat
                index = rand.irange(1, #opt.choices)
              until (index % 2 == 1)
              PARAM[opt.name] = opt.choices[index]
              goto done
            end
          end
        end
      end
      ::done::
    else
	    if opt.valuator then
		    if opt.valuator == "button" then
		        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
		    elseif opt.valuator == "slider" then
		        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
		    end
      else
        PARAM[opt.name] = opt.value
	    end
	  end

    local W = GAME.WEAPONS[string.sub(opt.name, 7)] -- Strip the float_ prefix from the weapon name for table lookup

    if W and PARAM[opt.name] ~= "Default" then
      W.add_prob = PARAM[opt.name] * 100
      W.pref     = W.add_prob * 0.28 + 1 -- Complete guesswork right now - Dasho

      -- loosen some of the normal restrictions
      W.level = 1
    end
  end -- for opt

  -- specific instructions for the weapon_pref choices
  PARAM.weapon_prefs = self.options.weapon_prefs.value

  if PARAM.weapon_prefs == "vanilla"
  or PARAM.weapon_prefs == "none" then
    for _,mon in pairs(GAME.MONSTERS) do
      mon.weapon_prefs = nil
    end
  end

  if PARAM.weapon_prefs == "vanilla" then
    GAME.MONSTERS["Flem Mine"].weap_prefs = { zorch_propulsor = 2.0 }
  end

end


OB_MODULES["chex3_weapon_control"] =
{

  name = "chex3_weapon_control",

  label = _("Chex Quest 3 Weapon Control"),

  game = "chex3",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_CHEX3.weapon_setup
  },

  options =
  {
     
     {
      name = "float_super_bootspork",
      label = _("Super Bootspork"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      randomize_group = "pickups"
     },

     {
      name = "float_large_zorcher",
      label = _("Large Zorcher"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      randomize_group = "pickups"
     },

     {
      name = "float_rapid_zorcher",
      label = _("Rapid Zorcher"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      randomize_group = "pickups"
     },

     {
      name = "float_zorch_propulsor",
      label = _("Zorch Propulsor"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      randomize_group = "pickups"
     },
	 
     {
      name = "float_phasing_zorcher",
      label = _("Phasing Zorcher"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      randomize_group = "pickups"
     },
	 
     {
      name = "float_laz_device",
      label = _("LAZ Device"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10,
      increment = .02,
      default = "Default",
      nan = "Default,", 
      presets = "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      randomize_group = "pickups"
     },

    weapon_prefs =
    {
      name="weapon_prefs",
      label=_("Weapon Preferences"),
      choices=CTL_CHEX3.WEAPON_PREF_CHOICES,
      tooltip="Alters selection of weapons that are prefered to show up depending on enemy palette for a chosen map.\n\n" ..
      "Normal: Monsters have weapon preferences. Stronger weapons and ammo are more likely to appear directly with stronger enemies.\n\n" ..
      "Vanilla: Vanilla Oblige-style preferences. Increases Zorch Propulsors if the map has more Flem Mines. \n\n" ..
      "NONE: No preferences at all. For those who like to live life dangerously with Super Cycloptises and only Super Bootsporks.",
      default="normal",
	  priority = 0,
    },
  },
}