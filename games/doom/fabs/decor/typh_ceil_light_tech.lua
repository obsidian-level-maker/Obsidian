PREFABS.Light_typh_tech =
{
  file   = "decor/typh_ceil_light_tech.wad",
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
PREFABS.Light_typh_tech_alt =
{
  template = "Light_typh_tech",

  light_color = "red",

  flat_TLITE6_6 = "TLITE6_5",
  flat_CEIL5_2 = "CEIL5_1",
  tex_BRONZE1 = "BROWNGRN",
}

-- gray light, gray cover version
PREFABS.Light_typh_tech_alt2 =
{
  template = "Light_typh_tech",

  light_color = "white",

  flat_TLITE6_6 = "FLAT2",
  flat_CEIL5_2 = "FLAT19",
  tex_BRONZE1 = "GRAY7",
}

PREFABS.Light_typh_flourescent_lamp =
{
  template = "Light_typh_tech",
  map = "MAP02",
  prob = 80,

  light_color = "white",
}

-- blue lights, same shell
PREFABS.Light_typh_flourescent_lamp_alt =
{
  template = "Light_typh_tech",
  map = "MAP02",
  prob = 80,

  light_color = "blue",

  flat_FLAT23 = "FLAT14",
  tex_LITE3 = "LITEBLU4",
}

-- red lights, same shell
PREFABS.Light_typh_flourescent_lamp_alt2 =
{
  template = "Light_typh_tech",
  map = "MAP02",
  prob = 80,

  light_color = "red",

  flat_FLAT23 = "FLAT5_3",
  tex_LITE3 = "REDWALL",
}

-- white lights, rusty inside shell
PREFABS.Light_typh_flourescent_lamp_alt3 =
{
  template = "Light_typh_tech",
  map = "MAP02",
  prob = 80,

  flat_CEIL5_1 = "CEIL5_2",
  tex_COMPSPAN = "SW1GARG",
}

-- blue lights, rusty inside shell
PREFABS.Light_typh_flourescent_lamp_alt4 =
{
  template = "Light_typh_tech",
  map = "MAP02",
  prob = 80,

  light_color = "blue",

  flat_CEIL5_1 = "CEIL5_2",
  flat_FLAT23 = "FLAT14",
  tex_COMPSPAN = "SW1GARG",
  tex_LITE3 = "LITEBLU4",
}

-- red lights, rusty inside shell
PREFABS.Light_typh_flourescent_lamp_alt5 =
{
  template = "Light_typh_tech",
  map = "MAP02",
  prob = 80,

  light_color = "red",

  flat_CEIL5_1 = "CEIL5_2",
  flat_FLAT23 = "FLAT5_3",
  tex_COMPSPAN = "SW1GARG",
  tex_LITE3 = "REDWALL",
}

PREFABS.Light_typh_sticks =
{
  template = "Light_typh_tech",
  map = "MAP03",
  prob = 80,

  light_color = "white",

  bound_z1 = -16,
}

PREFABS.Light_typh_sticks_alt =
{
  template = "Light_typh_tech",
  map = "MAP03",
  prob = 80,

  bound_z1 = -16,

  light_color = "blue",

  tex_LITE5 = "LITEBLU4",
}

PREFABS.Light_typh_sticks_alt2 =
{
  template = "Light_typh_tech",
  map = "MAP03",
  prob = 80,

  bound_z1 = -16,

  light_color = "red",

  flat_FLAT23 = "FLAT5_3",
  tex_LITE5 = "REDWALL",
}

PREFABS.Light_typh_short =
{
  template = "Light_typh_tech",
  map = "MAP04",
  prob = 80,

  bound_z1 = -88,

  light_color = "white",

  height = 184,
}

PREFABS.Light_typh_short_alt =
{
  template = "Light_typh_tech",
  map = "MAP04",
  prob = 80,

  bound_z1 = -88,

  height = 184,

  light_color = "blue",

  tex_LITE5 = "LITEBLU1",
}

PREFABS.Light_typh_short_alt2 =
{
  template = "Light_typh_tech",
  map = "MAP04",
  prob = 80,

  bound_z1 = -88,

  height = 184,

  light_color = "red",

  flat_FLAT23 = "FLAT5_3",
  tex_LITE5 = "REDWALL",
}
