PREFABS.Wall_gothic_ceilwall_arch =
{
  file   = "wall/gtd_wall_gothic_ceilwall_set.wad",
  map    = "MAP01",

  prob   = 50,
  env = "building",

  group = "gtd_gothic_ceilwall_arch",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_gothic_ceilwall_arch_diag =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP02",

  where = "diagonal"
}

--

PREFABS.Wall_gothic_ceilwall_doublet_arch =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP03",

  group = "gtd_gothic_ceilwall_doublet_arch",

  z_fit = {102,104 , 127,128}
}

PREFABS.Wall_gothic_ceilwall_doublet_arch_diag =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP04",

  group = "gtd_gothic_ceilwall_doublet_arch",

  where = "diagonal",

  z_fit = {102,104 , 127,128}
}

--

PREFABS.Wall_gothic_ceilwall_braced_arch =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP05",

  group = "gtd_gothic_ceilwall_braced_arch",

  z_fit = {94,96 ,  127,128}
}

PREFABS.Wall_gothic_ceilwall_braced_arch_diag =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP06",

  group = "gtd_gothic_ceilwall_braced_arch",

  where = "diagonal",

  z_fit = {94,96 ,  127,128}
}

--

PREFABS.Wall_gothic_ceilwall_xzibit_arch =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP07",

  group = "gtd_gothic_ceilwall_xzibit_arch"
}

PREFABS.Wall_gothic_ceilwall_xzibit_arch_diag =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP08",

  where = "diagonal",

  group = "gtd_gothic_ceilwall_xzibit_arch"
}

--

PREFABS.Wall_gothic_ceilwall_inner_framed_arch =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP09",

  group = "gtd_gothic_ceilwall_inner_framed_arch"
}

PREFABS.Wall_gothic_ceilwall_inner_framed_arch_diag =
{
  template = "Wall_gothic_ceilwall_arch",
  map = "MAP10",

  where = "diagonal",

  group = "gtd_gothic_ceilwall_inner_framed_arch"
}
