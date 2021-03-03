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

---- cave-in with deco ----

PREFABS.Pic_dem_caveind1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP16",

  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  liquid = true,

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,64 },

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

texture_pack = "armaetus",
sound = "Water_Streaming",

}

PREFABS.Pic_dem_caveind2 =
{
  template  = "Pic_dem_caveind1",
  map    = "MAP17",
texture_pack = "none",
  liquid = false
}

PREFABS.Pic_dem_caveind3 =
{
  template  = "Pic_dem_caveind1",
  map    = "MAP18",
  liquid = true,
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_caveind4 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP19",

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

  z_fit = { 56,64 },

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

texture_pack = "armaetus",

}

PREFABS.Pic_dem_caveind5 =
{
  template  = "Pic_dem_caveind4",
  map    = "MAP20",
  liquid = true,
}

PREFABS.Pic_dem_caveind6 =
{
  template  = "Pic_dem_caveind4",
  map    = "MAP21",
  liquid = true,
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_caveind7 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP22",

  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,
  liquid = true,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,64 },

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

texture_pack = "armaetus",

}

PREFABS.Pic_dem_caveind8 =
{
  template  = "Pic_dem_caveind7",
  map    = "MAP23",
texture_pack = "armaetus",
  liquid = true,
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_caveind9 =
{
  template  = "Pic_dem_caveind7",
  map    = "MAP24",
texture_pack = "none",
  liquid = false
}

PREFABS.Pic_dem_caveind10 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP25",

  prob   = 100,
  env = "cave",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,
  liquid = true,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,64 },

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

  texture_pack = "armaetus",
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_caveind11 =
{
  template  = "Pic_dem_caveind10",
  map    = "MAP26",
  z_fit = { 88,96 },
texture_pack = "armaetus",
}

PREFABS.Pic_dem_caveind12 =
{
  template  = "Pic_dem_caveind10",
  map    = "MAP27",
texture_pack = "armaetus",
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

PREFABS.Pic_dem_nookd2 =
{
  template  = "Pic_dem_nookd1",
  map    = "MAP41",
  theme = "any",
  liquid = true,
  texture_pack = "armaetus",
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_nookd3 =
{
  template  = "Pic_dem_nookd1",
  map    = "MAP42",
  theme = "!hell",
  texture_pack = "armaetus",

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

PREFABS.Pic_dem_nookd6 =
{
  template  = "Pic_dem_nookd4",
  map    = "MAP45",
  z_fit = { 56,62 },
  texture_pack = "armaetus",
  liquid = true,
  sound = "Water_Streaming",
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

PREFABS.Pic_dem_nookd8 =
{
  template  = "Pic_dem_nookd7",
  map    = "MAP47",
  z_fit = "stretch",
  theme = "any",
  texture_pack = "armaetus",
  liquid = true,
  sound = "Water_Streaming",
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

PREFABS.Pic_dem_nookd11 =
{
  template  = "Pic_dem_nookd10",
  map    = "MAP50",
  theme = "!hell",
  z_fit = { 56,64 },

  texture_pack = "armaetus",
}

PREFABS.Pic_dem_nookd12 =
{
  template  = "Pic_dem_nookd10",
  map    = "MAP51",
  texture_pack = "armaetus",
  liquid = true,
}

----Natural corner with campsite----

PREFABS.Pic_dem_campsiteC =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP52",

  engine = "gzdoom",

  theme = "!hell",

  prob   = 100,
  env = "cave",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64,72 },

  texture_pack = "armaetus",

}

PREFABS.Pic_dem_campsiteN =
{
  template  = "Pic_dem_campsiteC",
  map    = "MAP53",
  env = "nature",

  group = "natural_walls",
}

PREFABS.Pic_dem_campsiteP =
{
  template  = "Pic_dem_campsiteC",
  map    = "MAP54",

  env = "park",

  prob = 100,
}

----Natural corner with old cabin----

PREFABS.Pic_dem_cabin =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP55",

  engine = "zdoom",

  theme = "!hell",

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

  z_fit = { 99,104 },

  texture_pack = "armaetus",

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

}

----Natural corner with waterfall or lake----

PREFABS.Pic_dem_waterfallC1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP56",

  engine = "zdoom",

  theme = "!hell",

  prob   = 100,
  env = "cave",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 16,32 },

  texture_pack = "armaetus",

  liquid = true,
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_lakeC1 =
{
  template  = "Pic_dem_waterfallC1",
  map    = "MAP57",
}


PREFABS.Pic_dem_waterfallN1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP58",

  engine = "zdoom",


  theme = "!hell",

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
  z_fit = { 24,40 },

  texture_pack = "armaetus",
  liquid = true,
}

PREFABS.Pic_dem_lakeN1 =
{
  template  = "Pic_dem_waterfallN1",
  map    = "MAP59",
}

PREFABS.Pic_dem_waterfallC2 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP60",

  engine = "zdoom",


  theme = "!hell",

  prob   = 100,
  env = "cave",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 16,32 },

  liquid = "harmful",

  texture_pack = "armaetus",
  sound = "Water_Streaming",
}

PREFABS.Pic_dem_lakeC2 =
{
  template  = "Pic_dem_waterfallC2",
  map    = "MAP61",
}


PREFABS.Pic_dem_waterfallN2 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP62",

  engine = "zdoom",

  theme = "!hell",

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
  z_fit = { 24,40 },

  liquid = "harmful",

  texture_pack = "armaetus",

}

PREFABS.Pic_dem_lakeN2 =
{
  template  = "Pic_dem_waterfallN2",
  map    = "MAP63",
}

PREFABS.Pic_dem_waterfallC3 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP64",

  engine = "zdoom",


  theme = "hell",

  prob   = 100,
  env = "cave",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 16,32 },

  liquid = "harmful",

  texture_pack = "armaetus",

}

PREFABS.Pic_dem_lakeC3 =
{
  template  = "Pic_dem_waterfallC3",
  map    = "MAP65",
}


PREFABS.Pic_dem_waterfallN3 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP66",

  engine = "zdoom",

  theme = "hell",

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
  z_fit = { 24,40 },

  liquid = "harmful",

  texture_pack = "armaetus",

}

PREFABS.Pic_dem_lakeN3 =
{
  template  = "Pic_dem_waterfallN3",
  map    = "MAP67",
}


---- Ruins and old temples ----

PREFABS.Pic_dem_ruinsN1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP68",

  engine = "zdoom",

  prob   = 100,

  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 152,

  x_fit = "stretch",
  z_fit = { 84,92 },

  texture_pack = "armaetus",

}

PREFABS.Pic_dem_ruinsN2 =
{
  template  = "Pic_dem_ruinsN1",
  map    = "MAP69",
}

PREFABS.Pic_dem_ruinsC1 =
{
  file   = "picture/dem_pic_nature.wad",
  map    = "MAP70",

  engine = "zdoom",

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
  z_fit = { 84,92 },

  texture_pack = "armaetus",

}

PREFABS.Pic_dem_ruinsC2 =
{
  template  = "Pic_dem_ruinsC1",
  map    = "MAP71",
}
