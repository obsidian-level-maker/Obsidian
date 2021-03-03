--
-- 2-seed-wide hallway : terminators
--

PREFABS.Hallway_conveyor_term1 =
{
  file   = "hall/dem_conveyor_j.wad",
  map    = "MAP01",
  kind   = "terminator",
  engine = "zdoom",

  theme  = "tech",

  group  = "conveyor",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  texture_pack = "armaetus",

  deep   = 16,

  sound = "Conveyor_Mech",
}

PREFABS.Hallway_conveyor_term2 =
{
  template = "Hallway_conveyor_term1",

  map  = "MAP02",

}


---secret

PREFABS.Hallway_conveyor_secret =
{
  template = "Hallway_conveyor_term1",

  map  = "MAP05",
  key  = "secret",
}
