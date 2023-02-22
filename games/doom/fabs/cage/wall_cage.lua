--
-- Wall Cage
--

PREFABS.Cage_Wall =
{
  file   = "cage/wall_cage.wad",

  prob  = 100,
  theme = "!hell",

  where  = "seeds",
  shape  = "U",

  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = "stretch",
  y_fit = "top",

  sector_8  = { [8]=60, [2]=10, [3]=10, [17]=10, [21]=5 }
}


PREFABS.Cage_Wall_hell =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = "REDWALL",
  flat_FLAT23 = "RROCK03",
}

PREFABS.Cage_Wall_hell2 =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = "SKINFACE",
  flat_FLAT23 = "FLAT5_3",
}

PREFABS.Cage_Wall_hell3 =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = "SP_FACE1",
  flat_FLAT23 = "MFLR8_2",
}

PREFABS.Cage_Wall_hell4 =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = { FIREWALL=50, FIREBLU1=50 },
  flat_FLAT23 = "RROCK01",
}

PREFABS.Cage_Wall_hell5 =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = { GSTVINE1=50, GSTVINE2=50 },
  flat_FLAT23 = "DEM1_6",
}

PREFABS.Cage_Wall_hell6 =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = "MARBGRAY",
  flat_FLAT23 = "FLOOR7_2",
}

PREFABS.Cage_Wall_hell7 =
{
  template = "Cage_Wall",

  theme = "hell",

   tex_SHAWN2 = { SKINCUT=50, SKINSCAB=50 },
  flat_FLAT23 = "SFLR6_4",
}

PREFABS.Cage_Wall_tech =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = "TEKWALL1",
  flat_FLAT23 = "CEIL5_1",
}

PREFABS.Cage_Wall_tech2 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = "TEKWALL4",
  flat_FLAT23 = "CEIL5_1",
}

PREFABS.Cage_Wall_tech3 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = { ICKWALL1=50, ICKWALL2=50, ICKWALL3=50, ICKWALL7=50 },
  flat_FLAT23 = "FLAT18",
}

PREFABS.Cage_Wall_tech4 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = "METAL6",
  flat_FLAT23 = "CEIL4_1",
}

PREFABS.Cage_Wall_tech5 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = "METAL1",
  flat_FLAT23 = "FLOOR4_8",
}

PREFABS.Cage_Wall_tech6 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = "PIPEWAL2",
  flat_FLAT23 = "CEIL5_1",
}

PREFABS.Cage_Wall_tech7 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = { STONE2=30, STONE3=80 },
  flat_FLAT23 = "FLAT1",
}

PREFABS.Cage_Wall_tech8 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = { STONE4=50, STONE5=50 },
  flat_FLAT23 = "FLAT5_4",
}

PREFABS.Cage_Wall_tech9 =
{
  template = "Cage_Wall",

  theme = "tech",

   tex_SHAWN2 = { LITE3=50, LITE5=50 },
  flat_FLAT23 = "FLAT20",
}
