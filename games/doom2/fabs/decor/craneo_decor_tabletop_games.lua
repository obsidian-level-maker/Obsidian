PREFABS.Decor_craneo_billiards_table =
{
  file  = "decor/craneo_decor_tabletop_games.wad",
  map   = "MAP01",

  prob  = 2500,

  theme = "urban",
  env   = "building",

  where = "point",
  size  = 96,

  bound_z1 = 0,
}

PREFABS.Decor_craneo_arcade_machine =
{
  template = "Decor_craneo_billiards_table",
  map  = "MAP02",

  prob = 1100,

  size = 64,

  face_open = true,

  sector_13 = {
    [0] = 5,
    [1] = 5,
    [2] = 5,
    [13] = 5,
    [21] = 5,
  }
}

--

PREFABS.Decor_craneo_arcade_machine_EPIC =
{
  template = "Decor_craneo_billiards_table",
  map = "MAP03",

  prob = 550,

  texture_pack = "armaetus",
  replaces = "Decor_craneo_arcade_machine",

  size = 64,

  face_open = true,

  tex_ARCD2 =
  {
    ARCD2 = 1,
    ARCD3 = 1,
    ARCD4 = 1,
    ARCD5 = 1,
    ARCD6 = 1,
    ARCD8 = 1,
    ARCD9 = 1,
    ARCD10 = 1,
    ARCD11 = 1,
  },

  sector_13 = {
    [0] = 5,
    [1] = 5,
    [2] = 5,
    [13] = 5,
    [21] = 5,
  }
}

PREFABS.Decor_craneo_arcade_machine_doublet_EPIC =
{
  template = "Decor_craneo_billiards_table",
  map = "MAP04",

  prob = 550,

  texture_pack = "armaetus",

  size = 112,

  face_open = true,

  tex_ARCD2 =
  {
    ARCD2 = 1,
    ARCD3 = 1,
    ARCD4 = 1,
    ARCD5 = 1,
    ARCD6 = 1,
    ARCD8 = 1,
    ARCD9 = 1,
    ARCD10 = 1,
    ARCD11 = 1,
  },

  tex_ARCD3 =
  {
    ARCD2 = 1,
    ARCD3 = 1,
    ARCD4 = 1,
    ARCD5 = 1,
    ARCD6 = 1,
    ARCD8 = 1,
    ARCD9 = 1,
    ARCD10 = 1,
    ARCD11 = 1,
  },

  sector_13 = {
    [0] = 5,
    [1] = 5,
    [2] = 5,
    [13] = 5,
    [21] = 5,
  }
}

-----------------------------------------------
-- Grouped versions based on arcade wall set --
-----------------------------------------------

PREFABS.Decor_craneo_billiards_table_grouped =
{
  template = "Decor_craneo_billiards_table",

  group = "gtd_wall_arcade",
}

PREFABS.Decor_rr_tennis_table_grouped =
{
  template = "Decor_realrexen_tennis_table",

  group = "gtd_wall_arcade",
}

PREFABS.Decor_craneo_arcade_machine_grouped =
{
  template = "Decor_craneo_billiards_table",
  map = "MAP03",

  prob = 550,

  group = "gtd_wall_arcade",

  size = 64,

  face_open = true,

  tex_ARCD2 =
  {
    ARCD2 = 1,
    ARCD3 = 1,
    ARCD4 = 1,
    ARCD5 = 1,
    ARCD6 = 1,
    ARCD8 = 1,
    ARCD9 = 1,
    ARCD10 = 1,
    ARCD11 = 1,
  },

  sector_13 = {
    [0] = 5,
    [1] = 5,
    [2] = 5,
    [13] = 5,
    [21] = 5,
  }
}

PREFABS.Decor_craneo_arcade_machine_doublet_grouped =
{
  template = "Decor_craneo_billiards_table",
  map = "MAP04",

  prob = 550,

  group = "gtd_wall_arcade",

  size = 112,

  face_open = true,

  tex_ARCD2 =
  {
    ARCD2 = 1,
    ARCD3 = 1,
    ARCD4 = 1,
    ARCD5 = 1,
    ARCD6 = 1,
    ARCD8 = 1,
    ARCD9 = 1,
    ARCD10 = 1,
    ARCD11 = 1,
  },

  tex_ARCD3 =
  {
    ARCD2 = 1,
    ARCD3 = 1,
    ARCD4 = 1,
    ARCD5 = 1,
    ARCD6 = 1,
    ARCD8 = 1,
    ARCD9 = 1,
    ARCD10 = 1,
    ARCD11 = 1,
  },

  sector_13 = {
    [0] = 5,
    [1] = 5,
    [2] = 5,
    [13] = 5,
    [21] = 5,
  }
}
