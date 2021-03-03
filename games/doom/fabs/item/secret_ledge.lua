--
-- Closet with a secret item visible from outside
--

PREFABS.Item_secret_ledge_universal =
{
  file  = "item/secret_ledge.wad",
  where = "seeds",

  prob  = 500,
  env   = "building",
  theme = "!tech",

  key   = "secret",

  seed_w = 3,
  seed_h = 1,
  height = 160,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  flat_CEIL3_1 = { CEIL3_1=50, CEIL3_2=50, FLOOR0_1=50, FLAT5_5=50, FLAT5=50, FLOOR0_2=50, FLOOR4_6=50, FLOOR5_3=50 },
  tex_STEP2 = { STEP2=50, STEP6=50 },

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=15, [1]=50, [2]=10, [3]=10, [8]=50 }

}

PREFABS.Item_secret_ledge_tech =
{
  template  = "Item_secret_ledge_universal",
  theme = "tech",

  tex_SUPPORT3 = "DOORSTOP",
}

PREFABS.Item_secret_ledge_universal_flipped =
{
  template  = "Item_secret_ledge_universal",

  map = "MAP02",
}

PREFABS.Item_secret_ledge_tech_flipped =
{
  template = "Item_secret_ledge_universal",
  theme = "tech",

  map = "MAP02",

  tex_SUPPORT3 = "DOORSTOP",
}

-- Variant goes down, with lift and platform to lower
PREFABS.Item_secret_ledge_sunken_universal =
{
  template  = "Item_secret_ledge_universal",
  map = "MAP03",
  theme = "!hell",
  prob = 400,
}

PREFABS.Item_secret_ledge_sunken_universal_flipped =
{
  template  = "Item_secret_ledge_universal",
  map = "MAP04",
  theme = "!hell",
  prob = 400,
}

PREFABS.Item_secret_ledge_sunken_universal_hell =
{
  template  = "Item_secret_ledge_universal",
  map = "MAP03",
  theme = "hell",
  prob = 400,

  tex_PLAT1 = "SUPPORT3",
  tex_BROWNHUG = "WOOD1",
  flat_FLAT20 = "CEIL5_2",
}

PREFABS.Item_secret_ledge_sunken_universal_flipped_hell =
{
  template  = "Item_secret_ledge_universal",
  map = "MAP04",
  theme = "hell",
  prob = 400,

  tex_PLAT1 = "SUPPORT3",
  tex_BROWNHUG = "WOOD1",
  flat_FLAT20 = "CEIL5_2",
}
