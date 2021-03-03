--
-- 2-seed-wide hallway : + piece
--

PREFABS.Hallway_conveyor_p1 =
{
  file   = "hall/dem_conveyor_p.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "tech",

  group  = "conveyor",
  prob   = 50,

  where  = "seeds",
  shape  = "P",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

 thing_2035 =
  {
    barrel = 60,
    nothing = 40,
  },

  sound = "Conveyor_Mech",
}

