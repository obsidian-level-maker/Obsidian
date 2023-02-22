--
-- Sloped joiner!!!
--

PREFABS.Joiner_simple_arched =
{
  file   = "joiner/gtd_simple_arched.wad",
  map    = "MAP01",

  prob   = 1000,
  port = "zdoom",
  theme  = "hell",
  env = "!outdoor",
  neighbor = "!outdoor",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128+4,

  x_fit = { 128-16,128+16 },
  y_fit = { 64,96 , 192,224 },

  sector_1 = 0 -- a hack to stop Oblige from culling this sector, required by ZDoom slope linedefs
}

PREFABS.Joiner_simple_arched_notzdoom = {
  template = "Joiner_simple_arched",

  port = "!zdoom",
  theme = "hell",

  line_341 = 0,
}

PREFABS.Joiner_simple_arched_2 =
{
  file   = "joiner/gtd_simple_arched.wad",
  map    = "MAP02",

  prob   = 750,
  port = "zdoom",
  theme = "!hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 72, 184 },
  y_fit = { 56,120 , 168,232 },

  tex_SUPPORT3 = "GRAY7"
}

PREFABS.Joiner_simple_arched_2_hell =
{
  template = "Joiner_simple_arched_2",

  theme = "hell",

  tex_SUPPORT3 = "SUPPORT3",
  tex_GRAY7 = "BROWN144",
  tex_SILVER1 = "BRONZE3",
  flat_FLAT23 = "CEIL5_2"
}

PREFABS.Joiner_simple_arched_2_limit =
{
  template = "Joiner_simple_arched_2",

  port = "!zdoom",

  tex_SUPPORT3 = "GRAY7",

  line_342 = 0
}

PREFABS.Joiner_simple_arched_2_hell_limit =
{
  template = "Joiner_simple_arched_2",

  port = "!zdoom",
  theme = "hell",

  tex_SUPPORT3 = "SUPPORT3",
  tex_GRAY7 = "BROWN144",
  tex_SILVER1 = "BRONZE3",
  flat_FLAT23 = "CEIL5_2",

  line_342 = 0
}

--

PREFABS.Joiner_simple_arched_3 =
{
  file   = "joiner/gtd_simple_arched.wad",
  map    = "MAP03",

  prob   = 500,
  port = "zdoom",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 88, 168 },
  y_fit = { 24, 136 }
}

PREFABS.Joiner_simple_arched_3_limit =
{
  template = "Joiner_simple_arched_3",

  port = "!zdoom",

  prob = 125,

  line_344 = 0
}
