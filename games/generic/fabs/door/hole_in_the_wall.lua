PREFABS.Arch_wall_hole_1x =
{
  file   = "door/hole_in_the_wall.wad",
  map    = "MAP01",

  prob = 280,

  kind   = "arch",
  where  = "edge",

  deep   = 16,
  over   = 16,

  seed_w = 1,

  x_fit = "frame",

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Arch_wall_hole_2x =
{
  template = "Arch_wall_hole_1x",

  prob = 280,

  seed_w = 2,

  map = "MAP02",
}

PREFABS.Arch_wall_hole_3x =
{
  template = "Arch_wall_hole_1x",

  prob = 280,

  seed_w = 3,

  map = "MAP03",
}