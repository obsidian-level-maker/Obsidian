CHEX1.MONSTERS =
{
  commonus =
  {
    id = 3004,
    r = 20,
    h = 56,
    prob = 60,
    health = 20,
    attack = "melee",
    damage = 4
  },

  bipedicus =
  {
    id = 9,
    r = 20,
    h = 56,
    prob = 45,
    health = 30,
    attack = "melee",
    damage = 10
  },

  armored_biped =
  {
    id = 3001,
    r = 20,
    h = 56,
    prob = 35,
    crazy_prob = 65,
    health = 60,
    attack = "missile",
    damage = 20
  },

  quadrumpus =
  {
    id = 9057,
    r = 20,
    h = 56,
    -- replaces = "armored_biped"
    -- replace_prob = 30
    prob = 35,
    crazy_prob = 25,
    health = 60,
    attack = "missile",
    damage = 20,
  },

  cycloptis =
  {
    id = 58, 
    r = 30,
    h = 56,
    prob = 30,
    health = 150,
    attack = "melee",
    damage = 25,
    weap_prefs = { zorch_propulsor=0.5 }
  },

  larva =
  {
    id = 9050,
    r = 30,
    h = 56,
    --- replaces = "cycloptis"
    --- replace_prob = 25
    prob = 30,
    crazy_prob = 25,
    health = 125,
    attack = "melee",
    damage = 25,
    weap_prefs = { zorch_propulsor=0.5 }
  },

  flemmine =
  {
    id = 3006,
    r = 16,
    h = 56,
    prob = 20,
    health = 100,
    attack = "melee",
    damage = 7,
    density = 0.7,
    float = true
  },

  stridicus =
  {
    id = 3002,
    r = 30,
    h = 56,
    prob = 20,
    health = 225,
    attack = "melee",
    damage = 25,
    density = 0.7
  },

  super_cyclop =
  {
    id = 3005,
    r = 31,
    h = 56,
    prob = 30,
    health = 400,
    attack = "missile",
    damage = 35,
    density = 0.5,
    float = true
  }
}
