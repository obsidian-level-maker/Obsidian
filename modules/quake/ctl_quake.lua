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
  "default", _("DEFAULT"),
  "none",    _("None at all"),
  "scarce",  _("Scarce"),
  "less",    _("Less"),
  "plenty",  _("Plenty"),
  "more",    _("More"),
  "heaps",   _("Heaps"),
  "insane",  _("INSANE"),
}

CTL_QUAKE.MON_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000
}

CTL_QUAKE.DENSITIES =
{
  none   = 0.1,
  scarce = 0.2,
  less   = 0.4,
  plenty = 0.7,
  more   = 1.2,
  heaps  = 3.3,
  insane = 9.9
}


function CTL_QUAKE.monster_setup(self)
  for name,opt in pairs(self.options) do
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

    local M = GAME.MONSTERS[name]

    if M and PARAM[opt.name] ~= "default" then
      M.prob    = CTL_QUAKE.MON_PROBS[PARAM[opt.name]]
      M.density = CTL_QUAKE.DENSITIES[PARAM[opt.name]]

      -- allow Rottweilers to be controlled individually
      M.replaces = nil

      -- loosen some of the normal restrictions
      M.level = 1
      M.skip_prob = nil
      M.crazy_prob = nil
    end
  end -- for opt
end


OB_MODULES["quake_mon_control"] =
{
  label = _("Quake Monster Control"),

  game = "quake",

  hooks =
  {
    setup = CTL_QUAKE.monster_setup
  },

  options =
  {
    dog      = { label="Rottweiler", choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    fish     = { label="Rotfish",    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    grunt    = { label="Grunt",      choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    enforcer = { label="Enforcer",   choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    zombie   = { label="Zombie",     choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },

    knight   = { label="Knight",     choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    scrag    = { label="Scrag",      choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    tarbaby  = { label="Spawn",      choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    ogre     = { label="Ogre",       choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    fiend    = { label="Fiend",      choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },

    dth_knight = { label="Death Knight", choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    Vore       = { label="Vore",      choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    Shambler   = { label="Schambler", choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" }
  }
}


----------------------------------------------------------------


CTL_QUAKE.WEAPON_CHOICES =
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

CTL_QUAKE.WEAPON_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  loveit = 1000
}

CTL_QUAKE.WEAPON_PREFS =
{
  none   = 1,
  scarce = 10,
  less   = 25,
  plenty = 40,
  more   = 70,
  heaps  = 100,
  loveit = 170
}


function CTL_QUAKE.weapon_setup(self)
  for name,opt in pairs(self.options) do
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

    local W = GAME.WEAPONS[name]

    if W and opt.value ~= "default" then
      W.add_prob = CTL_QUAKE.WEAPON_PROBS[opt.value]
      W.pref     = CTL_QUAKE.WEAPON_PREFS[opt.value]

      -- loosen some of the normal restrictions
      W.level = 1
    end
  end -- for opt
end


OB_MODULES["quake_weapon_control"] =
{
  label = _("Quake Weapon Control"),

  game = "quake",

  hooks =
  {
    setup = CTL_QUAKE.weapon_setup
  },

  options =
  {
    ssg      = { label="Double Shotgun",   choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    nailgun  = { label="Nailgun",          choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    nailgun2 = { label="Perforator",       choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    grenade  = { label="Grenade Launcher", choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    rocket   = { label="Rocket Launcher",  choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups"},
    zapper   = { label="Thunderbolt",      choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" }
  }
}

