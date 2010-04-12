----------------------------------------------------------------
--  MODULE: Stealth Monsters
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2009 Andrew Apted
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

STEALTH = { }

STEALTH.THINGS_EDGE =
{
  stealth_arach    = { id=4050, kind="monster", r=66,h=64 },
  stealth_vile     = { id=4051, kind="monster", r=20,h=56 },
  stealth_baron    = { id=4052, kind="monster", r=24,h=64 },
  stealth_caco     = { id=4053, kind="monster", r=31,h=56 },
  stealth_gunner   = { id=4054, kind="monster", r=20,h=56 },
  stealth_demon    = { id=4055, kind="monster", r=30,h=56 },
  stealth_knight   = { id=4056, kind="monster", r=24,h=64 },
  stealth_imp      = { id=4057, kind="monster", r=20,h=56 },
  stealth_mancubus = { id=4058, kind="monster", r=48,h=64 },
  stealth_revenant = { id=4059, kind="monster", r=20,h=64 },
  stealth_shooter  = { id=4060, kind="monster", r=20,h=56 },
  stealth_zombie   = { id=4061, kind="monster", r=20,h=56 },
}

STEALTH.THINGS_ZDOOM =
{
  stealth_arach    = { id=9050, kind="monster", r=66,h=64 },
  stealth_vile     = { id=9051, kind="monster", r=20,h=56 },
  stealth_baron    = { id=9052, kind="monster", r=24,h=64 },
  stealth_caco     = { id=9053, kind="monster", r=31,h=56 },
  stealth_gunner   = { id=9054, kind="monster", r=20,h=56 },
  stealth_demon    = { id=9055, kind="monster", r=30,h=56 },
  stealth_knight   = { id=9056, kind="monster", r=24,h=64 },
  stealth_imp      = { id=9057, kind="monster", r=20,h=56 },
  stealth_mancubus = { id=9058, kind="monster", r=48,h=64 },
  stealth_revenant = { id=9059, kind="monster", r=20,h=64 },
  stealth_shooter  = { id=9060, kind="monster", r=20,h=56 },
  stealth_zombie   = { id=9061, kind="monster", r=20,h=56 },
}


STEALTH.MONSTERS =
{
  -- These are mostly the same as the ones in doom.lua,
  -- but with some different crazy_prob values.

  stealth_zombie =
  {
    replaces="zombie", replace_prob=30, crazy_prob=5,
    health=20, damage=4, attack="hitscan",
    give={ {ammo="bullet",count=5} },
    invis=true, density=1.5,
  },

  stealth_shooter =
  {
    replaces="shooter", replace_prob=20, crazy_prob=11,
    health=30, damage=10, attack="hitscan",
    give={ {weapon="shotty"}, {ammo="shell",count=4} },
    invis=true,
  },

  stealth_imp =
  {
    replaces="imp", replace_prob=40, crazy_prob=25,
    health=60, damage=20, attack="missile",
    invis=true,
  },

  stealth_demon =
  {
    replaces="demon", replace_prob=40, crazy_prob=30,
    health=150, damage=25, attack="melee",
    invis=true,
  },

  stealth_caco =
  {
    replaces="caco", replace_prob=25, crazy_prob=41,
    health=400, damage=35, attack="missile",
    invis=true, float=true, density=0.5,
  },

  stealth_baron =
  {
    replaces="baron", replace_prob=20, crazy_prob=10,
    health=1000, damage=45, attack="missile",
    invis=true, density=0.5,
  },
  
  stealth_gunner =
  {
    replaces="gunner", replace_prob=20, crazy_prob=21,
    health=70, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
    invis=true,
  },

  stealth_revenant =
  {
    replaces="revenant", replace_prob=30, crazy_prob=40, skip_prob=90,
    health=300, damage=70, attack="missile",
    invis=true, density=0.6,
  },

  stealth_knight =
  {
    replaces="knight", replace_prob=25, crazy_prob=11, skip_prob=75,
    health=500, damage=45, attack="missile",
    invis=true, density=0.7,
  },

  stealth_mancubus =
  {
    replaces="mancubus", replace_prob=25, crazy_prob=31,
    health=600, damage=70, attack="missile",
    invis=true, density=0.6,
  },

  stealth_arach =
  {
    replaces="arach", replace_prob=25, crazy_prob=11,
    health=500, damage=70, attack="missile",
    invis=true, density=0.8,
  },

  stealth_vile =
  {
    replaces="vile", replace_prob=10, crazy_prob=5, skip_prob=100,
    health=700, damage=40, attack="hitscan",
    density=0.2, never_promote=true,
    invis=true,
  },
}


