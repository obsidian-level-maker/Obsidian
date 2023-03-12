-- Body bags set --

PREFABS.Decor_dem_hospital_decor1  =
{
  file   = "decor/dem_decor_hospital_set.wad",
  map    = "MAP01",



  prob   = 5000,
  theme  = "!hell",
  env    = "building",

  group = "dem_wall_hospital",

  where  = "point",
  size   = 64,

  on_liquids = "never",

  sink_mode = "never_liquids",

  texture_pack = "armaetus",

}

PREFABS.Decor_dem_hospital_decor2  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP02",

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

PREFABS.Decor_dem_hospital_decor3  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP03",

}

PREFABS.Decor_dem_hospital_decor4  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP04",

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

PREFABS.Decor_dem_hospital_decor5  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP05",

  tex_BLOOD1 = { BLOOD1 = 50, BODIESF2=50, BODIESFL=50, RMARB3=50 },

}

-- waiting chairs --

PREFABS.Decor_dem_hospital_decor6  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP06",

  prob   = 20000,


  size   = 128,

}

-- surgical tool tray --

PREFABS.Decor_dem_hospital_decor7  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP07",

}

-- bloody surgical tool tray --

PREFABS.Decor_dem_hospital_decor8  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP08",

}

-- computer tray --

PREFABS.Decor_dem_hospital_decor9  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP09",

}

-- defibrilator --

PREFABS.Decor_dem_hospital_decor10  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP10",

}

-- respirator --

PREFABS.Decor_dem_hospital_decor11  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP11",

}

-- hospital bed set --

PREFABS.Decor_dem_hospital_decor12  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP12",

  prob   = 6000,

  size   = 128,

}


PREFABS.Decor_dem_hospital_decor13  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP13",

  prob   = 6000,

  size   = 128,

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}


PREFABS.Decor_dem_hospital_decor14  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP14",

  prob   = 6000,

  size   = 128,

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

-- hospital crate set --

PREFABS.Decor_dem_hospital_decor15  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP15",

}


PREFABS.Decor_dem_hospital_decor16  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP16",

}

PREFABS.Decor_dem_hospital_decor17  =
{
  template = "Decor_dem_hospital_decor1",
  map = "MAP17",

}







