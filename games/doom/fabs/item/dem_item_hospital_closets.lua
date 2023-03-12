--
--  item closets for hospital
--

--a item closet for the hospital set
PREFABS.Item_dem_item_hospital_closet1 =
{
  file  = "item/dem_item_hospital_closets.wad",
  map   = "MAP01",



  prob   = 5000,
  theme  = "!hell",
  env    = "building",

  group = "dem_wall_hospital",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  thing_28 =
  {
    blood_pack = 50,
    nothing = 20,
  },

  texture_pack = "armaetus"

}

PREFABS.Item_dem_item_hospital_closet2 =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP02",
}

PREFABS.Item_dem_item_hospital_closet3_amb =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP03",

  seed_w = 3,

}

PREFABS.Item_dem_item_hospital_closet4_amb =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP04",

  seed_w = 3,

}

PREFABS.Item_dem_item_hospital_closet5_amb =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP05",

  seed_w = 3,

}

PREFABS.Item_dem_item_hospital_closet6 =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP06",

  seed_w = 3,

}

PREFABS.Item_dem_item_hospital_closet7 =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP07",

  seed_w = 3,

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

  thing_19 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
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
    nothing = 50,
  },

}

PREFABS.Item_dem_item_hospital_closet8 =
{
  template = "Item_dem_item_hospital_closet1",
  map   = "MAP08",

  seed_w = 3,

}