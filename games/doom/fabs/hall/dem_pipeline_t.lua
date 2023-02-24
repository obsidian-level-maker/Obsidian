--
-- pipeline piece : T junction
--

PREFABS.Hallway_pipeline_t1 =
{
  file   = "hall/dem_pipeline_t.wad",
  map    = "MAP01",
  theme  = "tech",

  group  = "pipeline",
  prob   = 50,

  where  = "seeds",
  shape  = "T",

  seed_w = 2,
  seed_h = 2,

  sound = "Pipeline",

  texture_pack = "armaetus",
}

PREFABS.Hallway_pipeline_t2 =
{
  template = "Hallway_pipeline_t1",
  map    = "MAP02",
}

PREFABS.Hallway_pipeline_t3 =
{
  template = "Hallway_pipeline_t1",
  map    = "MAP03",
}

PREFABS.Hallway_pipeline_t4 =
{
  template = "Hallway_pipeline_t1",
  map    = "MAP04",
}

PREFABS.Hallway_pipeline_t5 =
{
  template = "Hallway_pipeline_t1",
  map    = "MAP05",

  filter = "crushers",

  style  = "traps",
}

PREFABS.Hallway_pipeline_t6 =
{
  template = "Hallway_pipeline_t1",
  map    = "MAP06",

  style  = "cages",
}


