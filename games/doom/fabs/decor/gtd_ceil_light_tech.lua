PREFABS.Light_gtd_detailed =
{
  file   = "decor/gtd_ceil_light_tech.wad",
  map    = "MAP01",

  prob   = 60,
  theme  = "!hell",
  env    = "building",

  kind   = "light",
  where  = "point",

  height = 128,

  bound_z1 = -32,
  bound_z2 = 0,

  light_color = "orange",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}

-- red circles with green cover
PREFABS.Light_gtd_detailed_alt =
{
  template = "Light_gtd_detailed",

  light_color = "red",

  flat_TLITE6_6 = "TLITE6_5",
  flat_CEIL5_2 = "CEIL5_1",
  tex_BRONZE1 = "BROWNGRN",
}

-- gray light, gray cover version
PREFABS.Light_gtd_detailed_alt2 =
{
  template = "Light_gtd_detailed",

  light_color = "white",

  flat_TLITE6_6 = "FLAT2",
  flat_CEIL5_2 = "FLAT19",
  tex_BRONZE1 = "GRAY7",
}

PREFABS.Light_gtd_flourescent_lamp =
{
  template = "Light_gtd_detailed",
  map = "MAP02",
  prob = 80,

  light_color = "white",

  bound_z1 = -24,
}

PREFABS.Light_gtd_flourescent_lamp_alt =
{
  template = "Light_gtd_detailed",
  map = "MAP02",
  prob = 80,

  bound_z1 = -24,

  light_color = "blue",

  tex_LITE3 = "LITEBLU4",
  tex_LITE5 = "LITEBLU4",
  flat_FLAT23 = "FLAT14",
}

PREFABS.Light_gtd_round =
{
  template = "Light_gtd_detailed",
  map = "MAP03",
  prob = 80,

  light_color = "white",

  bound_z1 = -16,
}

PREFABS.Light_gtd_round_alt =
{
  template = "Light_gtd_detailed",
  map = "MAP03",
  prob = 80,

  bound_z1 = -16,

  light_color = "blue",

  tex_LITE5 = "LITEBLU4",
  flat_FLAT23 = "FLAT22",
}

PREFABS.Light_gtd_tall_light =
{
  template = "Light_gtd_detailed",
  map = "MAP04",
  prob = 80,

  bound_z1 = -88,

  light_color = "white",

  height = 184,
}

PREFABS.Light_gtd_tall_light_alt =
{
  template = "Light_gtd_detailed",
  map = "MAP04",
  prob = 80,

  bound_z1 = -88,

  height = 184,

  light_color = "blue",

  tex_EXITDOOR = "LITEBLU1",
  flat_FLAT23 = "FLAT14",
}
