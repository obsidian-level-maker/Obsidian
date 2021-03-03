--
-- pipeline piece : corner (L shape)
--

PREFABS.Hallway_pipeline_c1 =
{
  file   = "hall/dem_pipeline_c.wad",
  map    = "MAP01",
  theme  = "tech",

  group  = "pipeline",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  engine = "gzdoom",

  sound = "Pipeline",

  texture_pack = "armaetus",

}

PREFABS.Hallway_pipeline_c2 =
{
  template = "Hallway_pipeline_c1",
  map    = "MAP02",
}

PREFABS.Hallway_pipeline_c3 =
{
  template = "Hallway_pipeline_c1",
  map    = "MAP03",
}

PREFABS.Hallway_pipeline_c4 =
{
  template = "Hallway_pipeline_c1",
  map    = "MAP04",
}

PREFABS.Hallway_pipeline_c5 =
{
  template = "Hallway_pipeline_c1",
  map    = "MAP05",

  filter = "crushers",

  style  = "traps",
}

PREFABS.Hallway_pipeline_c6 =
{
  template = "Hallway_pipeline_c1",
  map    = "MAP06",

  style  = "cages",
}

