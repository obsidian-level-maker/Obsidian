--
-- hellcata piece : corner (L shape)
--

PREFABS.Hallway_hellcata_c1 =
{
  file   = "hall/dem_hellcata_c.wad",
  map    = "MAP01",
  theme  = "hell",

  group  = "hellcata",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  engine = "zdoom",

  tex_CATACMB2 = {
    CATACMB1=50, CATACMB2=50,
  },

  thing_24 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1 = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_79 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1 = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_81 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1 = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  }

}

PREFABS.Hallway_hellcata_c2 =
{
  template = "Hallway_hellcata_c1",
  map    = "MAP02",
}

PREFABS.Hallway_hellcata_c3 =
{
  template = "Hallway_hellcata_c1",
  map    = "MAP03",

  style  = "cages",
}

PREFABS.Hallway_hellcata_c4 =
{
  template = "Hallway_hellcata_c1",
  map    = "MAP04",
}

PREFABS.Hallway_hellcata_c5 =
{
  template = "Hallway_hellcata_c1",
  map    = "MAP05",
}
