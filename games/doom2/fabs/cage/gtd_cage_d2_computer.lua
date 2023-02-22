PREFABS.Cage_wall_d2_computer_tech =
{
  file   = "cage/gtd_cage_d2_computer.wad",

  map   = "MAP01",

  prob  = 400,

  theme  = "!hell",

  height = 128,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = { 112,144 },
  y_fit = "top",

  sector_8  = { [8]=60, [2]=10, [3]=10, [17]=10, [21]=5 },

  tex_SUPPORT3 = "SUPPORT2",

  thing_2014 =
  {
    [2014] = 50,
    [0] = 50,
  }
}

PREFABS.Cage_wall_d2_computer_hell =
{
  template = "Cage_wall_d2_computer_tech",

  map = "MAP02",

  theme = "hell",

  tex_SUPPORT3 = "SUPPORT3",
}

PREFABS.Cage_wall_d2_computer_tech_flipped =
{
  template = "Cage_wall_d2_computer_tech",

  map = "MAP03",

  tex_SUPPORT3 = "SUPPORT2",
}

PREFABS.Cage_wall_d2_computer_hell_flipped =
{
  template = "Cage_wall_d2_computer_tech",

  map = "MAP04",

  theme = "hell",

  tex_SUPPORT3 = "SUPPORT3",
}

PREFABS.Cage_freestanding_d2_computer_tech =
{
  file   = "cage/gtd_cage_d2_computer.wad",

  map    = "MAP05",

  prob   = 15,
  theme  = "tech",

  where  = "point",

  size   = 80,
  height = 96,

  bound_z1 = 0,

  thing_2011 =
  {
    [2011] = 40,
    [0] = 60,
  },

  plain_ceiling = true,
}

PREFABS.Cage_freestanding_d2_computer_urban =
{
  template = "Cage_freestanding_d2_computer_tech",

  theme = "urban",

  tex_COMPWERD = "WOOD4",
  flat_CEIL5_1 = "FLAT5_1",

  plain_ceiling = true,
}

PREFABS.Cage_freestanding_d2_computer_hell =
{
  template = "Cage_freestanding_d2_computer_tech",

  map = "MAP06",

  theme = "hell",

  plain_ceiling = true,
}
