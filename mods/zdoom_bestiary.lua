----------------------------------------------------------------
--  MODULE: ZDoom Bestiary Monsters
----------------------------------------------------------------
--
--  Copyright (C) 2009 Chris Pisarczyk
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

BESTIARY_THINGS =
{
  afrit      = { id=3120, kind="monster", r=24,h=64 },
  defiler    = { id=9654, kind="monster", r=31,h=56 },
  satyr      = { id=3109, kind="monster", r=18,h=48 },
  stoneimp   = { id=3103, kind="monster", r=20,h=56 },
  tortsoul   = { id=3122, kind="monster", r=31,h=56 },
  zombie2    = { id=3201, kind="monster", r=20,h=56 },
  zombie3    = { id=3200, kind="monster", r=20,h=56 },
  zsec       = { id=6699, kind="monster", r=20,h=56 },
  chainsawguy ={ id=3204, kind="monster", r=20,h=56 },
  plasmaguy  = { id=3205, kind="monster", r=20,h=56 },
  rocketguy  = { id=3202, kind="monster", r=20,h=56 },

  archon     = { id=30104, kind="monster", r=24,h=64 },
  chainarach = { id=12456, kind="monster", r=66,h=64 },
  cybaron    = { id=10000, kind="monster", r=24,h=64 },
  cybruiser  = { id=30128, kind="monster", r=24,h=64 },
  diabloist  = { id=30112, kind="monster", r=20,h=56 },
  fusion     = { id=20000, kind="monster", r=66,h=64 },
  gunner2    = { id=30124, kind="monster", r=20,h=56 },
  inferno    = { id=30105, kind="monster", r=31,h=56 },
  nailborg   = { id=27800, kind="monster", r=20,h=56 },
  suicideguy = { id=22099, kind="monster", r=20,h=56 },
  tornado    = { id=32725, kind="monster", r=20,h=56 },
  stonedemon = { id=31999, kind="monster", r=30,h=56 },
}


BESTIARY_MONSTERS =
{
  -- FIXME: grab proper stats
  diabloist  = { health=100, damage=50, attack="hitscan" },
  tornado    = { health=100, damage=50, attack="hitscan" },

  zombie2 =
  {
    health=30, damage=10, attack="hitscan",
    give={ {ammo="bullet",count=5} },
  },

  zombie3 =
  {
    health=50, damage=20, attack="hitscan",
    give={ {ammo="bullet",count=10} },
  },

  zsec =
  {
    health=100, damage=35, attack="hitscan",
    give={ {ammo="bullet",count=5} },
  },

  stoneimp =
  {
    health=150, damage=40, attack="melee",
  },

  stonedemon =
  {
    health=400, damage=40, attack="missile",
  },

  suicideguy =
  {
    health=50, damage=75, attack="melee",
  },

  chainsawguy =
  {
    health=50, damage=35, attack="melee",
  },

  rocketguy =
  {
    health=40, damage=100, attack="missile",
    give={ {weapon="launch"}, {ammo="rocket",count=1} },
  },

  plasmaguy =
  {
    health=40, damage=60, attack="missile",
    give={ {weapon="plasma"}, {ammo="cell",count=20} },
  },

  cybaron =
  {
    health=1200, damage=85, attack="missile",
    weap_prefs={ bfg=1.2, bfg10k=1.2 },
    density=0.35,
  },

  nailborg =
  {
    health=180, damage=45, attack="missile", density=0.6,
  },

  satyr =
  {
    health=400, damage=65, attack="melee",
  },

  afrit =
  {
    health=800, damage=50, attack="missile", float=true, density=0.5
  },

  archon =
  {
    health=1500, damage=120, attack="missile",
    weap_prefs={ bfg=3.0, bfg10k=2.0 },
    density=0.2, never_promote=true,
  },

-- FIXME
--  watcher =
--  {
--    health=100, damage=20, attack="missile",
--    float=true,
--  },

-- FIXME
--  gunner3 =
--  {
--    health=90, damage=50, attack="hitscan",
--    give={ {weapon="chain"}, {ammo="bullet",count=10} },
--  },

  ----------------------------------------

  gunner2 =
  {
    health=100, damage=70, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
    density=0.6,
  },

  inferno =
  {
    health=400, damage=50, attack="missile",
    float=true, never_promote=true,
    density=0.4,
  },

  tortsoul =
  {
    health=700, damage=50, attack="missile",
    float=true, never_promote=true,
    density=0.3,
  },

  defiler =
  {
    health=1000, damage=60, attack="missile",
    float=true, never_promote=true,
    density=0.1,
  },

  fusion =
  {
    health=500, damage=70, attack="missile",
  },

  chainarach =
  {
    health=500, damage=40, attack="hitscan",
  },

  cybruiser =
  {
    health=1500, damage=70, attack="missile",
    weap_prefs={ bfg=1.2, bfg10k=1.2 },
    density=0.4,
  },

-- FIXME
--  squire =
--  {
--    health=250, damage=30, attack="missile",
--  },
}


