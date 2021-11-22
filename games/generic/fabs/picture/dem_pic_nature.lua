---- cave-in ----

PREFABS.Pic_dem_cavein1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP01",


  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 56,64 },
}

PREFABS.Pic_dem_cavein2 =
{
  template  = "Pic_dem_cavein1",
  map    = "MAP02",
}

PREFABS.Pic_dem_cavein3 =
{
  template  = "Pic_dem_cavein1",
  map    = "MAP03",
}

PREFABS.Pic_dem_cavein4 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP04",


  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 56,64 },
}

PREFABS.Pic_dem_cavein5 =
{
  template  = "Pic_dem_cavein4",
  map    = "MAP05",
}

PREFABS.Pic_dem_cavein6 =
{
  template  = "Pic_dem_cavein4",
  map    = "MAP06",
}

PREFABS.Pic_dem_cavein7 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP07",

  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 56,64 },
}

PREFABS.Pic_dem_cavein8 =
{
  template  = "Pic_dem_cavein7",
  map    = "MAP08",
}

PREFABS.Pic_dem_cavein9 =
{
  template  = "Pic_dem_cavein7",
  map    = "MAP09",
}

PREFABS.Pic_dem_cavein10 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP10",

  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 56,64 },
}

PREFABS.Pic_dem_cavein11 =
{
  template  = "Pic_dem_cavein10",
  map    = "MAP11",
}

PREFABS.Pic_dem_cavein12 =
{
  template  = "Pic_dem_cavein10",
  map    = "MAP12",
}


PREFABS.Pic_dem_cavein13 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP13",


  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 56,64 },
}

PREFABS.Pic_dem_cavein14 =
{
  template  = "Pic_dem_cavein13",
  map    = "MAP14",
}

PREFABS.Pic_dem_cavein15 =
{
  template  = "Pic_dem_cavein13",
  map    = "MAP15",
  z_fit = { 56,64 },
}

---- outdoor nooks ----

PREFABS.Pic_dem_nook1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP28",

  prob   = 100,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = "stretch",


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nook2 =
{
  template  = "Pic_dem_nook1",
  map    = "MAP29",
texture_pack = "none",
}

PREFABS.Pic_dem_nook3 =
{
  template  = "Pic_dem_nook1",
  map    = "MAP30",
}

PREFABS.Pic_dem_nook4 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP31",

  prob   = 100,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = "stretch",


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nook5 =
{
  template  = "Pic_dem_nook4",
  map    = "MAP32",
}

PREFABS.Pic_dem_nook6 =
{
  template  = "Pic_dem_nook4",
  map    = "MAP33",
}

PREFABS.Pic_dem_nook7 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP34",

  prob   = 100,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = "stretch",


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nook8 =
{
  template  = "Pic_dem_nook7",
  map    = "MAP35",
}

PREFABS.Pic_dem_nook9 =
{
  template  = "Pic_dem_nook7",
  map    = "MAP36",
}

PREFABS.Pic_dem_nook10 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP37",

  prob   = 100,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = "stretch",


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nook11 =
{
  template  = "Pic_dem_nook10",
  map    = "MAP38",
}

PREFABS.Pic_dem_nook12 =
{
  template  = "Pic_dem_nook10",
  map    = "MAP39",
}



---- outdoor nooks with deco ----

PREFABS.Pic_dem_nookd1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP40",

  prob   = 100,
  theme = "!hell",
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,62 },


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nookd4 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP43",

  prob   = 100,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "stretch",


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nookd5 =
{
  template  = "Pic_dem_nookd4",
  map    = "MAP44",
}

PREFABS.Pic_dem_nookd7 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP46",

  prob   = 100,
  env = "nature",
  theme = "!hell",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 56,64 },


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_dem_nookd9 =
{
  template  = "Pic_dem_nookd7",
  map    = "MAP48",
  z_fit = { 40,56 },
  theme = "any",
}

PREFABS.Pic_dem_nookd10 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP49",

  prob   = 100,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = "stretch",


  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}