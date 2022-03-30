PREFABS.Wall_gtd_ribbed_lights =
{
  file   = "wall/gtd_wall_industrial_ribbed_light_set.wad",
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

--

PREFABS.Wall_gtd_ribbed_lights_slump_two_color =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP07",

  group = "gtd_ribbed_lights_slump_two_color"
}

PREFABS.Wall_gtd_ribbed_lights_slump_two_color_diag =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP08",

  where = "diagonal",

  group = "gtd_ribbed_lights_slump_two_color"
}

--

PREFABS.Wall_gtd_ribbed_lights_tekmachine =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP09",

  group = "gtd_ribbed_lights_tekmachine",

  tex_LITE5 = "DOORSTOP",
  tex_TEKLITE2 = "TEKWALL4"
}

PREFABS.Wall_gtd_ribbed_lights_tekmachine_diag =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP10",

  where = "diagonal",

  group = "gtd_ribbed_lights_tekmachine",

  tex_LITE5 = "DOORSTOP",
  tex_TEKLITE2 = "TEKWALL4"
}


PREFABS.Wall_gtd_ribbed_lights_tekmachine_alt =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP09",

  group = "gtd_ribbed_lights_tekmachine_alt",

  tex_LITEBLU1 = "LITE3"
}

PREFABS.Wall_gtd_ribbed_lights_tekmachine_alt_diag =
{
  template = "Wall_gtd_ribbed_lights",
  map = "MAP10",

  where = "diagonal",

  group = "gtd_ribbed_lights_tekmachine_alt",

  tex_LITEBLU1 = "LITE3"

}