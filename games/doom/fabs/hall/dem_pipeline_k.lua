--
-- pipeline piece : locked terminators
--

PREFABS.Hallway_pipeline_locked_red1 =
{
  file   = "hall/dem_pipeline_k.wad",
  map    = "MAP01",
  theme  = "tech",

  kind   = "terminator",
  group  = "pipeline",
  key    = "k_red",

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


PREFABS.Hallway_pipeline_locked_blue1 =
{
  template = "Hallway_pipeline_locked_red1",

  key    = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_135     = 133,
}


PREFABS.Hallway_pipeline_locked_yellow1 =
{
  template = "Hallway_pipeline_locked_red1",

  key    = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_135     = 137,
}

PREFABS.Hallway_pipeline_locked_red2 =
{
  file   = "hall/dem_pipeline_k.wad",
  map    = "MAP02",
  theme  = "tech",

  kind   = "terminator",
  group  = "pipeline",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  y_fit = "top",
  deep   = 16,

  engine = "gzdoom",

  sound = "Pipeline",

  texture_pack = "armaetus",

  tex_STONE2 = {  STONE2=50,STONE3=50,STONE8=50,STONE9=50,BRONZEG1=50,BRONZEG2=50,BRONZEG3=50,BROWNGRN=50,CEM01=50,CEM02=50,GRAY1=50,GRAY4=50,GRAY6=50,GRAY8=50,GRAY5=50,GRAY7=50,ICKWALL1=50,ICKWALL2=50,ICKWALL3=50,STARG3=50,STARGR1=50,SHAWGRY4=50,SHAWN01F=50,SHAWN4=50,SHAWN5=50,TEKSHAW=50,
    }

}


PREFABS.Hallway_pipeline_locked_blue2 =
{
  template = "Hallway_pipeline_locked_red2",

  key    = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_135     = 133,
}


PREFABS.Hallway_pipeline_locked_yellow2 =
{
  template = "Hallway_pipeline_locked_red2",

  key    = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_135     = 137,
}




----------------------------------------------------------------


PREFABS.Hallway_pipeline_barred1 =
{
  file   = "hall/dem_pipeline_k.wad",
  map    = "MAP05",

  kind   = "terminator",
  group  = "pipeline",
  key    = "barred",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  engine = "gzdoom",

  sound = "Pipeline",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  texture_pack = "armaetus",

  tex_STONE2 = {  STONE2=50,STONE3=50,STONE8=50,STONE9=50,BRONZEG1=50,BRONZEG2=50,BRONZEG3=50,BROWNGRN=50,CEM01=50,CEM02=50,GRAY1=50,GRAY4=50,GRAY6=50,GRAY8=50,GRAY5=50,GRAY7=50,ICKWALL1=50,ICKWALL2=50,ICKWALL3=50,STARG3=50,STARGR1=50,SHAWGRY4=50,SHAWN01F=50,SHAWN4=50,SHAWN5=50,TEKSHAW=50,
    }

}

PREFABS.Hallway_pipeline_barred2 =
{
  template   = "Hallway_pipeline_barred1",
  map    = "MAP06",

}

