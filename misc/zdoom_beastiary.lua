----------------------------------------------------------------
--  MODULE: ZDoom Beastiary Monsters (Realm667)
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

BEASTIARY_THINGS =
{
  afrit      = { id=3120, kind="monster", r=24,h=64 },
  defiler    = { id=9654, kind="monster", r=31,h=56 },
  satyr      = { id=3109, kind="monster", r=18,h=48 },
  stoneimp   = { id=3103, kind="monster", r=20,h=56 },
  tortsoul   = { id=3122, kind="monster", r=31,h=56 },
  mauler     = { id=3123, kind="monster", r=30,h=56 },
  plasele    = { id=3129, kind="monster", r=31,h=56 },
  zombie2    = { id=3201, kind="monster", r=20,h=56 },
  zombie3    = { id=3200, kind="monster", r=20,h=56 },
  zsec       = { id=6699, kind="monster", r=20,h=56 },
  chainsawguy ={ id=3204, kind="monster", r=20,h=56 },
  plasmaguy  = { id=3205, kind="monster", r=20,h=56 },
  rocketguy  = { id=3202, kind="monster", r=20,h=56 },
  gunner3    = { id=3311, kind="monster", r=20,h=56 },
  repeaterguy ={ id=3889, kind="monster", r=20,h=56 },
  squire     = { id=9403, kind="monster", r=20,h=56 },

  archon     = { id=30104, kind="monster", r=24,h=64 },
  chainarach = { id=12456, kind="monster", r=66,h=64 },
  cybaron    = { id=10000, kind="monster", r=24,h=64 },
  cybruiser  = { id=30128, kind="monster", r=24,h=64 },
  fusion     = { id=20000, kind="monster", r=66,h=64 },
  gunner2    = { id=30124, kind="monster", r=20,h=56 },
  inferno    = { id=30105, kind="monster", r=31,h=56 },
  nailborg   = { id=27800, kind="monster", r=20,h=56 },
  suicideguy = { id=22099, kind="monster", r=20,h=56 },

  stonedemon = { id=31999, kind="monster", r=30,h=56 },
  watcher    = { id=30126, kind="monster", r=24,h=40 },
  sambomber  = { id=10300, kind="monster", r=16,h=56 },
  sniper     = { id=30896, kind="monster", r=20,h=56 },
  fireimp    = { id=14564, kind="monster", r=20,h=56 },
  wicked     = { id=30133, kind="monster", r=25,h=88 },
  bloodfiend = { id=30100, kind="monster", r=30,h=56 },

  -- Bosses
  Moloch     = { id=6666,  kind="monster", r=50, h=120 },
  Overlord   = { id=30134, kind="monster", r=43, h=90 },
  Superdemon = { id=31269, kind="monster", r=40, h=110 },

  -- not used
  diabloist  = { id=30112, kind="monster", r=20,h=56 },
  tornado    = { id=32725, kind="monster", r=20,h=56 },
}


BEASTIARY_MONSTERS =
{
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
    density=0.35, skip_prob=100,
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
    density=0.2, skip_prob=100, never_promote=true,
  },

  watcher =
  {
    health=100, damage=20, attack="missile",
    float=true,
  },

  gunner3 =
  {
    health=90, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
  },

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
    density=0.1, skip_prob=100,
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
    density=0.4, skip_prob=100,
  },

  squire =
  {
    health=250, damage=30, attack="missile",
  },

  sniper =
  {
    health=30, damage=150, attack="missile",
    density=0.3, skip_prob=150,
  },

  sambomber =
  {
    health=20, damage=75, attack="melee",
  },

  fireimp =
  {
    health=150, damage=25, attack="missile",
  },

  wicked =
  {
    health=275, damage=35, attack="missile",
    density=0.66, float=true,
  },

  repeaterguy =
  {
    health=200, damage=70, attack="hitscan", --attack is instant like hitscan but shows BFG flash
    density=0.5,
  },

  bloodfiend =
  {
    health=250, damage=30, attack="missile",
  },

  mauler =
  {
    health=150, damage=30, attack="melee",
  },

  plasele =
  {
    health=450, damage=50, attack="missile",
    density=0.5, float=true,
  },

  -- CUSTOM BOSSES --

  -- Moloch actually has 6000 HP, but I set it to 4000 since I don't know if
  -- Oblige will place him or not due to his high HP. --Chris
  Moloch =
  {
    health=4000, damage=200, attack="missile",
    weap_prefs={ bfg=8.0, bfg10k=8.0 },
    density=0.1, skip_prob=200,
  },

  Overlord =
  {
    health=4000, damage=200, attack="missile",
    weap_prefs={ bfg=8.0, bfg10k=8.0 },
    density=0.1, skip_prob=250,
  },

  -- Uncyberneticized Cyberdemon, tosses 3 red baron fireballs but lacks
  -- splash damage the way his cybernetic counterpart does.
  Superdemon =
  {
    health=3500, damage=120, attack="missile",
    weap_prefs={ bfg=5.0, bfg10k=5.0 },
    density=0.1, skip_prob=150,
  },

}


