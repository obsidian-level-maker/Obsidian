--
-- Diagonal wall with some torches
--
-- NOTE: no straight wall version, as a torch might completely
--       block player movement.
--

PREFABS.Wall_torches1_diag =
{
  file   = "wall/torches.wad",
  map    = "MAP02",

  prob   = 50,
  group  = "torches1",

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit  = "top",

  solid_ents = false
}


PREFABS.Wall_torches2_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches2",

  thing_45 = "red_torch",
}

PREFABS.Wall_torches3_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches3",

  thing_45 = "blue_torch",
}

PREFABS.Wall_torches4_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches4",

  thing_45 = "mercury_small",
}

PREFABS.Wall_torches5_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches5",

  thing_45 = "mercury_lamp",
}

PREFABS.Wall_torches6_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches6",

  thing_45 = "candelabra",
}

PREFABS.Wall_torches7_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches7",

  thing_45 = "lamp",
}

PREFABS.Wall_torches8_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches8",

  thing_45 = "evil_eye",
}

PREFABS.Wall_torches9_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches9",

  thing_45 = "burning_barrel",
}

PREFABS.Wall_torches10_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches10",

  thing_45 = "skull_rock",
}

PREFABS.Wall_torches11_diag =
{
  template = "Wall_torches1_diag",

  group  = "torches11",

  thing_45 = "tech_column",
}
