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
  chainsawer = { id=3204, kind="monster", r=20,h=56 },
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
  suicider   = { id=22099, kind="monster", r=20,h=56 },
  tornado    = { id=32725, kind="monster", r=20,h=56 },
  stonedemon = { id=31999, kind="monster", r=30,h=56 },
}

BESTIARY_MONSTERS =
{
  -- FIXME !!!!  grab proper stats

  afrit      = { health=100, damage=50, attack="hitscan" },
  defiler    = { health=100, damage=50, attack="hitscan" },
  satyr      = { health=100, damage=50, attack="hitscan" },
  stoneimp   = { health=100, damage=50, attack="hitscan" },
  tortsoul   = { health=100, damage=50, attack="hitscan" },
  zombie2    = { health=100, damage=50, attack="hitscan" },
  zombie3    = { health=100, damage=50, attack="hitscan" },
  zsec       = { health=100, damage=50, attack="hitscan" },
  chainsawer = { health=100, damage=50, attack="hitscan" },
  plasmaguy  = { health=100, damage=50, attack="hitscan" },
  rocketguy  = { health=100, damage=50, attack="hitscan" },

  archon     = { health=100, damage=50, attack="hitscan" },
  chainarach = { health=100, damage=50, attack="hitscan" },
  cybaron    = { health=100, damage=50, attack="hitscan" },
  cybruiser  = { health=100, damage=50, attack="hitscan" },
  diabloist  = { health=100, damage=50, attack="hitscan" },
  fusion     = { health=100, damage=50, attack="hitscan" },
  gunner2    = { health=100, damage=50, attack="hitscan" },
  inferno    = { health=100, damage=50, attack="hitscan" },
  nailborg   = { health=100, damage=50, attack="hitscan" },
  suicider   = { health=100, damage=50, attack="hitscan" },
  tornado    = { health=100, damage=50, attack="hitscan" },
  stonedemon = { health=100, damage=50, attack="hitscan" },
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

    afrit      = { label="afrit",      choices=BESTIARY_CHOICES },
    defiler    = { label="defiler",    choices=BESTIARY_CHOICES },
    satyr      = { label="satyr",      choices=BESTIARY_CHOICES },
    stoneimp   = { label="stoneimp",   choices=BESTIARY_CHOICES },
    tortsoul   = { label="tortsoul",   choices=BESTIARY_CHOICES },
    zombie2    = { label="zombie2",    choices=BESTIARY_CHOICES },
    zombie3    = { label="zombie3",    choices=BESTIARY_CHOICES },
    zsec       = { label="zsec",       choices=BESTIARY_CHOICES },
    chainsawer = { label="chainsawer", choices=BESTIARY_CHOICES },
    plasmaguy  = { label="plasmaguy",  choices=BESTIARY_CHOICES },
    rocketguy  = { label="rocketguy",  choices=BESTIARY_CHOICES },
                                
    archon     = { label="archon",     choices=BESTIARY_CHOICES },
    chainarach = { label="chainarach", choices=BESTIARY_CHOICES },
    cybaron    = { label="cybaron",    choices=BESTIARY_CHOICES },
    cybruiser  = { label="cybruiser",  choices=BESTIARY_CHOICES },
    diabloist  = { label="diabloist",  choices=BESTIARY_CHOICES },
    fusion     = { label="fusion",     choices=BESTIARY_CHOICES },
    gunner2    = { label="gunner2",    choices=BESTIARY_CHOICES },
    inferno    = { label="inferno",    choices=BESTIARY_CHOICES },
    nailborg   = { label="nailborg",   choices=BESTIARY_CHOICES },
    suicider   = { label="suicider",   choices=BESTIARY_CHOICES },
    tornado    = { label="tornado",    choices=BESTIARY_CHOICES },
    stonedemon = { label="stonedemon", choices=BESTIARY_CHOICES },
  },
}

