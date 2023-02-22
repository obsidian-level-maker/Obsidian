--
-- Simple ceiling light
--

PREFABS.Light_EPIC_basic =
{
  file   = "decor/ceil_light.wad",
  map    = "MAP01",

  prob   = 0,
  env    = "building",

  texture_pack = "armaetus",

  kind   = "light",
  where  = "point",

  height = 96,

  bound_z1 = -32,
  bound_z2 = 0,

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=90, [1]=15 }

}


----------- URBAN THEME ------------------------


PREFABS.Light_urban_LITBL3F1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITBL3F1",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITBL3F2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITBL3F2",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITE4F1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITE4F1",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITE4F2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITE4F2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITES01 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITES01",

  light_color = "red",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITES02 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITES02",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITES03 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITES03",

  light_color = "yellow",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LITES04 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LITES04",

  light_color = "green",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LIGHTS1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LIGHTS1",

  light_color = "red",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LIGHTS2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LIGHTS2",

  light_color = "green",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LIGHTS3 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LIGHTS3",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_LIGHTS4 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "LIGHTS4",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE5_1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE5_1",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE5_2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE5_2",

  light_color = "beige",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE5_3 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE5_3",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE65B =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE65B",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE65G =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE65G",

  light_color = "green",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE65O =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE65O",

  light_color = "orange",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE65W =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE65W",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE65Y =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE65Y",

  light_color = "yellow",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_urban_TLITE65P =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "urban",

  flat_TLITE6_1 = "TLITE65P",

  light_color = "purple",

  sector_1  = { [0]=90, [1]=15 }
}


----------- TECH THEME ------------------------


PREFABS.Light_tech_LITBL3F1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITBL3F1",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITBL3F2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITBL3F2",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITE4F1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITE4F1",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITE4F2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITE4F2",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITES01 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITES01",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "red",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITES02 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITES02",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITES03 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITES03",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "yellow",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LITES04 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LITES04",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "green",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LIGHTS1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LIGHTS1",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "red",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LIGHTS2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LIGHTS2",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "green",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LIGHTS3 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LIGHTS3",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_LIGHTS4 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "LIGHTS4",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE5_1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  flat_TLITE6_1 = "TLITE5_1",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE5_2 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  flat_TLITE6_1 = "TLITE5_2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE5_3 =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE5_3",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE65B =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE65B",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "blue",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE65G =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE65G",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "green",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE65O =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE65O",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "orange",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE65W =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE65W",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "white",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE65Y =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE65Y",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "yellow",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Light_tech_TLITE65P =
{
  template = "Light_EPIC_basic",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",

  flat_TLITE6_1 = "TLITE65P",
  flat_CEIL5_2  = "FLAT23",
  tex_METAL = "SHAWN2",

  light_color = "purple",

  sector_1  = { [0]=90, [1]=15 }
}


----------- HELL THEME ------------------------


PREFABS.Light_hell_GLITE01 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "red",

  flat_TLITE6_4 = "GLITE01",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE02 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "red",

  flat_TLITE6_4 = "GLITE02",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE03 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "red",

  flat_TLITE6_4 = "GLITE03",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE04 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "red",

  flat_TLITE6_4 = "GLITE04",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE05 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "yellow",

  flat_TLITE6_4 = "GLITE05",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE06 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "red",

  flat_TLITE6_4 = "GLITE06",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE07 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "green",

  flat_TLITE6_4 = "GLITE07",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE08 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "white",

  flat_TLITE6_4 = "GLITE08",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_GLITE09 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "blue",

  flat_TLITE6_4 = "GLITE09",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",
}

PREFABS.Light_hell_PLITE1 =
{
  template = "Light_EPIC_basic",
  map    = "MAP01",

  prob   = 25,
  theme  = "hell",

  light_color = "purple",

  flat_TLITE6_4 = "PLITE1",
      tex_GRAY7 = "METAL",
     flat_FLAT19 = "CEIL5_2",

}
