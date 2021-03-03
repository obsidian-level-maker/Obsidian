--
-- Simple ceiling light
--

PREFABS.Light_basic =
{
  file   = "decor/ceil_light.wad",
  map    = "MAP01",

  prob   = 1,
  env    = "building",

  kind   = "light",
  where  = "point",

  height = 96,

  bound_z1 = -32,
  bound_z2 = 0,

  light_color = "beige",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


----------- URBAN THEME ------------------------


PREFABS.Light_urban1 =
{
  template = "Light_basic",
  -- use outie style

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_4 = "CEIL1_3",
   tex_METAL    = "WOOD10",

  light_color = "white",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }
}


PREFABS.Light_urban2 =
{
  template = "Light_basic",
  map    = "MAP02",

  prob   = 25,
  theme  = "urban",

  light_color = "beige",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


PREFABS.Light_urban3 =
{
  template = "Light_basic",
  map      = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "FLAT2",

  light_color = "white",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


----------- TECH THEME ------------------------


PREFABS.Light_tech1 =
{
  template = "Light_basic",
  map      = "MAP02",

  prob   = 100,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE6_5",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "red",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


PREFABS.Light_tech2 =
{
  template = "Light_basic",
  map      = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE6_6",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "beige",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


PREFABS.Light_tech_red =
{
  template = "Light_basic",
  map      = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "FLOOR1_7",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "red",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


PREFABS.Light_tech_green =
{
  template = "Light_basic",
  map      = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "GRNLITE1",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "white",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


PREFABS.Light_tech_blue =
{
  template = "Light_basic",
  -- use outie style

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_4 = "FLAT22",
   tex_METAL    = "SHAWN2",

  light_color = "blue",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}

-- Fans, ceiling sink does not look very nice so moved it here as a "light".
PREFABS.Light_fan_tech =
{
  template = "Light_basic",
  map      = "MAP03",

  texture_pack = "armaetus",

  prob   = 20,
  theme  = "tech",

  light_color = "none",

  flat_TLITE6_1 = "FAN1",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",
}

-- Used everywhere else
PREFABS.Light_fan_rusty =
{
  template = "Light_basic",
  map      = "MAP03",

  texture_pack = "armaetus",

  prob   = 20,
  theme  = "!tech",

  light_color = "none",

  flat_TLITE6_1 = "FAN1",
  flat_CEIL5_2  = "CEIL5_2",
  tex_METAL = "METAL",
}
