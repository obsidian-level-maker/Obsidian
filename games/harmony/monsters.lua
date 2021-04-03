HARMONY.MONSTERS =
{
  -- FIXME: heaps of guesswork here

  -- FIXME: falling = { id=64, r=20, h=56 }

  beastling =
  {
    id = 3004,
    r = 20,
    h = 56,
    level = 1,
    prob = 35,
    health = 150,
    attack = "melee",
    damage = 25
  },

  critter =
  {
    id = 3003,
    r = 24,
    h = 24,
    level = 4,
    prob = 15,
    health = 100,
    attack = "melee",
    damage = 15
  },

  follower =
  {
    id = 9,
    r = 20,
    h = 56,
    level = 1,
    prob = 50,
    health = 30,
    attack = "hitscan",
    damage = 10,
--??  give = { {weapon="shotgun"}, {ammo="shell",count=4} }
  },

  predator =
  {
    id = 66,
    r = 20,
    h = 56,
    level = 2,
    prob = 60,
    health = 60,
    attack = "missile",
    damage = 20
  },

  centaur =
  {
    id = 16,
    r = 40,
    h = 112,
    level = 5,
    prob = 60,
    skip_prob = 90,
    crazy_prob = 40,
    health = 500,
    attack = "missile",
    damage = 45,
    density = 0.7
  },

  mutant =
  {
    id = 65,
    r = 20,
    h = 56,
    level = 3,
    prob = 20,
    health = 70,
    attack = "hitscan",
    damage = 50
--??  give = { {weapon="minigun"}, {ammo="bullet",count=10} }
  },

  phage =
  {
    id = 68,
    r = 48,
    h = 64,
    level = 6,
    prob = 25,
    health = 500,
    attack = "missile",
    damage = 70,
    density = 0.8
  },


  --- BOSS ---

  echidna =
  {
    id = 7,
    r = 128,
    h = 112,
    level = 9,
    prob = 20,
    crazy_prob = 18,
    skip_prob = 150,
    health = 3000,
    attack = "hitscan",
    damage = 70,
    density = 0.2
  }
}
