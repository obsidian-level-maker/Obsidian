PREFABS.Wall_gtd_wood_frame_edge =
{
  file   = "wall/gtd_wall_wood_frame_set.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_woodframe",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 48,96 },
}

PREFABS.Wall_gtd_wood_frame_diag =
{
  file   = "wall/gtd_wall_wood_frame_set.wad",
  map    = "MAP02",

  prob   = 50,
  group  = "gtd_woodframe",

  where  = "diagonal",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 48,96 },
}

PREFABS.Wall_gtd_wood_frame_edge_green =
{
  template = "Wall_gtd_wood_frame_edge",

  group    = "gtd_woodframe_green",

  tex_PANEL2 = "PANEL3",
}

PREFABS.Wall_gtd_wood_frame_diag_green =
{
  template = "Wall_gtd_wood_frame_diag",

  group    = "gtd_woodframe_green",

  tex_PANEL2 = "PANEL3",
}
