--
-- Sloped joiner!!!
--

PREFABS.Joiner_simple_sloped =
{
  file   = "joiner/gtd_simple_sloped.wad",
  map    = "MAP01",

  prob   = 1000,
  engine = "zdoom",
  theme  = "!hell",
  env    = "!outdoor",
  neighbor = "!outdoor",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  bound_z1 = -8,

  x_fit = { 128-4,128+4 },
  y_fit = { 64,112 , 176,224 },
}
