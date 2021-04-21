--
-- Hideous Destructor-centric cover walls
--

PREFABS.Wall_HD_crate_pile =
{
  file   = "wall/gtd_wall_hideous_cover.wad",
  map    = "MAP01",

  is_hideous_destructor_fab = true,
  on_liquids = "never",

  prob   = 15,
  env   = "building",

  where  = "edge",
  height = 128,
  deep   = 48,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_HD_crate_pile2 =
{
  template = "Wall_HD_crate_pile",

  map = "MAP02",
}

PREFABS.Wall_HD_crate_pile3 =
{
  template = "Wall_HD_crate_pile",

  map = "MAP03",
}

PREFABS.Wall_HD_fence_post =
{
  template = "Wall_HD_crate_pile",

  map = "MAP04",

  deep = 76,
}

PREFABS.Wall_HD_T_fence =
{
  template = "Wall_HD_crate_pile",

  map = "MAP05",

  deep = 80,
}

PREFABS.Wall_HD_double_fence_post =
{
  template = "Wall_HD_crate_pile",

  map = "MAP06",

  deep = 128,
}

PREFABS.Wall_HD_exposed_fence =
{
  template = "Wall_HD_crate_pile",

  map = "MAP07",

  deep = 72,
}

PREFABS.Wall_HD_L_fence =
{
  template = "Wall_HD_crate_pile",

  map = "MAP08",

  deep = 72,
}

PREFABS.Wall_HD_fat_pillar =
{
  template = "Wall_HD_crate_pile",

  map = "MAP09",

  deep = 96,

  z_fit = {60,68},
}

PREFABS.Wall_HD_monitor =
{
  template = "Wall_HD_crate_pile",

  map = "MAP10",

  deep = 80,
}

PREFABS.Wall_HD_brace =
{
  template = "Wall_HD_crate_pile",

  map = "MAP11",

  deep = 72,
}

PREFABS.Wall_HD_computer_on_corner =
{
  template = "Wall_HD_crate_pile",

  map = "MAP12",

  deep = 80,
}

PREFABS.Wall_HD_computer_on_table =
{
  template = "Wall_HD_crate_pile",

  map = "MAP13",
}

PREFABS.Wall_HD_computer_on_fence =
{
  template = "Wall_HD_crate_pile",

  map = "MAP14",

  deep = 112,
}

PREFABS.Wall_HD_fallen_monitors =
{
  template = "Wall_HD_crate_pile",

  map = "MAP15",

  deep = 112,
}
