--
--Cages for urban
--

--a garage cage with car and small sandbag fortification
PREFABS.Cage_dem_garage_ambush1 =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP01",

  engine = "zdoom",

  prob   = 700,

  theme  = "urban",
  env    = "outdoor",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  x_fit = "frame",
  y_fit = "frame",

  tex_BRICK9 = { BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK3=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STONE3=50, BRICK12=50, BRICK5=50,
    BRONZE1=50, BROWN1=50, BROWN96=50,
    BROWNGRN=50, CEMENT7=50, CEMENT9=50,
  }

}

PREFABS.Cage_dem_garage_ambush1CBL =
{
  template = "Cage_dem_garage_ambush1",

  flat_FLAT5_3 = "CEIL4_2",

  tex_REDWALL = "COMPBLUE",
}

PREFABS.Cage_dem_garage_ambush1CBR =
{
  template = "Cage_dem_garage_ambush1",

  flat_FLAT5_3 = "CEIL5_2",

  tex_REDWALL = "BROWN144",
}

--a garage cage with a big truck
PREFABS.Cage_dem_garage_ambush2 =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP02",

  engine = "zdoom",

  prob   = 700,

  theme  = "urban",
  env    = "outdoor",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  x_fit = "frame",
  y_fit  = "frame",

  tex_BRICK9 = { BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK3=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STONE3=50, BRICK12=50, BRICK5=50,
    BRONZE1=50, BROWN1=50, BROWN96=50,
    BROWNGRN=50, CEMENT7=50, CEMENT9=50,
  }

}

--a grocery store with a horde of enemies inside
PREFABS.Cage_dem_store_ambush =
{
  file  = "cage/dem_cages.wad",
  map   = "MAP03",

  engine = "zdoom",

  theme = "urban",
  env   = "outdoor",
  prob  = 1000,

  where  = "seeds",
  shape  = "U",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK3=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50, STUCCO1=50,
    STUCCO3=50, TANROCK2=50, TANROCK3=50,
    SHAWN2=50,
  },

  thing_59 =
  {
  hang_twitching = 50,
  hang_torso = 50,
  hang_leg   = 50,
  hang_leg_gone = 50,
  },

  thing_62 =
  {
  hang_twitching = 50,
  hang_torso = 50,
  hang_leg   = 50,
  hang_leg_gone = 50,
  },

  thing_12 =
  {
  hang_twitching = 50,
  hang_torso = 50,
  hang_leg   = 50,
  hang_leg_gone = 50,
  }
}

--
--Cages for outdoor
--

--a concrete bunker
PREFABS.Cage_dem_bunker_ambush1 =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP04",

  engine = "zdoom",

  game = "doom2",

  prob   = 700,

  theme  = "!hell",

  env = "park",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit  = "frame",
  z_fit = { 56,64 },

  texture_pack = "armaetus",


  thing_3004 =
  {
    nothing = 20,
    zombie = 50,
    shooter = 30,
    imp = 50,
    gunner = 20,
  }

}



PREFABS.Cage_dem_bunker_ambush2 =
{
  template = "Cage_dem_bunker_ambush1",

  map = "MAP05",
  env    = "cave",
}

PREFABS.Cage_dem_bunker_ambush3 =
{
  template = "Cage_dem_bunker_ambush1",

  map = "MAP06",
  env = "nature",
  group = "natural_walls",
}

----upper ledge ambush----


PREFABS.Cage_dem_ledge_ambush1 =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP07",

  prob   = 700,

  theme  = "!hell",

  env = "park",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

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
  env = "park",

  bound_z1 = 0,
  bound_z2 = 184,

}

PREFABS.Cage_dem_ledge_ambush5 =
{
  template = "Cage_dem_ledge_ambush1",

  map = "MAP18",
  env = "park",

  bound_z1 = 0,
  bound_z2 = 232,

}

---- natural shrine getting corrupted by demon ----

PREFABS.Cage_dem_shrineC =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP10",

  engine = "zdoom",

  prob   = 700,

  theme  = "!hell",

  env = "cave",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

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

  engine = "zdoom",

  prob   = 100,

  env = "nature",

  group = "natural_walls",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

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

  engine = "zdoom",

  prob   = 100,

  env = "cave",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 84,92 },

  texture_pack = "armaetus",

}

PREFABS.Cage_dem_ruinsC2amd =
{
  template  = "Cage_dem_ruinsC1amb",
  map    = "MAP15",
}


----Natural corner with old cabin that have enemies inside----

PREFABS.Cage_dem_cabinamb =
{
  file   = "cage/dem_cages.wad",
  map    = "MAP16",

  engine = "zdoom",

  theme = "!hell",

  prob   = 100,

  env = "nature",

  group = "natural_walls",

  where  = "seeds",
  shape  = "U",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

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
  }

}
