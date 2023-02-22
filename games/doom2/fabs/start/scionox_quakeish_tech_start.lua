-- quake-inspired techbase start slipgate

PREFABS.Start_scionox_quakeish_tech_start =
{
  file   = "start/scionox_quakeish_tech_start.wad",
  map    = "MAP01",

  prob   = 250,

  theme = "tech",

  where  = "seeds",

  texture_pack = "armaetus",

  seed_w = 1,
  seed_h = 1,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Start_scionox_quakeish_tech_start_2 =
{
  template = "Start_scionox_quakeish_tech_start",
  map    = "MAP02",
  seed_w = 2,
  seed_h = 2,

  tex_COMPCT02 = { COMPCT02=50, COMPCT01=50, COMPCT03=50, GRAYMET7=50,
  GRAYMET9=50, DFAN1=50, GRAYBLU1=50 },
}
