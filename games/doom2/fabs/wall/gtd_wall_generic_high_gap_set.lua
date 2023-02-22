PREFABS.Wall_generic_gtd_high_gap_straight =
{
  file   = "wall/gtd_wall_generic_high_gap_set.wad",
  map    = "MAP01",

  theme  = "!hell",

  prob   = 10,
  group = "gtd_wall_high_gap_set",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },
}

PREFABS.Wall_generic_gtd_high_gap_straight_plain =
{
  template = "Wall_generic_gtd_high_gap_straight",

  map      = "MAP02",

  prob = 50,
}

PREFABS.Wall_generic_gtd_high_gap_diagonal =
{
  file   = "wall/gtd_wall_generic_high_gap_set.wad",
  map    = "MAP03",

  theme  = "!hell",

  prob   = 50,
  group = "gtd_wall_high_gap_set",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },
}

PREFABS.Wall_generic_gtd_high_gap_hell_straight =
{
  template = "Wall_generic_gtd_high_gap_straight",

  theme = "hell",

  tex_LITE3 = "FIRELAVA",

  sector_1 = 0,

  tex_STEP4 = "STEPTOP",
  flat_FLAT19 = "CEIL5_2",
}

PREFABS.Wall_generic_gtd_high_gap_hell_straight_plain =
{
  template = "Wall_generic_gtd_high_gap_straight",

  map   = "MAP02",

  prob  = 50,

  theme = "hell",

  tex_LITE3 = "FIRELAVA",

  sector_1 = 0,

  tex_STEP4 = "STEPTOP",
  flat_FLAT19 = "CEIL5_2",
}

PREFABS.Wall_generic_gtd_high_gap_hell_diagonal =
{
  template = "Wall_generic_gtd_high_gap_diagonal",

  theme = "hell",

  tex_LITE3 = "FIRELAVA",

  sector_1 = 0,

  tex_STEP4 = "STEPTOP",
  flat_FLAT19 = "CEIL5_2",
}

PREFABS.Wall_generic_gtd_high_gap_straight_alt =
{
  template = "Wall_generic_gtd_high_gap_straight",

  theme = "!hell",
  group = "gtd_wall_high_gap_alt_set",

  tex_LITE3 = "LITEBLU4",
}

PREFABS.Wall_generic_gtd_high_gap_straight_alt_plain =
{
  template = "Wall_generic_gtd_high_gap_straight",

  map   = "MAP02",

  prob  = 50,

  theme = "!hell",
  group = "gtd_wall_high_gap_alt_set",

  tex_LITE3 = "LITEBLU4",
}

PREFABS.Wall_generic_gtd_high_gap_diagonal_alt =
{
  template = "Wall_generic_gtd_high_gap_diagonal",

  theme = "!hell",
  group = "gtd_wall_high_gap_alt_set",

  tex_LITE3 = "LITEBLU4",
}

PREFABS.Wall_generic_gtd_high_gap_hell_straight_alt =
{
  template = "Wall_generic_gtd_high_gap_straight",

  theme = "hell",
  group = "gtd_wall_high_gap_alt_set",

  tex_LITE3 = "FIREBLU1",

  sector_1 = 0,

  tex_STEP4 = "STEPTOP",
  flat_FLAT19 = "CEIL5_2",
}

PREFABS.Wall_generic_gtd_high_gap_hell_straight_alt_plain =
{
  template = "Wall_generic_gtd_high_gap_straight",

  map   = "MAP02",

  prob  = 50,

  theme = "hell",
  group = "gtd_wall_high_gap_alt_set",

  tex_LITE3 = "FIREBLU1",

  sector_1 = 0,

  tex_STEP4 = "STEPTOP",
  flat_FLAT19 = "CEIL5_2",
}

PREFABS.Wall_generic_gtd_high_gap_hell_diagonal_alt =
{
  template = "Wall_generic_gtd_high_gap_diagonal",

  theme = "hell",
  group = "gtd_wall_high_gap_alt_set",

  tex_LITE3 = "FIREBLU1",

  sector_1 = 0,

  tex_STEP4 = "STEPTOP",
  flat_FLAT19 = "CEIL5_2",
}
