PREFABS.Stair_fancy_32_brown =
{
  file = "stairs/gtd_fancy_stair_32.wad",
  map = "MAP01",

  prob = 10,
  prob_skew = 3,

  style = "steepness",

  where = "seeds",
  shape = "I",

  seed_w = 2,
  seed_h = 1,

  x_fit = { 24,104 , 152,232 },
  y_fit = { 12,116 },

  bound_z1 = 0,

  delta_h = 32,
}

PREFABS.Stair_fancy_32_green =
{
  template = "Stair_fancy_32_brown",

  flat_CEIL5_2 = "RROCK20",
  tex_BRONZE1 = "BROWNGRN",
}

PREFABS.Stair_fancy_32_grey =
{
  template = "Stair_fancy_32_brown",

  flat_CEIL5_2 = "FLAT1",
  tex_BRONZE1 = "GRAY1",
}

-----
-- diagonal-edges
----

PREFABS.Stair_fancy_diagonal_edged_32_1X =
{
  file = "stairs/gtd_fancy_stair_32.wad",
  map = "MAP03",

  theme = "!hell",
  prob = 20,
  style = "steepness",

  where = "seeds",
  shape = "I",

  seed_w = 1,
  seed_h = 1,

  x_fit = "stretch",

  bound_z1 = 0,

  delta_h = 32,
}

PREFABS.Stair_fancy_diagonal_edged_32_2X =
{
  template = "Stair_fancy_diagonal_edged_32_1X",
  map = "MAP04",

  seed_h = 2,
}

-- hell version

PREFABS.Stair_fancy_diagonal_carpetted =
{
  template = "Stair_fancy_diagonal_edged_32_1X",
  map = "MAP05",

  theme = "hell",

  y_fit = { 28,36 , 60,68 , 92,100 },
  x_fit = { 60,68 },
}
