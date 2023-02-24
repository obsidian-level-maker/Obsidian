--
--  Outdoor item gazebo
--

PREFABS.Item_gazebo2 =
{
  file   = "item/gazebo2.wad",
  map    = "MAP01",

  rank   = 2,
  prob   = 320,
  theme  = "urban",

  env    = "outdoor",
  open_to_sky = true,
  height = 176,

  item_kind = "key",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  x_fit = "frame",
}

PREFABS.Item_gazebo2_trap =
{
  template   = "Item_gazebo2",
  map  = "MAP02",
  prob = 220,
  style  = "traps",
  item_kind = "key",

  theme = "urban",
  tex_BROWN1 = { BROWN1=50, BROWN96=50, BROWNGRN=50, BROVINE2=50 },
  tex_STONE = { STONE=50, STONE2=50, STONE3=50, METAL2=50 },
  tex_METAL2 = "METAL2",
}


PREFABS.Item_gazebo2_tech =
{
  template   = "Item_gazebo2",
  map        = "MAP01",

  item_kind = "key",
  theme = "tech",
  tex_BROWN1 = { BROWN1=50, BROWN96=50, BROWNGRN=50, BROVINE2=50 },
  tex_STONE = { STONE=50, STONE2=50, STONE3=50, METAL2=50 },
  tex_REDWALL = "SHAWN3",
  tex_METAL5 = "SHAWN2",
  tex_STEP5  = "TEKWALL4",
  flat_FLAT5_3 = "FLAT20",
  flat_CEIL5_2 = "FLAT23",
  flat_FLAT1 = "CEIL5_1",
}

PREFABS.Item_gazebo2_tech_trap =
{
  template   = "Item_gazebo2",
  map  = "MAP02",
  prob = 220,
  style      = "traps",

  item_kind = "key",
  theme = "tech",
  tex_BROWN1 = { BROWN1=50, BROWN96=50, BROWNGRN=50, BROVINE2=50 },
  tex_STONE = { STONE=50, STONE2=50, STONE3=50, METAL2=50 },
  tex_REDWALL = "SHAWN3",
  tex_METAL5 = "SHAWN2",
  tex_STEP5  = "TEKWALL4",
  flat_FLAT5_3 = "FLAT20",
  flat_CEIL5_2 = "FLAT23",
  flat_FLAT1 = "CEIL5_1",
  tex_ASHWALL2 = "METAL2",
}

PREFABS.Item_gazebo2_hell =
{
  template   = "Item_gazebo2",
  map        = "MAP01",
  prob       = 320,

  item_kind = "key",
  theme = "hell",
  tex_BROWN1 = { MARBLE1=50, GSTONE1=50, GSTVINE1=50, GSTVINE2=50 },
  tex_STONE = { STONE=50, STONE4=50, STONE5=50, STONE6=50, STONE7=50 },
  tex_STEP5 = "MARBLE1",
  tex_REDWALL = "FIREBLU1",
  flat_FLAT1 = "FLOOR7_2",
  flat_FLAT5_3 = "FLOOR6_1",
}

PREFABS.Item_gazebo2_hell_trap =
{
  template   = "Item_gazebo2",
  map  = "MAP02",
  prob = 220,
  style   = "traps",

  item_kind = "key",
  theme = "hell",
  tex_BROWN1 = { MARBLE1=50, GSTONE1=50, GSTVINE1=50, GSTVINE2=50 },
  tex_STONE = { STONE=50, STONE4=50, STONE5=50, STONE6=50, STONE7=50 },
  tex_STEP5 = "MARBLE1",
  tex_REDWALL = "FIREBLU1",
  flat_FLAT1 = "FLOOR7_2",
  flat_FLAT5_3 = "FLOOR6_1",
  tex_ASHWALL2 = "METAL",
}
