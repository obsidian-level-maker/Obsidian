--
-- Sloped joiner!!!
--

PREFABS.Joiner_simple_arched =
{
  file   = "joiner/gtd_simple_arched.wad",
  map    = "MAP01",

  prob   = 1000,
  engine = "zdoom",
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

PREFABS.Joiner_simple_arched_urban = {
  template = "Joiner_simple_arched",

  theme = "urban",

  thing_46 = 85,
}

PREFABS.Joiner_simple_arched_notzdoom = {
  template = "Joiner_simple_arched",

  engine = "!zdoom",
  theme = "hell",

  line_341 = 0,
}

PREFABS.Joiner_simple_arched_urban_notzdoom = {
  template = "Joiner_simple_arched",

  engine = "!zdoom",
  theme = "urban",

  thing_46 = 85,
  line_341 = 0,
}
