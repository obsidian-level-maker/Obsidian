--
-- Large keyed door
--

PREFABS.Locked_joiner_red =
{
  file   = "joiner/key_large.wad",
  where  = "seeds",
  shape  = "I",

  key    = "k_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  nearby_h = 160,

  prob   = 100,

  flat_FLOOR7_2 = "BIGDOOR3",

  -- texture is already "DOORRED",
  -- line special is already #33,
}


PREFABS.Locked_joiner_blue =
{
  template = "Locked_joiner_red",
  key      = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}


PREFABS.Locked_joiner_yellow =
{
  template = "Locked_joiner_red",
  key      = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

-- Hell--

PREFABS.Locked_joiner_red_hell =
{
  file   = "joiner/key_large.wad",
  where  = "seeds",
  shape  = "I",
  theme  = "hell",

  key    = "ks_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  nearby_h = 160,

  prob   = 100,

  flat_FLOOR7_2 = "CEIL5_2",
  tex_BIGDOOR3 = { BIGDOOR7=50, BIGDOOR5=50 },
  tex_DOORRED = "DOORRED2",


  -- texture is already "DOORRED",
  -- line special is already #33,
}


PREFABS.Locked_joiner_blue_hell =
{
  template = "Locked_joiner_red_hell",
  key      = "ks_blue",
  theme    = "hell",

  tex_DOORRED = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Locked_joiner_yellow_hell =
{
  template = "Locked_joiner_red_hell",
  key      = "ks_yellow",
  theme    = "hell",

  tex_DOORRED = "DOORYEL2",
  line_33     = 34,
}

-- Tech --

PREFABS.Locked_joiner_red_tech =
{
  file   = "joiner/key_large.wad",
  where  = "seeds",
  shape  = "I",
  theme  = "!hell",

  key    = "ks_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  nearby_h = 160,

  prob   = 100,

  flat_FLOOR7_2 = "FLAT20",
  tex_BIGDOOR3 = "BIGDOOR2",
  tex_DOORRED = "DOORRED2",


  -- texture is already "DOORRED",
  -- line special is already #33,
}


PREFABS.Locked_joiner_blue_tech =
{
  template = "Locked_joiner_red_tech",
  key      = "ks_blue",
  theme    = "!hell",

  tex_DOORRED = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Locked_joiner_yellow_tech =
{
  template = "Locked_joiner_red_tech",
  key      = "ks_yellow",
  theme    = "!hell",

  tex_DOORRED = "DOORYEL2",
  line_33     = 34,
}


PREFABS.Locked_joiner_red_tech2 =
{
  file   = "joiner/key_large.wad",
  where  = "seeds",
  shape  = "I",
  theme  = "!hell",

  key    = "ks_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  nearby_h = 160,

  prob   = 100,

  flat_FLOOR7_2 = "FLOOR3_3",
  tex_BIGDOOR3 = "BIGDOOR4",
  tex_DOORRED = "DOORRED2",


  -- texture is already "DOORRED",
  -- line special is already #33,
}


PREFABS.Locked_joiner_blue_tech =
{
  template = "Locked_joiner_red_tech2",
  key      = "ks_blue",
  theme    = "!hell",

  tex_DOORRED = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Locked_joiner_yellow_tech2 =
{
  template = "Locked_joiner_red_tech2",
  key      = "ks_yellow",
  theme    = "!hell",

  tex_DOORRED = "DOORYEL2",
  line_33     = 34,
}

--
