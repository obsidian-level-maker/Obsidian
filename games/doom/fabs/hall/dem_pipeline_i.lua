--
-- pipeline piece : straight
--

PREFABS.Hallway_pipeline_i1 =
{
  file   = "hall/dem_pipeline_i.wad",
  map    = "MAP01",
  theme  = "tech",

  group  = "pipeline",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  can_flip = true,

  sound = "Pipeline",

  texture_pack = "armaetus",

}

PREFABS.Hallway_pipeline_i2 =
{
  template = "Hallway_pipeline_i1",
  map    = "MAP02",
}

PREFABS.Hallway_pipeline_i3 =
{
  template = "Hallway_pipeline_i1",
  map    = "MAP03",
}

PREFABS.Hallway_pipeline_i4 =
{
  template = "Hallway_pipeline_i1",
  map    = "MAP04",
}

PREFABS.Hallway_pipeline_i5 =
{
  template = "Hallway_pipeline_i1",
  map    = "MAP05",

  filter = "crushers",

  style  = "traps",
}

PREFABS.Hallway_pipeline_i6 =
{
  template = "Hallway_pipeline_i1",
  map    = "MAP06",

  style  = "cages",
}

