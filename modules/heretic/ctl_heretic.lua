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

  for _,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          if opt.increment < 1 then
            PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
          else
            PARAM[opt.name] = int(tonumber(OB_CONFIG[opt.name]))
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
     float_gargoyle=
     {
      label = _("Gargoyle"),
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

     float_fire_garg=
     {
      label = _("Fire Gargoyle"),
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

     float_warrior=
     {
      label = _("Warrior"),
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

     float_warrior_ghost=
     {
      label = _("Warrior Ghost"),
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

     float_golem=
     {
      label = _("Golem"),
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

     float_golem_ghost=
     {
      label = _("Golem Ghost"),
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

     float_nitro=
     {
      label = _("Nitro"),
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

     float_nitro_ghost=
     {
      label = _("Nitro Ghost"),
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

     float_disciple=
     {
      label = _("Disciple"),
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

     float_sabreclaw=
     {
      label = _("Sabreclaw"),
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

     float_weredragon=
     {
      label = _("Weredragon"),
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

     float_ophidian=
     {
      label = _("Ophidian"),
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

     float_Ironlich=
     {
      label = _("Ironlich"),
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

     float_Maulotaur=
     {
      label = _("Maulotaur"),
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

     float_D_Sparil=
     {
      label = _("D'Sparil"),
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
  }
}


----------------------------------------------------------------

function CTL_HERETIC.weapon_setup(self)

  for _,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          if opt.increment < 1 then
            PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
          else
            PARAM[opt.name] = int(tonumber(OB_CONFIG[opt.name]))
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
     float_gauntlets=
     {
      label = _("Gauntlets"),
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
     
     float_crossbow=
     {
      label = _("Crossbow"),
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
     
     float_claw=
     {
      label = _("Dragon Claw"),
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

     float_hellstaff=
     {
      label = _("Hellstaff"),
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
     
     float_phoenix=
     {
      label = _("Phoenix Rod"),
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

     float_firemace=
     {
      label = _("Fire Mace"),
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
     }
  }
}

