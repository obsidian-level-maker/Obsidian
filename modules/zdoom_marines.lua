----------------------------------------------------------------
--  MODULE: ZDoom Marines
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
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

ZDOOM_MARINE = { }

ZDOOM_MARINE.MONSTERS =
{
  -- None of these drop anything.

  -- The damage values below are not accurate,
  -- to keep too much health from spawning in the map.  May need more tweaking.

  -- Marines of all types (well, except the fist) are extremely dangerous,
  -- hence the low probabilities, low densities and nasty flag.
  -- We want them all to be rare.

  marine_fist =
  {
    id = 9101,
    r = 16,
    h = 56,
    prob = 1,
    health = 100,
    damage = 4,
    attack = "melee",
    nasty = true,
    density = 0.2,
  },

  marine_berserk =
  {
    id = 9102,
    r = 16,
    h = 56,
    prob = 6,
    health = 100,
    damage = 40,
    attack = "melee",
    nasty = true,
    density = 0.2,
  },

  marine_saw =
  {
    id = 9103,
    r = 16,
    h = 56,
    prob = 4,
    health = 100,
    damage = 15,
    attack = "melee",
    nasty = true,
    density = 0.2,
  },

  marine_pistol =
  {
    id = 9104,
    r = 16,
    h = 56,
    prob = 12,
    health = 100,
    damage = 8,
    attack = "hitscan",
    nasty = true,
    density = 0.5,
  },

  marine_shotty =
  {
    id = 9105,
    r = 16,
    h = 56,
    prob = 4,
    health = 100,
    damage = 10,
    attack = "hitscan",
    nasty = true,
    density = 0.4,
  },

  marine_ssg =
  {
    id = 9106,
    r = 16,
    h = 56,
    prob = 6,
    health = 100,
    damage = 65,
    attack = "hitscan",
    nasty = true,
    density = 0.3,
  },

  marine_chain =
  {
    id = 9107,
    r = 16,
    h = 56,
    prob = 6,
    health = 100,
    damage = 50,
    attack = "hitscan",
    nasty = true,
    density = 0.3,
  },

  marine_rocket =
  {
    id = 9108,
    r = 16,
    h = 56,
    prob = 4,
    crazy_prob = 10,
    health = 100,
    damage = 100,
    attack = "missile",
    nasty = true,
    density = 0.2,
  },

  marine_plasma =
  {
    id = 9109,
    r = 16,
    h = 56,
    prob = 4,
    crazy_prob = 6,
    health = 100,
    damage = 70,
    attack = "missile",
    nasty = true,
    density = 0.2,
  },

  marine_rail =
  {
    id = 9110,
    r = 16,
    h = 56,
    prob = 2,
    health = 100,
    damage = 100,
    attack = "hitscan",
    nasty = true,
    density = 0.1,
  },

  marine_bfg =
  {
    id = 9111,
    r = 16,
    h = 56,
    prob = 2,
    health = 100,
    damage = 100,
    attack = "missile",
    nasty = true,
    density = 0.1,
  },
}


ZDOOM_MARINE.CHOICES =
{
  "plenty", _("Plenty"),
  "scarce", _("Scarce"),
  "heaps",  _("Heaps"),
}

ZDOOM_MARINE.FACTORS =
{
  scarce = 0.4,
  plenty = 1.0,
  heaps  = 2.5,
}


function ZDOOM_MARINE.setup(self)

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

    if not PARAM.doom2_weapons then
      GAME.MONSTERS["marine_ssg"] = nil
    end

    local factor = ZDOOM_MARINE.FACTORS[PARAM[opt.name]]

    for name,_ in pairs(ZDOOM_MARINE.MONSTERS) do
      local M = GAME.MONSTERS[name]

      if M and factor then
        M.prob = M.prob * factor
        M.crazy_prob = (M.crazy_prob or M.prob) * factor
      end
    end
  end
end


-- Monster / Weapon prefs may go here eventually

OB_MODULES["zdoom_marines"] =
{
  label = _("ZDoom Marines"),

  game = "doomish",

  engine = "zdoom",

  tables =
  {
    ZDOOM_MARINE
  },

  hooks =
  {
    setup = ZDOOM_MARINE.setup
  },

  options =
  {
    qty =
    {
      name = "qty",
      label = _("Default Quantity"),
      choices = ZDOOM_MARINE.CHOICES,
      randomize_group = "monsters"
    },
  },
}


----------------------------------------------------------------


ZDOOM_MARINE.CTL_CHOICES =
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

-- these probabilities are lower than in the Monster Control module
-- because these dudes really pack a punch.

ZDOOM_MARINE.CTL_PROBS =
{
  none   = 0,
  scarce = 1,
  less   = 4,
  plenty = 20,
  more   = 70,
  heaps  = 200,
  insane = 1000,
}


function ZDOOM_MARINE.control_setup(self)
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

    if M and opt.value ~= "default" then
      local prob = ZDOOM_MARINE.CTL_PROBS[opt.value]

      M.prob = prob
      M.crazy_prob = prob

      if prob >  50 then M.density = 0.5 end
      if prob > 150 then M.density = 1.0 end
    end
  end -- for opt
end


OB_MODULES["zdoom_marine_control"] =
{
  label = _("ZDoom Marines : Control"),

  module = "zdoom_marines",
  hooks =
  {
    setup = ZDOOM_MARINE.control_setup
  },

  options =
  {
    marine_fist      = { label="Fist Marine",        choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_berserk   = { label="Berserk Marine",     choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_saw       = { label="Chainsaw Marine",    choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_pistol    = { label="Pistol Marine",      choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_shotty    = { label="Shotgun Marine",     choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_ssg       = { label="SSG Marine",         choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_chain     = { label="Chaingun Marine",    choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_rocket    = { label="Rocket Marine",      choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_plasma    = { label="Plasma Marine",      choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_rail      = { label="Railgun Marine",     choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
    marine_bfg       = { label="BFG Marine",         choices=ZDOOM_MARINE.CTL_CHOICES, randomize_group = "monsters" },
  },
}

