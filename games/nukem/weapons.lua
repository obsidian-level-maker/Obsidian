NUKEM.WEAPONS =
{
  foot =
  {
    rate = 1.5,
    damage = 10,
    attack = "melee"
  },

  pistol =
  {
    pref = 5,
    rate = 4.4,
    damage = 6,
    attack = "hitscan",
    ammo = "bullet",
    per = 1
  },

  shotgun =
  {
    id = 28,
    level = 1,
    pref = 20,
    add_prob = 10,
    start_prob = 60,
    attack = "hitscan",
    rate = 1.0,
    damage = 70,
    ammo = "shell",
    per = 1,
    give = { {ammo="shell",count=10} }
  },

}
