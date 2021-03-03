--
-- hellcata piece : T junction
--

PREFABS.Hallway_hellcata_t1 =
{
  file   = "hall/dem_hellcata_t.wad",
  map    = "MAP01",
  theme  = "hell",

  group  = "hellcata",
  prob   = 50,

  where  = "seeds",
  shape  = "T",

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

PREFABS.Hallway_hellcata_t2 =
{
  template = "Hallway_hellcata_t1",
  map    = "MAP02",
}

PREFABS.Hallway_hellcata_t3 =
{
  template = "Hallway_hellcata_t1",
  map    = "MAP03",
}

PREFABS.Hallway_hellcata_t4 =
{
  template = "Hallway_hellcata_t1",
  map    = "MAP04",
}

PREFABS.Hallway_hellcata_t5 =
{
  template = "Hallway_hellcata_t1",
  map    = "MAP05",
}

PREFABS.Hallway_hellcata_t6 =
{
  template = "Hallway_hellcata_t1",
  map    = "MAP06",
}
