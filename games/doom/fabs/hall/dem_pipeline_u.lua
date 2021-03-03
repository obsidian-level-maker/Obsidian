--
-- pipeline piece : dead ends
--

PREFABS.Hallway_pipeline_u1 =
{
  file   = "hall/dem_pipeline_u.wad",
  map    = "MAP01",
  theme  = "tech",

  group  = "pipeline",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  sound = "Pipeline",

  texture_pack = "armaetus",
}

PREFABS.Hallway_pipeline_u2 =
{
  template = "Hallway_pipeline_u1",
  map    = "MAP02",
}

PREFABS.Hallway_pipeline_u3 =
{
  template = "Hallway_pipeline_u1",
  map    = "MAP03",

}

PREFABS.Hallway_pipeline_u4 =
{
  template = "Hallway_pipeline_u1",
  map    = "MAP04",
}

PREFABS.Hallway_pipeline_u5 =
{
  template = "Hallway_pipeline_u1",
  map    = "MAP05",
  style  = "cages",
}

