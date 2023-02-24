PREFABS.Item_scionox_nature_simple_debris =
{
  file  = "item/scionox_nature_simple.wad",
  where = "point",

  map  = "MAP01",
  env  = "cave",

  size = 48,
  prob = 75,
}

PREFABS.Item_scionox_nature_simple_boulder =
{
  template = "Item_scionox_nature_simple_debris",

  env  = "nature",

  size = 80,
  height = 152,

  map = "MAP02",
}

PREFABS.Item_scionox_nature_simple_stalagmites =
{
  template = "Item_scionox_nature_simple_debris",

  size = 80,
  height = 128,

  map = "MAP03",
}

PREFABS.Item_scionox_nature_simple_pool =
{
  template = "Item_scionox_nature_simple_debris",

  env  = "nature",

  liquid = true,

  size = 72,

  map = "MAP04",
}
