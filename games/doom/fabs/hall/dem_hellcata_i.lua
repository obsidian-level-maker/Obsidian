--
-- hellcata piece : straight
--

PREFABS.Hallway_hellcata_i1 =
{
  file   = "hall/dem_hellcata_i.wad",
  map    = "MAP01",
  theme  = "hell",

  group  = "hellcata",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  engine = "zdoom",
  can_flip = true,

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
  },

}

PREFABS.Hallway_hellcata_i2 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP02",
}

PREFABS.Hallway_hellcata_i3 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP03",
}

PREFABS.Hallway_hellcata_i4 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP04",
  style  = "cages",
}

PREFABS.Hallway_hellcata_i5 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP05",
  style  = "cages",

}

PREFABS.Hallway_hellcata_i6 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP06",
}

PREFABS.Hallway_hellcata_i7 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP07",
}

PREFABS.Hallway_hellcata_i8 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP08",
}

PREFABS.Hallway_hellcata_i9 =
{
  template = "Hallway_hellcata_i1",
  map    = "MAP09",
}
