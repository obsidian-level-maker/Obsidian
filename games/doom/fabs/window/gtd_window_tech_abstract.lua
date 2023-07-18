PREFABS.Window_tech_abstract_half_chamfer_techy =
{
  file   = "window/gtd_window_tech_abstract.wad",
  map    = "MAP01",

  group  = "gtd_window_half_chamfer_techy",
  port = "zdoom",
  rank = 2,

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Window_tech_abstract_half_chamfer_techy2 =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_tech_abstract_half_chamfer_techy3 =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  map      = "MAP03",

  seed_w   = 3,

  z_fit = { 44 + 4, 64 - 4 }
}

PREFABS.Window_tech_abstract_half_chamfer_techy3_no_stretch =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  map      = "MAP03",

  seed_w   = 3,

  z_fit = "top"
}

PREFABS.Window_tech_abstract_half_chamfer_techy4 =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  map      = "MAP04",

  seed_w   = 4,

  z_fit = { 44 + 4, 64 - 4 }
}

PREFABS.Window_tech_abstract_half_chamfer_techy4_no_stretch =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  map      = "MAP04",

  seed_w   = 3,

  z_fit = "top"
}
-- vanilla fallbacks

PREFABS.Window_tech_abstract_half_chamfer_techy_vanilla =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  engine = "!zdoom",

  rank = 1,

  line_300 = 0,
  line_343 = 0,
  line_344 = 0,
  line_345 = 0,
}


PREFABS.Window_tech_abstract_half_chamfer_techy_vanilla2 =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  map = "MAP02",

  engine = "!zdoom",

  rank = 1,

  line_300 = 0,
  line_343 = 0,
  line_344 = 0,
  line_345 = 0,

  seed_w = 2,
}

PREFABS.Window_tech_abstract_half_chamfer_techy_vanilla3 =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  engine = "!zdoom",
  map = "MAP03",

  rank = 1,

  line_300 = 0,
  line_343 = 0,
  line_344 = 0,
  line_345 = 0,

  seed_w = 3,
  z_fit = { 44 + 4, 64 - 4 }
}

PREFABS.Window_tech_abstract_half_chamfer_techy_vanilla4 =
{
  template = "Window_tech_abstract_half_chamfer_techy",
  engine = "!zdoom",
  map = "MAP04",

  rank = 1,

  line_300 = 0,
  line_343 = 0,
  line_344 = 0,
  line_345 = 0,

  seed_w = 4,
  z_fit = { 44 + 4, 64 - 4 }
}

--

PREFABS.Window_generic_cubby_holes =
{
  file   = "window/gtd_window_tech_abstract.wad",
  map    = "MAP05",

  group  = "gtd_window_cubby_holes",
  port = "zdoom",
  rank = 1,

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Window_generic_cubby_holes_2 =
{
  template = "Window_generic_cubby_holes",
  map = "MAP06",

  seed_w = 2
}

PREFABS.Window_generic_cubby_holes_3 =
{
  template = "Window_generic_cubby_holes",
  map = "MAP06",

  seed_w = 3
}

PREFABS.Window_generic_cubby_holes_4 =
{
  template = "Window_generic_cubby_holes",
  map = "MAP06",

  seed_w = 4
}

--

PREFABS.Window_generic_cubby_holes_hell =
{
  template = "Window_generic_cubby_holes",
  map = "MAP05",

  theme = "hell",
  rank = 2,

  seed_w = 1,

  tex_SHAWN2 = "METAL",
  flat_FLAT23 = "CEIL5_2"
}

PREFABS.Window_generic_cubby_holes_2_hell =
{
  template = "Window_generic_cubby_holes",
  map = "MAP06",

  theme = "hell",
  rank = 2,

  seed_w = 2,

  tex_SHAWN2 = "METAL",
  flat_FLAT23 = "CEIL5_2"
}

PREFABS.Window_generic_cubby_holes_3_hell =
{
  template = "Window_generic_cubby_holes",
  map = "MAP06",

  theme = "hell",
  rank = 2,

  seed_w = 3,

  tex_SHAWN2 = "METAL",
  flat_FLAT23 = "CEIL5_2"
}

PREFABS.Window_generic_cubby_holes_4_hell =
{
  template = "Window_generic_cubby_holes",
  map = "MAP06",

  theme = "hell",
  rank = 2,

  seed_w = 4,

  tex_SHAWN2 = "METAL",
  flat_FLAT23 = "CEIL5_2"
}


