PREFABS.Wall_gtd_furnace_1 =
{
  file = "wall/gtd_wall_hell_furnace_set.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_furnace",

  where = "edge",

  deep = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Wall_gtd_furnace_diag_1 =
{
  template = "Wall_gtd_furnace_1",
  map = "MAP02",

  where = "diagonal"
}

PREFABS.Wall_gtd_furnace_face_1 =
{
  template = "Wall_gtd_furnace_1",

  group = "gtd_furnace_face",

  tex_FIRELAVA = "SP_FACE2"
}

PREFABS.Wall_gtd_furnace_face_diag_1 =
{
  template = "Wall_gtd_furnace_1",
  map = "MAP02",

  where = "diagonal",

  group = "gtd_furnace_face",

  tex_FIRELAVA = "SP_FACE2"
}

--

PREFABS.Wall_gtd_hell_aqueduct_1 =
{
  template = "Wall_gtd_furnace_1",

  group = "gtd_furnace_water",

  tex_FIRELAVA = "XFWATER",
  tex_MIDGRATE = "MIDSPACE"
}

PREFABS.Wall_gtd_hell_aqueduct_diagonal =
{
  template = "Wall_gtd_furnace_1",
  map = "MAP02",

  where = "diagonal",
  group = "gtd_furnace_water",

  tex_FIRELAVA = "XFWATER",
  tex_MIDGRATE = "MIDSPACE"
}
