----------------------------------------------------------------
--  MODULE: Immoral Conduct - Special Edition
----------------------------------------------------------------
--
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

-- === NOTES ===
--
-- The Ammo in Immoral Conduct is a bit different than
-- standard DOOM, there is a couple new ones and some
-- existing ones have new meaning.  The most important are:
--
--     bullets  -> bullets
--     shells   -> shells
--     rockets  -> grenades
--     cells    -> rifle ammo
--
--     gas      -> flak shells (new)
--     nails    -> knives (new)
--     pellets  -> satchel charges (new)
--
-- (Knives and Charges are not modelled by OBLIGE).
--
-- The "Silencer" is another starting weapon, but I assume
-- it's equivalent to the pistol and hence is not modelled.
--
-- Many weapons have cool secondary attacks, often using
-- different ammo.  This is not modelled, on the assumption
-- that they are less effective than the primary attack.
--
-- For weapons that have reloading sequences when the clip
-- runs out.  This is handled by decreasing the rate by a
-- small amount (in practise the player would usually be
-- taking cover somewhere while the weapon reloads).
--

IMMORAL_CONDUCT = { }

IMMORAL_CONDUCT.ENTITIES =
{
  -- players
  player4 = { id=3000, kind="player", r=20,h=56 }

  -- pickups
  flak_shells = { id=2024, kind="pickup", r=20,h=16, pass=true }
}


IMMORAL_CONDUCT.HELPER_TYPES =
{
  none =
  {
    player2 = { id=2015, kind="pickup", r=20,h=16, pass=true }
    player3 = { id=2015, kind="pickup", r=20,h=16, pass=true }
    player4 = { id=2015, kind="pickup", r=20,h=16, pass=true }
  }

  rifle =
  {
    player2 = { id=   2, kind="player", r=20,h=16, pass=true }
    player3 = { id=   2, kind="player", r=20,h=16, pass=true }
    player4 = { id=   2, kind="player", r=20,h=16, pass=true }
  }

  m16 =
  {
    player2 = { id=   3, kind="player", r=20,h=16, pass=true }
    player3 = { id=   3, kind="player", r=20,h=16, pass=true }
    player4 = { id=   3, kind="player", r=20,h=16, pass=true }
  }

  ssg =
  {
    player2 = { id=3000, kind="player", r=20,h=16, pass=true }
    player3 = { id=3000, kind="player", r=20,h=16, pass=true }
    player4 = { id=3000, kind="player", r=20,h=16, pass=true }
  }

  random =
  {
    player2 = { id=   4, kind="player", r=20,h=16, pass=true }
    player3 = { id=   4, kind="player", r=20,h=16, pass=true }
    player4 = { id=   4, kind="player", r=20,h=16, pass=true }
  }

  -- the "mixed" choice does not change anything
  -- (hence no need to have an entry for it).
}


IMMORAL_CONDUCT.MONSTERS =
{
  uzi_trooper =
  {
    id = 3042
    r = 20
    h = 56
    health = 40
    damage = 30
    attack = "hitscan"
    give = { {weapon="launch"}, {ammo="bullet",count=20} }
    immoral_conduct = true
  }

  super_shooter =
  {
    id = 3043
    r = 20
    h = 56
    health = 50
    damage = 70
    attack = "hitscan"
    give = { {weapon="super"}, {ammo="shell",count=4} }
    density = 0.5
    immoral_conduct = true
  }

  m16_zombie =
  {
    id = 3044
    r = 20
    h = 56
    health = 100
    damage = 40
    attack = "hitscan"
    give = { {weapon="launch"}, {ammo="rocket",count=2} }
    immoral_conduct = true
  }

  chainsaw_zombie =
  {
    id = 3046
    r = 20
    h = 56
    health = 100
    damage = 40
    attack = "melee"
    give = { {weapon="saw"} }
    immoral_conduct = true
  }
}


