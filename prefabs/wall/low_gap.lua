--
-- Wall with gap at bottom
--

GROUPS.wall_low_gap =
{
  env = "building"

--  theme = "tech"
}


----------- TECH THEME -------------------------

PREFABS.Wall_lowgap =
{
  file   = "wall/low_gap.wad"
  map    = "MAP01"

  where  = "edge"
  deep   = 16
  height = 64

  group  = "low_gap"
  theme  = "tech"

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "top"
}


PREFABS.Wall_lowgap_diag =
{
  file   = "wall/low_gap.wad"
  map    = "MAP02"

  where  = "diagonal"
  height = 64

  group  = "low_gap"
  theme  = "tech"

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "top"
}


PREFABS.Wall_lowgap2 =
{
  template = "Wall_lowgap"

  group = "low_gap2"

  tex_TEKWALL4 = "TEKBRON2"
}

PREFABS.Wall_lowgap2_diag =
{
  template = "Wall_lowgap_diag"
  map = "MAP03"

  group = "low_gap2"

  tex_TEKWALL4 = "TEKBRON2"
}


PREFABS.Wall_lowgap3 =
{
  template = "Wall_lowgap"

  group = "low_gap3"

  tex_TEKWALL4 = "METAL6"
}

PREFABS.Wall_lowgap3_diag =
{
  template = "Wall_lowgap_diag"
  map = "MAP03"

  group = "low_gap3"

  tex_TEKWALL4 = "METAL6"
}


----------- HELL THEME -------------------------


PREFABS.Wall_hellgap =
{
  template = "Wall_lowgap"

  theme = "hell"

  tex_TEKWALL4 = "FIREWALL"
}


PREFABS.Wall_hellgap_diag =
{
  template = "Wall_lowgap_diag"

  theme = "hell"

  tex_TEKWALL4 = "FIREWALL"
}

