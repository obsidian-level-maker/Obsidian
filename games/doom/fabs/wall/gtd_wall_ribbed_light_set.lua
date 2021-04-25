PREFABS.Wall_gtd_ribbed_lights =
{
  file   = "wall/gtd_wall_ribbed_light_set.wad",
  map    = "MAP01",

  engine = "zdoom",

  prob   = 50,
  group  = "gtd_ribbed_lights",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Wall_gtd_ribbed_lights_diag =
{
  template = "Wall_gtd_ribbed_lights",

  map = "MAP02",

  where = "diagonal"
}

PREFABS.Wall_gtd_ribbed_lights_fallback =
{
  template = "Wall_gtd_ribbed_lights",

  map = "MAP03",

  engine = "!zdoom"
}

PREFABS.Wall_gtd_ribbed_lights_diag_fallback =
{
  template = "Wall_gtd_ribbed_lights",

  map = "MAP04",

  engine = "!zdoom",

  where = "diagonal"
}

--

PREFABS.Wall_gtd_ribbed_lights_no3d =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP03",

  group = "gtd_ribbed_lights_no3d"
}

PREFABS.Wall_gtd_ribbed_lights_no3d_diag =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP04",

  where = "diagonal",

  group = "gtd_ribbed_lights_no3d"
}

--

PREFABS.Wall_gtd_ribbed_lights_slump =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP05",

  group = "gtd_ribbed_lights_slump"
}

PREFABS.Wall_gtd_ribbed_lights_slump_diag =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP06",

  where = "diagonal",

  group = "gtd_ribbed_lights_slump"
}
