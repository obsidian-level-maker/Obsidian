--
--Cages for outdoor
--

----upper ledge ambush----


PREFABS.Cage_dem_ledge_ambush1 =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP07",

  prob   = 700,

  theme  = "!hell",

  env = "park",
  park_mode = "no_nature",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 2,3 , 125,128 }
}

PREFABS.Cage_dem_ledge_ambush2 =
{
  template = "Cage_dem_ledge_ambush1",

  map = "MAP08",
  env    = "cave",

  x_fit = "frame",
  z_fit = { 16,24 }
}

PREFABS.Cage_dem_ledge_ambush3 =
{
  template = "Cage_dem_ledge_ambush1",

  map = "MAP09",
  env = "nature",
  group = "natural_walls",

  x_fit = "frame",
  z_fit = { 18,26 }
}

PREFABS.Cage_dem_ledge_ambush4 =
{
  template = "Cage_dem_ledge_ambush1",
  map = "MAP17",

  deep = 16,

  env = "park",
  park_mode = "no_nature",

  bound_z1 = 0,
  bound_z2 = 136,

  z_fit = { 2,3 , 133,136 }
}

PREFABS.Cage_dem_ledge_ambush5 =
{
  template = "Cage_dem_ledge_ambush1",
  map = "MAP18",

  env = "park",
  park_mode = "no_nature",

  bound_z1 = 0,
  bound_z2 = 232
}

---- natural shrine getting corrupted by demon ----

PREFABS.Cage_dem_shrineC =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP10",

  port = "zdoom",

  prob   = 700,

  theme  = "!hell",

  env = "cave",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  
  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,64 },

  texture_pack = "armaetus",
}

PREFABS.Cage_dem_shrineN =
{
  template = "Cage_dem_shrineC",

  map = "MAP11",
  env = "nature",
  group = "natural_walls",
}

---- Ruins with enemies hidden inside ----

PREFABS.Cage_dem_ruinsN1amb =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP12",

  port = "zdoom",

  prob   = 100,

  env = "nature",

  group = "natural_walls",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  
  bound_z1 = 0,
  bound_z2 = 144,

  x_fit = "stretch",
  z_fit = { 84,92 },

  texture_pack = "armaetus",
}

PREFABS.Cage_dem_ruinsN2amb =
{
  template  = "Cage_dem_ruinsN1amb",
  map    = "MAP13",
}

PREFABS.Cage_dem_ruinsC1amb =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP14",

  port = "zdoom",

  prob   = 100,

  env = "cave",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  
  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 84,92 },

  texture_pack = "armaetus",
}

PREFABS.Cage_dem_ruinsC2amd =
{
  template  = "Cage_dem_ruinsC1amb",
  map = "MAP15",
}


----Natural corner with old cabin that have enemies inside----

PREFABS.Cage_dem_cabinamb =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP16",

  port = "zdoom",

  theme = "!hell",

  prob   = 100,

  env = "nature",

  group = "natural_walls",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 99,104 },

  texture_pack = "armaetus",

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },
}

---- a dug up grave with a monster rising when you get close. ----

PREFABS.Decor_Dem_Graveamb1 =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP49",

  group = "dem_wall_graveyard",

  port = "zdoom",

  prob   = 100,
  theme  = "!tech",
  env    = "park",

  where  = "point",
  size   = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  delta = 116,

  z_fit = "top",

  on_liquids = "never",

  sink_mode = "never_liquids",
}
