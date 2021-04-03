HACX.MONSTERS =
{
  thug =
  {
    id = 3004,
    r = 21,
    h = 72,
    level = 1,
    prob = 60,
    health = 60,
    damage = 5,
    attack = "hitscan"
  },

  android =
  {
    id = 9,
    r = 21,
    h = 70,
    level = 2,
    prob = 50,
    health = 75,
    damage = 10,
    attack = "hitscan"
  },

  stealth =
  {
    id = 58,
    r = 32,
    h = 68,
    level = 1,
    prob = 5,
    health = 30,
    damage = 25,
    attack = "melee",
    float = true,
    invis = true,
    density = 0.25
  },

  -- this thing just blows up on contact
  roam_mine =
  {
    id = 84,
    r = 5,
    h = 32,
    level = 1,
    prob = 12,
    health = 50,
    damage = 5,
    attack = "hitscan",
    float = true,
    density = 0.5
  },

  phage =
  {
    id = 67,
    r = 25,
    h = 96,
    level = 3,
    prob = 40,
    health = 150,
    damage = 70,
    attack = "missile"
  },

  buzzer =
  {
    id = 3002,
    r = 25,
    h = 68,
    level = 3,
    prob = 25,
    health = 175,
    damage = 25,
    attack = "melee",
    float = true
  },

  i_c_e =
  {
    id = 3001,
    r = 32,
    h = 56,
    level = 4,
    prob = 10,
    health = 225,
    damage = 7,
    attack = "melee"
  },

  d_man =
  {
    id = 3006,
    r = 48,
    h = 78,
    level = 4,
    prob = 10,
    health = 250,
    damage = 7,
    attack = "melee",
    float = true
  },

  monstruct =
  {
    id = 65,
    r = 35,
    h = 88,
    level = 5,
    prob = 50,
    health = 400,
    damage = 80,
    attack = "missile"
  },

  majong7 =
  {
    id = 71,
    r = 31,
    h = 56,
    level = 5,
    prob = 10,
    health = 400,
    damage = 20,
    attack = "missile",
    density = 0.5,
    weap_prefs = { launch=0.2 }
  },

  terminatrix =
  {
    id = 3003,
    r = 32,
    h = 80,
    level = 6,
    prob = 25,
    health = 450,
    damage = 40,
    attack = "hitscan",
    density = 0.8
  },

  thorn =
  {
    id = 68,
    r = 66,
    h = 96,
    level = 7,
    prob = 25,
    health = 600,
    damage = 70,
    attack = "missile"
  },

  mecha =
  {
    id = 69,
    r = 24,
    h = 96,
    level = 8,
    prob = 10,
    health = 800,
    damage = 150,
    attack = "missile",
    density = 0.2
  }
}
