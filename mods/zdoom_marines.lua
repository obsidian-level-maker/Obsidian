----------------------------------------------------------------
--  MODULE: ZDoom Marines
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
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

ZDOOM_MARINE_THINGS =
{
  marine_fist    = { id=9101, kind="monster", r=16,h=56 },
  marine_berserk = { id=9102, kind="monster", r=16,h=56 },
  marine_saw     = { id=9103, kind="monster", r=16,h=56 },
  marine_pistol  = { id=9104, kind="monster", r=16,h=56 },
  marine_shotty  = { id=9105, kind="monster", r=16,h=56 },
  marine_ssg     = { id=9106, kind="monster", r=16,h=56 },
  marine_chain   = { id=9107, kind="monster", r=16,h=56 },
  marine_rocket  = { id=9108, kind="monster", r=16,h=56 },
  marine_plasma  = { id=9109, kind="monster", r=16,h=56 },
  marine_rail    = { id=9110, kind="monster", r=16,h=56 },
  marine_bfg     = { id=9111, kind="monster", r=16,h=56 },
}

ZDOOM_MARINE_MONSTERS =
{
  -- None of these drop anything.

  -- The damage values below are not accurate,
  -- to keep too much health from spawning in the map.  May need more tweaking.

  -- Marines of all types (well, except the fist) are extremely dangerous,
  -- hence the low probabilities and never_promote.
  -- We want them all to be rare.

  marine_fist =
  {
    prob=1, skip_prob=200,
    health=100, damage=4, attack="melee",
    never_promote=true,
    density=0.2,
  },

  marine_berserk =
  {
    prob=6, skip_prob=100,
    health=100, damage=40, attack="melee",
    never_promote=true,
    density=0.2,
  },

  marine_saw =
  {
    prob=4, skip_prob=100,
    health=100, damage=15, attack="melee",
    never_promote=true,
    density=0.2,
  },

  marine_pistol =
  {
    prob=12, skip_prob=100,
    health=100, damage=8, attack="hitscan",
    never_promote=true,
    density=0.5,
  },

  marine_shotty =
  {
    prob=4, skip_prob=100,
    health=100, damage=10, attack="hitscan",
    never_promote=true,
    density=0.4,
  },

  marine_ssg =
  {
    prob=6, skip_prob=100,
    health=100, damage=65, attack="hitscan",
    never_promote=true,
    density=0.3,
  },

  marine_chain =
  {
    prob=6, skip_prob=100,
    health=100, damage=50, attack="hitscan",
    never_promote=true,
    density=0.3,
  },

  marine_rocket =
  {
    prob=4, crazy_prob=10, skip_prob=100,
    health=100, damage=100, attack="missile",
    never_promote=true,
    density=0.2,
  },

  marine_plasma =
  {
    prob=4, crazy_prob=6, skip_prob=100,
    health=100, damage=70, attack="missile",
    never_promote=true,
    density=0.2,
  },

  marine_rail =
  {
    prob=2, skip_prob=200,
    health=100, damage=100, attack="hitscan",
    never_promote=true,
    density=0.1,
  },

  marine_bfg =
  {
    prob=2, skip_prob=250,
    health=100, damage=100, attack="missile",
    never_promote=true,
    density=0.1,
  },
}


ZDOOM_MARINE_CHOICES =
{
  "plenty",  "Plenty",
  "scarce",  "Scarce",
  "heaps",   "Heaps",
}

ZDOOM_MARINE_FACTORS =
{
  scarce = 0.4,
  plenty = 1.0,
  heaps  = 5.0,
}


function ZDoom_Marine_setup(self)
  if not PARAM.doom2_weapons then
    GAME.monsters["marine_ssg"] = nil
  end

  local factor = ZDOOM_MARINE_FACTORS[self.options.qty.value]

  for name,_ in pairs(ZDOOM_MARINE_MONSTERS) do
    local M = GAME.monsters[name]
    if M and factor then
      M.prob = M.prob * factor
      M.crazy_prob = (M.crazy_prob or M.prob) * factor

      if OB_CONFIG.strength == "weak" then
        M.skip_prob = M.skip_prob * 2
      elseif OB_CONFIG.strength == "tough" then
        M.skip_prob = M.skip_prob * 0.75
      end
    end
  end
end


-- Monster / Weapon prefs may go here eventually

OB_MODULES["zdoom_marines"] =
{
  label = "ZDoom Marines",

  for_games   = { doom1=1, doom2=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { zdoom=1, gzdoom=1, skulltag=1 },

  hooks =
  {
    setup = ZDoom_Marine_setup,
  },

  tables =
  {
    "things",   ZDOOM_MARINE_THINGS,
    "monsters", ZDOOM_MARINE_MONSTERS,
  },

  options =
  {
    qty =
    {
      label = "Default Quantity", choices = ZDOOM_MARINE_CHOICES,
    },
  },
}


----------------------------------------------------------------


MARINE_CONTROL_CHOICES =
{
  "default", "DEFAULT",
  "none",    "None at all",
  "scarce",  "Scarce",
  "less",    "Less",
  "plenty",  "Plenty",
  "more",    "More",
  "heaps",   "Heaps",
  "insane",  "INSANE",
}

-- these probabilities are lower than in the Monster Control module
-- because these dudes really pack a punch.

MARINE_CONTROL_PROBS =
{
  none   = 0,
  scarce = 1,
  less   = 4,
  plenty = 20,
  more   = 70,
  heaps  = 200,
  insane = 1000,
}


function Marine_Control_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.monsters[name]

    if M and opt.value ~= "default" then
      local prob = MARINE_CONTROL_PROBS[opt.value]

      M.prob = prob
      M.crazy_prob = prob

      if prob >  50 then M.density = 0.5 ; M.skip_prob = 30 end
      if prob > 150 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["zdoom_marine_control"] =
{
  label = "ZDoom Marines : Fine Control",

  for_modules = { zdoom_marines=1 },

  hooks =
  {
    setup = Marine_Control_setup,
  },

  options =
  {
    marine_fist      = { label="Fist Marine",        choices=MARINE_CONTROL_CHOICES },
    marine_berserk   = { label="Berserk Marine",     choices=MARINE_CONTROL_CHOICES },
    marine_saw       = { label="Chainsaw Marine",    choices=MARINE_CONTROL_CHOICES },
    marine_pistol    = { label="Pistol Marine",      choices=MARINE_CONTROL_CHOICES },
    marine_shotty    = { label="Shotgun Marine",     choices=MARINE_CONTROL_CHOICES },
    marine_ssg       = { label="Super Shotgunner",   choices=MARINE_CONTROL_CHOICES },
    marine_chain     = { label="Chaingun Marine",    choices=MARINE_CONTROL_CHOICES },
    marine_rocket    = { label="Rocket Marine",      choices=MARINE_CONTROL_CHOICES },
    marine_plasma    = { label="Plasma Marine",      choices=MARINE_CONTROL_CHOICES },
    marine_rail      = { label="Railgun Marine",     choices=MARINE_CONTROL_CHOICES },
    marine_bfg       = { label="BFG 9000 Marine",    choices=MARINE_CONTROL_CHOICES },
  }
}

