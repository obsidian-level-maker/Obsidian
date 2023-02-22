PREFABS.Locked_gtd_wide_gates_red =
{
  file = "joiner/gtd_keyed_wide_gates.wad",
  map = "MAP01",
  theme = "!hell",

  where = "seeds",
  shape = "I",

  texture_pack = "armaetus",

  key = "k_red",

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = 16,

  prob = 250,

  x_fit = { 132,140 , 244,252 },
  y_fit = { 28,52 , 108,132 },
}

PREFABS.Locked_gtd_wide_gates_red_hell =
{
  template = "Locked_gtd_wide_gates_red",
  map = "MAP02",
  theme = "hell",

  x_fit = { 56,120 , 264,328 },
}

PREFABS.Locked_gtd_wide_gates_blue =
{
  template = "Locked_gtd_wide_gates_red",

  key = "k_blue",

  tex_DOORRED = "DOORBLU",

  line_33 = 32,
}

PREFABS.Locked_gtd_wide_gates_blue_hell =
{
  template = "Locked_gtd_wide_gates_red",
  map = "MAP02",
  theme = "hell",

  key = "k_blue",

  line_33 = 32,

  tex_DOORRED2 = "DOORBLU2",

  x_fit = { 56,120 , 264,328 },
}

PREFABS.Locked_gtd_wide_gates_yellow =
{
  template = "Locked_gtd_wide_gates_red",

  key = "k_yellow",

  tex_DOORRED = "DOORYEL",

  line_33 = 34,
}

PREFABS.Locked_gtd_wide_gates_yellow_hell =
{
  template = "Locked_gtd_wide_gates_red",
  map = "MAP02",
  theme = "hell",

  key = "k_yellow",

  line_33 = 34,

  tex_DOORRED2 = "DOORYEL2",

  x_fit = { 56,120 , 264,328 },
}
