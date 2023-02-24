PREFABS.Trap_closet_tech =
{
  file = "trap/gtd_trap_tech.wad",
  map = "MAP01",

  kind = "trap",

  prob = 25,

  theme = "tech",
  env = "!cave",

  where  = "seeds",
  shape  = "U",

  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  x_fit = { 56,72 , 184,200 },
  y_fit = { 24,120 },

  bound_z1 = 0,
  bound_z2 = 128,

  tag_1 = "?trap_tag",
}

PREFABS.Trap_closet_tech_2 =
{
  template = "Trap_closet_tech",

  map = "MAP02",

  x_fit = { 40,56 , 200,216 },
}
