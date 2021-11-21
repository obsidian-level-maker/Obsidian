--
-- Sloped (not really - Dahso) joiner!!!
--

PREFABS.Joiner_simple_arched =
{
  file   = "joiner/gtd_simple_arched.wad",
  map    = "MAP01",

  prob   = 1000,
  env = "!outdoor",
  neighbor = "!outdoor",
  game   = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, nukem=0, quake=0, strife=1 },

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

  line_341 = 0,
}

PREFABS.Joiner_simple_arched_2 =
{
  file   = "joiner/gtd_simple_arched.wad",
  map    = "MAP02",
  game   = { chex3=1, doom1=1, doom2=1, hacx=1, harmony=1, heretic=0, hexen=0, nukem=1, quake=1, strife=0 },

  prob   = 750,

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

  line_342 = 0
}