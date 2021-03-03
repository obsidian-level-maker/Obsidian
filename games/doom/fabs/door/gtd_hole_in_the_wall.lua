PREFABS.Arch_hole_in_the_wall_1x =
{
  file   = "door/gtd_hole_in_the_wall.wad",
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

PREFABS.Arch_hole_in_the_wall_2x =
{
  template = "Arch_hole_in_the_wall_1x",

  prob = 280,

  seed_w = 2,

  map = "MAP02",
}

PREFABS.Arch_hole_in_the_wall_3x =
{
  template = "Arch_hole_in_the_wall_1x",

  prob = 280,

  seed_w = 3,

  map = "MAP03",
}

-- key-locked version with a sort of portable force field

PREFABS.Arch_hole_in_the_wall_red_key =
{
  file = "door/gtd_hole_in_the_wall.wad",
  map = "MAP04",

  theme = "!hell",

  prob = 35,
  where = "edge",

  engine = "zdoom",

  texture_pack = "armaetus",

  key = "k_red",

  seed_w = 2,

  deep = 32,
  over = 32,

  x_fit = "frame",

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Arch_hole_in_the_wall_blue_key =
{
  template = "Arch_hole_in_the_wall_red_key",

  key = "k_blue",

  tex_DOORRED = "DOORBLU",
  tex_RDWAL01 = "COLLITE3",
  flat_FLOOR1_6 = "FLAT14",

  line_33 = 32,
}

PREFABS.Arch_hole_in_the_wall_yellow_key =
{
  template = "Arch_hole_in_the_wall_red_key",

  key = "k_yel",

  tex_DOORRED = "DOORYEL",
  tex_RDWAL01 = "COLLITE2",
  flat_FLOOR1_6 = "ORANFLOR",

  line_33 = 34,
}
