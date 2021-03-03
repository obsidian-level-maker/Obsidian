--
-- 2-seed-wide hallway : U piece
--

PREFABS.Hallway_conveyor_u1 =
{
  file   = "hall/dem_conveyor_u.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "tech",

  group  = "conveyor",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

 thing_2035 =
  {
    barrel = 60,
    nothing = 40,
  },

  thing_2013 =
  {
    soul = 50,
    blue_armor = 50,
  },

  sound = "Conveyor_Mech",
}

PREFABS.Hallway_conveyor_u2 =
{
  template  = "Hallway_conveyor_u1",
  map    = "MAP02",
  style  = "secrets",

  prob   = 10,

}

