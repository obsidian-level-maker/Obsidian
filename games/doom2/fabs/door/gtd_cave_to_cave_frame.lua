PREFABS.Door_cave_to_cave_frame =
{
  file = "door/gtd_cave_to_cave_frame.wad",

  map  = "MAP01",

  prob = 800,

  style = "doors",

  kind  = "arch",
  where = "edge",

  env = "cave",
  neighbor = "cave",

  seed_w = 2,

  deep = 32,
  over = 32,

  x_fit = "frame",
  z_fit = { 48,56 },

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Door_cave_to_cave_frame_3x =
{
  template = "Door_cave_to_cave_frame",
  map = "MAP02",

  seed_w = 3,
}
