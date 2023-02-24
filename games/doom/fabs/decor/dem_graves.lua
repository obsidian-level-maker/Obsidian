--
-- Graves for outdoor urban and hell
--

-- a dug up grave with a closed casket

PREFABS.Decor_Dem_Grave1 =
{
  file   = "decor/dem_graves.wad",
  map    = "MAP01",

  -- group = "dem_wall_graveyard", --MSSP-TODO: Re-add later

  port = "zdoom",

  prob   = 15000, --100
  skip_prob = 85,

  theme  = "!tech",
  env    = "park",

  where  = "point",
  size   = 64,

  bound_z1 = 0,
  bound_z2 = 128,

  delta = 64,

  z_fit = "top",

  on_liquids = "never",
}

-- a dug up grave with an open casket

PREFABS.Decor_Dem_Grave2 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP02",
}

-- a dug up grave

PREFABS.Decor_Dem_Grave3 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP03",

  thing_24 =
  {
    gibs = 50,
    gibbed_player = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
    Nothing = 50,
  },
}

-- a regular grave

PREFABS.Decor_Dem_Grave4 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP04",
}

-- a fancier regular grave

PREFABS.Decor_Dem_Grave5 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP05",
}

-- a tall regular grave

PREFABS.Decor_Dem_Grave6 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP06",

  texture_pack = "armaetus",
}

-- a fresh regular grave

PREFABS.Decor_Dem_Grave7 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP07",
}

-- a fresh regular grave2

PREFABS.Decor_Dem_Grave8 =
{
  template = "Decor_Dem_Grave1",
  map = "MAP08",
}