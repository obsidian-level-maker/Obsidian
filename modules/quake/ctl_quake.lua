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

  module_param_up(self)

  for name,opt in pairs(self.options) do

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
  end

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
    { name = "dog", 
    label=_("Rottweiler"), 
    tooltip=_("Control the amount of Rottweilers."), 
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "fish", 
    label=_("Rotfish"), 
    tooltip=_("Control the amount of Rotfish."),   
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "grunt", 
    label=_("Grunt"), 
    tooltip=_("Control the amount of Grunts."),      
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "enforcer", 
    label=_("Enforcer"), 
    tooltip=_("Control the amount of Enforcers."),  
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "zombie", 
    label=_("Zombie"), 
    tooltip=_("Control the amount of Zombies."),    
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },

    { name = "knight", 
    label=_("Knight"), 
    tooltip=_("Control the amount of Knights."),    
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "scrag", 
    label=_("Scrag"), 
    tooltip=_("Control the amount of Scrags."),     
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "tarbaby", 
    label=_("Spawn"), 
    tooltip=_("Control the amount of Spawns."),     
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "ogre", 
    label=_("Ogre"), 
    tooltip=_("Control the amount of Ogres."),      
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "fiend", 
    label=_("Fiend"), 
    tooltip=_("Control the amount of Fiends."),    
     choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },

    { name = "dth_knight", 
    label=_("Death Knight"), 
    tooltip=_("Control the amount of Death Knights."), 
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "vore", 
    label=_("Vore"), 
    tooltip=_("Control the amount of Vores."),      
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" },
    { name = "shambler", 
    label=_("Shambler"), 
    tooltip=_("Control the amount of Shamblers."), 
    choices=CTL_QUAKE.MON_CHOICES, randomize_group = "monsters" }
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

  module_param_up(self)

  for name,opt in pairs(self.options) do

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
  engine = "idtech_2",

  hooks =
  {
    setup = CTL_QUAKE.weapon_setup
  },

  options =
  {
    { name = "ssg", 
    label=_("Double Shotgun"), 
    tooltip=_("Control the amount of Double Shotguns."),  
    choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    { name = "nailgun", 
    label=_("Nailgun"), 
    tooltip=_("Control the amount of Nailguns."),         
    choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    { name = "nailgun2", 
    label=_("Perforator"), 
    tooltip=_("Control the amount of Perforators."),      
    choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    { name = "grenade", 
    label=_("Grenade Launcher"), 
    tooltip=_("Control the amount of Grenade Launchers."), 
    choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" },
    { name = "rocket", 
    label=_("Rocket Launcher"), 
    tooltip=_("Control the amount of Rocket Launchers."), 
    choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups"},
    { name = "zapper", 
    label=_("Thunderbolt"), 
    tooltip=_("Control the amount of Thunderbolts."),     
    choices=CTL_QUAKE.WEAPON_CHOICES, randomize_group = "pickups" }
  }
}

