PREFABS.Locked_armaetus_bars_red_tech =
{
  file   = "joiner/armaetus_joiner_keyed_bars.wad",
  map    = "MAP01",
  theme  = "!hell",

  where  = "seeds",
  shape  = "I",

  key    = "k_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  prob   = 125,

  y_fit = { 36,44 , 116,124 },
  x_fit = "frame",

  tex_METAL = "SHAWN2",
  tex_SUPPORT3 = "SUPPORT2",
  flat_CEIL5_2 = "FLAT19",
}

PREFABS.Locked_armaetus_bars_blue_tech =
{
  template = "Locked_armaetus_bars_red_tech",

  key      = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_135     = 133,
}

PREFABS.Locked_armaetus_bars_yel_tech =
{
  template = "Locked_armaetus_bars_red_tech",

  key      = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_135     = 137,
}

-- hell version

PREFABS.Locked_armaetus_bars_red_hell =
{
  file   = "joiner/armaetus_joiner_keyed_bars.wad",
  map    = "MAP01",
  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  key    = "k_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  prob   = 125,

  y_fit = { 36,44 , 116,124 },
  x_fit = "frame",

  tex_DOORRED = "DOORRED2",
  tex_DOORSTOP = "METAL",
}

PREFABS.Locked_armaetus_bars_blue_hell =
{
  template = "Locked_armaetus_bars_red_hell",

  key      = "k_blue",

  tex_DOORRED = "DOORBLU2",
  tex_DOORSTOP = "METAL",

  line_135     = 133,
}

PREFABS.Locked_armaetus_bars_yel_hell =
{
  template = "Locked_armaetus_bars_red_hell",

  key      = "k_yellow",

  tex_DOORRED = "DOORYEL2",
  tex_DOORSTOP = "METAL",

  line_135     = 137,
}
