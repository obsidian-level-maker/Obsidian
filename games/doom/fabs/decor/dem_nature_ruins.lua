---
--- Big ruins for the exterior
--- Note: The dummy sectors will need to be removed and converted when they are finalised in --- Obsidian.
---

--This humble home and its progenitor belong to Caligari for Hell's mass 2021

PREFABS.Decor_dem_nature_ruins1 =
{
  file   = "decor/dem_nature_ruins.wad",
  map    = "MAP01",

  prob   = 75000,
  engine = "zdoom",
  theme  = "!hell",
  env    = "park",

  where  = "point",
  size   = 256,

  tex_STUCCO3 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50, STUCCO1=50,
    BRICK5=50, TANROCK2=50, TANROCK3=50,
  },

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_79 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_15 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_81 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  }


}

PREFABS.Decor_dem_nature_ruins2 =
{
  template  = "Decor_dem_nature_ruins1",
  map    = "MAP02",

}


PREFABS.Decor_dem_nature_ruins3 =
{
  template  = "Decor_dem_nature_ruins1",
  map    = "MAP03",

}


PREFABS.Decor_dem_nature_ruins4 =
{
  template  = "Decor_dem_nature_ruins1",
  map    = "MAP04",

}


PREFABS.Decor_dem_nature_ruins5 =
{
  template  = "Decor_dem_nature_ruins1",
  map    = "MAP05",

}