STEALTH.CHOICES =
{
  "normal", "Normal",
  "less",   "Less",
  "more",   "More",
}


function Stealth_Mons_setup(self)
  if OB_CONFIG.engine == "edge" then
    Game_merge_tab("things", STEALTH.THINGS_EDGE)
  else
    Game_merge_tab("things", STEALTH.THINGS_ZDOOM)
  end

  -- apply the Quantity choice
  local qty = self.options.qty.value

  for name,_ in pairs(STEALTH.MONSTERS) do
    local M = GAME.monsters[name]
    if M and qty == "less" then
      M.replace_prob = M.replace_prob / 2
      M.crazy_prob = M.crazy_prob / 3
    end
    if M and qty == "more" then
      M.replace_prob = math.max(80, M.replace_prob * 2)
      M.crazy_prob = M.crazy_prob * 3
    end
  end
end


OB_MODULES["stealth_mons"] =
{
  label = "Stealth Monsters",

  for_games   = { doom1=1, doom2=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { edge=1, zdoom=1, gzdoom=1, skulltag=1 },

  hooks =
  {
    setup = Stealth_Mons_setup,
  },

  tables =
  {
    "monsters", STEALTH.MONSTERS,
  },

  options =
  {
    qty =
    {
      label = "Default Quantity", choices = STEALTH.CHOICES,
    },
  },
}


----------------------------------------------------------------


STEALTH.CONTROL_CHOICES =
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

STEALTH.CONTROL_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}


function Stealth_MonControl_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.monsters[name]

    if M and opt.value ~= "default" then
      local prob = STEALTH.CONTROL_PROBS[opt.value]

      M.replaces = nil
      M.prob = prob
      M.crazy_prob = prob

      if prob >  80 then M.density = 1.0 ; M.skip_prob = 30 end
      if prob > 180 then M.skip_prob = 0 end
    end
  end -- for opt
end


OB_MODULES["stealth_mon_control"] =
{
  label = "Stealth Monsters : Fine Control",

  for_modules = { stealth_mons=1 },

  hooks =
  {
    setup = Stealth_MonControl_setup,
  },

  options =
  {
    stealth_zombie   = { label="Stealth Zombieman",     choices=STEALTH.CONTROL_CHOICES },
    stealth_shooter  = { label="Stealth Shotgunner",    choices=STEALTH.CONTROL_CHOICES },
    stealth_imp      = { label="Stealth Imp",           choices=STEALTH.CONTROL_CHOICES },
    stealth_demon    = { label="Stealth Demon",         choices=STEALTH.CONTROL_CHOICES },
    stealth_caco     = { label="Stealth Cacodemon",     choices=STEALTH.CONTROL_CHOICES },
    stealth_baron    = { label="Stealth Baron",         choices=STEALTH.CONTROL_CHOICES },

    stealth_gunner   = { label="Stealth Chaingunner",   choices=STEALTH.CONTROL_CHOICES },
    stealth_knight   = { label="Stealth Hell Knight",   choices=STEALTH.CONTROL_CHOICES },
    stealth_revenant = { label="Stealth Revenant",      choices=STEALTH.CONTROL_CHOICES },
    stealth_mancubus = { label="Stealth Mancubus",      choices=STEALTH.CONTROL_CHOICES },
    stealth_arach    = { label="Stealth Arachnotron",   choices=STEALTH.CONTROL_CHOICES },
    stealth_vile     = { label="Stealth Archvile",      choices=STEALTH.CONTROL_CHOICES },
  }
}

