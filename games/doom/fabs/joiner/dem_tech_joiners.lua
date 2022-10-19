--
-- Demios sloped joiners
--

--This one is for Frozsoul for Hell's mass 2021

PREFABS.Joiner_dem_overbridge =
{
  file   = "joiner/dem_tech_joiners.wad",
  map    = "MAP01",

  prob   = 100,
  port = "zdoom",
  theme  = "tech",
  env = "!outdoor",
  neighbor = "!outdoor",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128+12,

  sound = "Water_Streaming",

}
