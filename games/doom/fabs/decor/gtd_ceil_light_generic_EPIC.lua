PREFABS.Light_gtd_black_diamond_quad_white =
{
  file   = "decor/gtd_ceil_light_generic_EPIC.wad",
  map    = "MAP01",

  prob   = 35,
  env    = "building",

  kind   = "light",
  where  = "point",

  texture_pack = "armaetus",

  height = 128,

  bound_z1 = -32,
  bound_z2 = 0,

  light_color = "white",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_gtd_black_diamond_quad_red =
{
  template = "Light_gtd_black_diamond_quad_white",

  light_color = "red",

  flat_LIGHTS3 = "LIGHTS1"
}

PREFABS.Light_gtd_black_diamond_quad_green =
{
  template = "Light_gtd_black_diamond_quad_white",

  light_color = "green",

  flat_LIGHTS3 = "LIGHTS2"
}

PREFABS.Light_gtd_black_diamond_quad_blue =
{
  template = "Light_gtd_black_diamond_quad_white",

  light_color = "blue",

  flat_LIGHTS3 = "LIGHTS4"
}

-----------
-- MAP02 --
-----------

PREFABS.Light_gtd_tiny_single_red =
{
  template = "Light_gtd_black_diamond_quad_white",
  map = "MAP02",

  light_color = "red",
}

PREFABS.Light_gtd_tiny_single_blue =
{
  template = "Light_gtd_black_diamond_quad_white",
  map = "MAP02",

  light_color = "blue",

  flat_LITES01 = "LITES02"
}

PREFABS.Light_gtd_tiny_single_orange =
{
  template = "Light_gtd_black_diamond_quad_white",
  map = "MAP02",

  light_color = "orange",

  flat_LITES01 = "LITES03"
}

PREFABS.Light_gtd_tiny_single_green =
{
  template = "Light_gtd_black_diamond_quad_white",
  map = "MAP02",

  light_color = "green",

  flat_LITES01 = "LITES04"
}
