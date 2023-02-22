--
--  item closets
--

--an elevator shaft with an item
PREFABS.Item_dem_elevatorshaft_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP05",

  port = "zdoom",

  prob = 50,
  skip_prob = 50,

  theme  = "!hell",

  env      = "building",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, METAL6=50, METAL7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50,
  }
}

--a corrupted elevator shaft with an item
PREFABS.Item_dem_elevatorshaftcorr_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP06",

  port = "zdoom",

  prob   = 50,
  skip_prob = 50,

  theme  = "!hell",
  env    = "building",
  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",

  texture_pack = "armaetus",

  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, METAL6=50, METAL7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50,
  }
}


---- natural shrine getting corrupted by demon with an item ----

PREFABS.Item_dem_shrine_closetC =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP18",

  port = "zdoom",

  prob   = 100,

  env = "cave",

  theme  = "!hell",

  where  = "seeds",


  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,64 },

  texture_pack = "armaetus",

}

PREFABS.Item_dem_shrine_closetN =
{
  template = "Item_dem_shrine_closetC",

  map = "MAP19",
  env = "nature",
  group = "natural_walls",


}


----Natural corner with old cabin that have enemies inside and an item----

PREFABS.Item_dem_cabin_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP20",

  port = "zdoom",

  theme = "!hell",

  prob   = 100,

  env = "nature",

  group = "natural_walls",

  where  = "seeds",


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

----Natural corner with campsite that have an item----

PREFABS.Item_dem_campsiteC_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP21",

  port = "zdoom",

  theme = "!hell",

  prob   = 100,
  env = "cave",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64,72 },

  texture_pack = "armaetus",

}

PREFABS.Item_dem_campsiteN_closet =
{
  template  = "Item_dem_campsiteC_closet",
  map    = "MAP22",
  env = "nature",

  group = "natural_walls",
}

PREFABS.Item_dem_campsiteP_closet =
{
  template  = "Item_dem_campsiteC_closet",
  map    = "MAP23",
  env = "park",
}