IMMORAL_CONDUCT.WEAPONS =
{
  launch = REMOVE_ME  -- became: assault_rifle
  plasma = REMOVE_ME  -- became: sig_cow
  bfg    = REMOVE_ME  -- became: flak_shotty

  fist =  -- knife
  {
    rate = 1.0
    damage = 25
    attack = "melee"
  }

  saw =
  {
    id = 2005
    pref = 3
    add_prob = 4
    start_prob = 2
    rate = 6
    damage = 15
    attack = "melee"
  }

  pistol =
  {
    pref = 8
    rate = 4.0
    damage = 15
    attack = "hitscan"
    ammo = "bullet"
    per = 1
  }

  pistol_pair =
  {
    id = 2018
    pref = 15
    add_prob = 20
    start_prob = 40
    rate = 3.0
    damage = 30
    attack = "hitscan"
    ammo = "bullet"
    per = 2
    give = { {ammo="bullet",count=12} }
  }

  shotty =
  {
    id = 2001
    pref = 50
    add_prob = 40
    start_prob = 120
    rate = 1.0
    damage = 80
    attack = "hitscan"
    splash = { 0,10 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  -- Note: weapon upgrades (like this) are not supported yet
  flak_shotty =
  {
    id = 2006
    pref = 30
    upgrades = "shotty"
    rate = 0.9
    damage = 100
    attack = "hitscan"
    splash = { 0,50,50 }
    give = { {ammo="flak",count=24} }
  }

  super =  -- double barrel
  {
    id = 82
    add_prob = 20
    start_prob = 20
    pref = 12
    rate = 0.53
    damage = 60
    attack = "hitscan"
    splash = { 0,20 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=2} }
  }

  chain =  -- uzi
  {
    id = 2002
    pref = 25
    add_prob = 20
    start_prob = 20
    rate = 7.0
    damage = 10
    attack = "hitscan"
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=30} }
  }

  uzi_pair =
  {
    id = 2022
    pref = 30
    add_prob = 20
    start_prob = 50
    rate = 5.6
    damage = 20
    attack = "hitscan"
    ammo = "bullet"
    per = 2
    give = { {ammo="bullet",count=60} }
  }

  h_grenades =
  {
    id = 2046
    pref = 8
    add_prob = 4
    start_prob = 4
    rate = 0.7
    damage = 1
    attack = "missile"
    splash = { 60,30,10 }
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  gren_launch =
  {
    id = 17
    pref = 15
    add_prob = 20
    start_prob = 50
    rate = 1.4
    damage = 20
    attack = "missile"
    splash = { 55,40,25,10 }
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  satchel =
  {
    id = 2010
    pref = 5
    add_prob = 12
    start_prob = 10
    rate = 1.4
    damage = 1
    attack = "missile"
    splash = { 0,15,5 }
    ammo = "charge"
    per = 1
    give = { {ammo="charge",count=1} }
  }

  assault_rifle =
  {
    id = 2003
    pref = 50
    add_prob = 60
    start_prob = 60
    rate = 2.3
    damage = 54
    attack = "hitscan"
    ammo = "cell"
    per = 3
    give = { {ammo="cell",count=45} }
  }

  sig_cow =
  {
    id = 2004
    pref = 40
    add_prob = 40
    start_prob = 40
    rate = 2.6
    damage = 26
    attack = "hitscan"
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=30} }
  }

  minigun  =
  {
    id = 2999
    pref = 50
    add_prob = 30
    start_prob = 60
    rate = 8.0
    damage = 17
    attack = "hitscan"
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=100} }
  }

  sawed_off =
  {
    id = 4444
    pref = 20
    add_prob = 30
    start_prob = 40
    rate = 0.9
    damage = 80
    attack = "hitscan"
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=6} }
  }

  beretta =
  {
    id = 4445
    pref = 10
    add_prob = 30
    start_prob = 20
    rate = 2.9
    damage = 12
    attack = "hitscan"
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=30} }
  }

  revolver =
  {
    id = 4446
    pref = 10
    add_prob = 50
    start_prob = 40
    rate = 1.4
    damage = 32
    attack = "hitscan"
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=12} }
  }
}


IMMORAL_CONDUCT.PICKUPS =
{
  green_armor = REMOVE_ME  -- became: pistol_pair
  cell_box    = REMOVE_ME  -- became: gren_launch
  rocket_box  = REMOVE_ME  -- became: h_grenades
  rocket      = REMOVE_ME  -- became: satchel

  flak_shells =
  {
    prob = 20
    rank = 1
    cluster = { 2,5 }
    give = { {ammo="flak",count=4} }
  }

  -- the next two are both weapons AND pickups! --

  h_grenades =
  {
    prob = 20
    rank = 1
    cluster = { 1,2 }
    give = { {ammo="rocket",count=5} }
  }

  satchel =
  {
    prob = 20
    rank = 1
    cluster = { 1,3 }
    give = { {ammo="charge",count=1} }
  }
}


IMMORAL_CONDUCT.POWERUPS =
{
  invul = REMOVE_ME  -- became: uzi_pair
  invis = REMOVE_ME  -- became: flak_shells
}


IMMORAL_CONDUCT.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0, flak=0, charge=0,
                bullet=0, shell=0, rocket=0, cell=0 }
    weapons = { pistol=1, fist=1 }
  }
}

----------------------------------------------------------------

function IMMORAL_CONDUCT.setup(self)
  local new_mons = self.options.new_mons.value

  local NEW_MON_PROBS =
  {
    scarce=4, plenty=18, hordes=70,
  }
  local new_prob = NEW_MON_PROBS[new_mons]

  if new_prob then
    for _,M in pairs(GAME.MONSTERS) do
      if M.immoral_conduct then
        M.prob = new_prob
      end
    end
  end

  local helper = self.options.helper.value

  if IMMORAL_CONDUCT.HELPER_TYPES[helper] then
    Levels.merge_tab("things", IMMORAL_CONDUCT.HELPER_TYPES[helper])
  end
end


function IMMORAL_CONDUCT.begin_level(self)
  if not LEVEL.styles then
    LEVEL.styles = {}
  end

  -- the helpers tend to fall into liquid pools, so here we
  -- make levels with lots of liquids less likely lol.
  LEVEL.styles.liquids = { few=90, some=10, heaps=10 }
end



OB_MODULES["imm_conduct"] =
{
  label = "Immoral Conduct - Special Edition"

  game = { doom2=1 }
  playmode = { sp=1, coop=1 }
  engine = { edge=1 }

  tables =
  {
    IMMORAL_CONDUCT
  }

  hooks =
  {
    setup = IMMORAL_CONDUCT.setup
    begin_level = IMMORAL_CONDUCT.begin_level
  }

  options =
  {
    new_mons =
    {
      label = "New Monsters"

      choices =
      {
        "scarce", "Scarce",
        "plenty", "Plenty",
        "hordes", "Hordes",
        "none",   "NONE",
      }
    }

    helper =
    {
      label = "Helper Type"
      priority = 25

      choices =
      {
        "mixed",  "One of each",
        "rifle",  "Rifle Corporal",
        "ssg",    "SSG Private",
        "m16",    "M16 Sergeant",
        "random", "Random",
        "none",   "NONE",
      }
    }
  }
}