BESTIARY_CHOICES =
{
  "none",    "NONE",
  "scarce",  "Scarce",
  "less",    "Less",
  "plenty",  "Plenty",
  "more",    "More",
  "heaps",   "Heaps",
  "insane",  "OH LORD!",
}

BESTIARY_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}


function Bestiary_Setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.monsters[name]
    local prob = MON_CONTROL_PROBS[opt.value]

    if M and prob then
      M.prob = prob
      M.crazy_prob = prob
    end
  end -- for opt
end


OB_MODULES["zdoom_bestiary"] =
{
  label = "ZDoom Bestiary Monsters",

  for_games   = { doom1=1, doom2=1, freedoom=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { zdoom=1, gzdoom=1, skulltag=1 },

  setup_func = Bestiary_Setup,

  tables =
  {
    "things",    BESTIARY_THINGS,
    "monsters",  BESTIARY_MONSTERS,
  },

  options =
  {
    -- FIXME !!!  grab their full names

    afrit      = { label="Afrit",            choices=BESTIARY_CHOICES },
    defiler    = { label="Defiler",          choices=BESTIARY_CHOICES },
    satyr      = { label="Satyr",            choices=BESTIARY_CHOICES },
    stoneimp   = { label="Stoneimp",         choices=BESTIARY_CHOICES },
    tortsoul   = { label="Tortsoul",         choices=BESTIARY_CHOICES },
    zombie2    = { label="Zombie2",          choices=BESTIARY_CHOICES },
    zombie3    = { label="Zombie3",          choices=BESTIARY_CHOICES },
    zsec       = { label="Zsec",             choices=BESTIARY_CHOICES },
    chainsawguy ={ label="Chainsaw guy",     choices=BESTIARY_CHOICES },
    plasmaguy  = { label="Plasma guy",       choices=BESTIARY_CHOICES },
    rocketguy  = { label="Rocket guy",       choices=BESTIARY_CHOICES },

    archon     = { label="Archon",           choices=BESTIARY_CHOICES },
    chainarach = { label="Chainarach",       choices=BESTIARY_CHOICES },
    cybaron    = { label="Cybaron",          choices=BESTIARY_CHOICES },
    cybruiser  = { label="Cybruiser",        choices=BESTIARY_CHOICES },
    diabloist  = { label="Diabloist",        choices=BESTIARY_CHOICES },
    fusion     = { label="Fusion",           choices=BESTIARY_CHOICES },
    gunner2    = { label="Gunner2",          choices=BESTIARY_CHOICES },
    inferno    = { label="Inferno",          choices=BESTIARY_CHOICES },
    nailborg   = { label="Nailborg",         choices=BESTIARY_CHOICES },
    suicideguy = { label="Suicider",         choices=BESTIARY_CHOICES },
    tornado    = { label="Tornado",          choices=BESTIARY_CHOICES },
    stonedemon = { label="Stonedemon",       choices=BESTIARY_CHOICES },
  },
}

