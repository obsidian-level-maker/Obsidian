-- Boiler and pump station

PREFABS.Switch_Dem_closet1 =
{
  file   = "switch/dem_switch_closet.wad",
  map    = "MAP01",

  prob   = 50,
  port = "zdoom",
  theme  = "!hell",
  env = "building",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  tag_1 = "?switch_tag",


  x_fit = "frame",
  y_fit = "top",


  texture_pack = "armaetus",

  sound = "Water_Tank",

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,
}

-- Electric boxes

PREFABS.Switch_Dem_closet2 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP02",

  sound = "Electric_Sparks",
}

-- Server room

PREFABS.Switch_Dem_closet3 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP03",
}

-- A closet with a pump and a main power switch
--
-- Scionox needed a quiet place to work on his machines for Hell's mass 2021---

PREFABS.Switch_Dem_closet4 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP04",

  sound = "Electric_Sparks",
}

-- Boiler and pump station ambush

PREFABS.Switch_Dem_closetamb1 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP05",

  sound = "Water_Tank",

  seed_w = 3,
}

-- Electric boxes ambush

PREFABS.Switch_Dem_closetamb2 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP06",

  seed_w = 3,

  sound = "Electric_Sparks",
}

-- Server room ambush

PREFABS.Switch_Dem_closetamb3 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP07",

  seed_w = 3,
}

-- A closet with a pump and a main power switch ambush

PREFABS.Switch_Dem_closetamb4 =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP08",

  sound = "Electric_Sparks",
}