BEASTIARY_CHOICES =
{
  "none",    "NONE",
  "scarce",  "Scarce",
  "less",    "Less",
  "plenty",  "Plenty",
  "more",    "More",
  "heaps",   "Heaps",
  "insane",  "INSANE",
}

BEASTIARY_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}


function ZDoom_Beastiary_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.monsters[name]
    local prob = BEASTIARY_PROBS[opt.value]

    if M and prob then
      M.prob = prob
      M.crazy_prob = prob

      if prob > 80 then M.skip_prob = 2000 / prob end
    end
  end -- for opt
end


OB_MODULES["zdoom_beastiary"] =
{
  label = "ZDoom Beastiary Monsters",

  for_games   = { doom1=1, doom2=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { zdoom=1, gzdoom=1, skulltag=1 },

  setup_func = ZDoom_Beastiary_setup,

  tables =
  {
    "things",    BEASTIARY_THINGS,
    "monsters",  BEASTIARY_MONSTERS,
  },

  options =
  {
    afrit      = { label="Afrit",            choices=BEASTIARY_CHOICES },
    defiler    = { label="Defiler",          choices=BEASTIARY_CHOICES },
    satyr      = { label="Satyr",            choices=BEASTIARY_CHOICES },
    stoneimp   = { label="Stone Imp",        choices=BEASTIARY_CHOICES },
    tortsoul   = { label="Tortured Soul",    choices=BEASTIARY_CHOICES },
    zombie2    = { label="Rapidfire Trooper", choices=BEASTIARY_CHOICES },
    zombie3    = { label="Zombie Marine",    choices=BEASTIARY_CHOICES },
    zsec       = { label="Zsec",             choices=BEASTIARY_CHOICES },
    chainsawguy ={ label="Chainsaw Zombie",  choices=BEASTIARY_CHOICES },
    plasmaguy  = { label="Plasma Zombie",    choices=BEASTIARY_CHOICES },
    rocketguy  = { label="Rocket Zombie",    choices=BEASTIARY_CHOICES },
    gunner3    = { label="Chaingun Major",   choices=BEASTIARY_CHOICES },
    repeaterguy ={ label="Repeater Zombie",  choices=BEASTIARY_CHOICES },
    squire     = { label="Squire",           choices=BEASTIARY_CHOICES },

    archon     = { label="Archon",           choices=BEASTIARY_CHOICES },
    chainarach = { label="Chaingun Arach",   choices=BEASTIARY_CHOICES },
    cybaron    = { label="Cybaron",          choices=BEASTIARY_CHOICES },
    cybruiser  = { label="Cybruiser",        choices=BEASTIARY_CHOICES },
    fusion     = { label="Fusion Canon Spider", choices=BEASTIARY_CHOICES },
    gunner2    = { label="Double Chaingunner", choices=BEASTIARY_CHOICES },
    inferno    = { label="Inferno",          choices=BEASTIARY_CHOICES },
    nailborg   = { label="Nailborg",         choices=BEASTIARY_CHOICES },
    suicideguy = { label="Suicider",         choices=BEASTIARY_CHOICES },
    stonedemon = { label="Stone Demon",      choices=BEASTIARY_CHOICES },
    watcher    = { label="Watcher",          choices=BEASTIARY_CHOICES },

    sambomber  = { label="Serious Sam Bomber", choices=BEASTIARY_CHOICES },
    sniper     = { label="Sniper",           choices=BEASTIARY_CHOICES },
    fireimp    = { label="Fire Imp",         choices=BEASTIARY_CHOICES },
    wicked     = { label="Wicked",           choices=BEASTIARY_CHOICES },
    bloodfiend = { label="Blood Fiend",      choices=BEASTIARY_CHOICES },
    mauler     = { label="Mauler Demon",     choices=BEASTIARY_CHOICES },
    plasele    = { label="Plasma Elemental", choices=BEASTIARY_CHOICES },

    -- Bosses
    Moloch     = { label="Moloch (BOSS)",    choices=BEASTIARY_CHOICES },
    Overlord   = { label="Overlord (BOSS)",  choices=BEASTIARY_CHOICES },
    Superdemon = { label="Superdemon (BOSS)", choices=BEASTIARY_CHOICES },
  },
}

