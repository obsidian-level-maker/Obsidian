--
-- pipeline piece : terminators
--

PREFABS.Hallway_pipeline_term =
{
  file   = "hall/dem_pipeline_j.wad",
  map    = "MAP01",
  theme  = "tech",

  kind   = "terminator",
  group  = "pipeline",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  y_fit = "top",

  deep   = 16,

  sound = "Pipeline",

  texture_pack = "armaetus",

  tex_STONE2 = {  STONE2=50,STONE3=50,STONE8=50,STONE9=50,BRONZEG1=50,BRONZEG2=50,BRONZEG3=50,BROWNGRN=50,CEM01=50,CEM02=50,GRAY1=50,GRAY4=50,GRAY6=50,GRAY8=50,GRAY5=50,GRAY7=50,ICKWALL1=50,ICKWALL2=50,ICKWALL3=50,STARG3=50,STARGR1=50,SHAWGRY4=50,SHAWN01F=50,SHAWN4=50,SHAWN5=50,TEKSHAW=50,
    }

}

PREFABS.Hallway_pipeline_term2 =
{
  template = "Hallway_pipeline_term",
  map    = "MAP02",
}



PREFABS.Hallway_pipeline_term5 =
{
  template = "Hallway_pipeline_term",

  map    = "MAP05",
  key   = "secret",
}
