--
-- 2-seed-wide hallway : terminators
--

PREFABS.Hallway_conveyorh_term1 =
{
  file   = "hall/dem_conveyorh_j.wad",
  map    = "MAP01",
  engine = "gzdoom",

  kind   = "terminator",
  theme  = "hell",

  group  = "conveyorh",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  texture_pack = "armaetus",

}

PREFABS.Hallway_conveyorh_term2 =
{
  template = "Hallway_conveyorh_term1",

  map  = "MAP02",

  engine = "zdoom",

  thing_20 =
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
    pool_blood_1  = 50,
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
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_15 =
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

  thing_81 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  }

}

PREFABS.Hallway_conveyorh_term3 =
{
  template = "Hallway_conveyorh_term1",

  map  = "MAP03",

  engine = "zdoom",

}

PREFABS.Hallway_conveyorh_term4 =
{
  template = "Hallway_conveyorh_term1",

  map  = "MAP04",

  engine = "gzdoom",

  style = "doors",

}

PREFABS.Hallway_conveyorh_term5 =
{
  template = "Hallway_conveyorh_term1",

  map  = "MAP05",

  engine = "zdoom",

  style = "doors",

  thing_20 =
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
    pool_blood_1  = 50,
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
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_15 =
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

  thing_81 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  }

}

PREFABS.Hallway_conveyorh_term6 =
{
  template = "Hallway_conveyorh_term1",

  map  = "MAP06",
  style = "doors",

  engine = "zdoom",

}


---secret

PREFABS.Hallway_conveyorh_secret =
{
  template = "Hallway_conveyorh_term1",

  map  = "MAP07",
  key  = "secret",

  engine = "zdoom",
}
