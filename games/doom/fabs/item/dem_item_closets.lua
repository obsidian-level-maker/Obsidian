--
--  item closets
--

--a item in a maze of mirrors1 in hell
PREFABS.Item_dem_mirrormaze_closet =
{
  file  = "item/dem_item_closets.wad",
  map   = "MAP01",

  engine = "zdoom",

  filter = "mirror_maze",

  theme = "hell",
  prob  = 100,

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",
}

--a item in a maze of mirrors2 in hell
PREFABS.Item_dem_mirrormaze2_closet =
{
  template = "Item_dem_mirrormaze_closet",
  map   = "MAP02",

  seed_w = 2,
  seed_h = 3,
}

--a item on a shrine in a rift in hell
PREFABS.Item_dem_rift_closet =
{
  file  = "item/dem_item_closets.wad",
  map   = "MAP03",

  engine = "zdoom",

  theme = "hell",
  prob  = 100,

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  thing_63 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_28 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    skull_cairn = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    evil_eye = 50,
    skull_rock = 50,
    big_tree = 50,
    burnt_tree = 50,

  },

  thing_25 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    skull_cairn = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    evil_eye = 50,
    skull_rock = 50,
    big_tree = 50,
    burnt_tree = 50,

  }

}

--an item forgotten in a grocery store
PREFABS.Item_dem_grocerystore_closet =
{
  file  = "item/dem_item_closets.wad",
  map   = "MAP04",

  engine = "zdoom",

  theme = "urban",
  env   = "outdoor",
  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50, STUCCO1=50,
    STUCCO3=50, TANROCK2=50, TANROCK3=50,
    SHAWN2=50,
  },

  thing_59 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_62 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_12 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  }

}

--an elevator shaft with an item
PREFABS.Item_dem_elevatorshaft_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP05",

  engine = "zdoom",

  prob = 50,
  skip_prob = 50,

  theme  = "!hell",

  env      = "building",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, MET6=50, MET7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50,
  }
}

--a corrupted elevator shaft with an item
PREFABS.Item_dem_elevatorshaftcorr_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP06",

  engine = "zdoom",

  prob   = 50,
  skip_prob = 50,

  theme  = "!hell",
  env    = "building",
  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",

  texture_pack = "armaetus",

  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, MET6=50, MET7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50,
  }
}

--a living room with an item
PREFABS.Item_dem_living_room_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP07",

  engine = "zdoom",

  prob   = 2000,

  theme  = "urban",

  env      = "outdoor",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "frame",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50,
  }
}

--a kitchen with an item hidden behind the table
PREFABS.Item_dem_kitchen_closet =
{
  file = "item/dem_item_closets.wad",
  map = "MAP08",

  prob = 2000,

  theme = "urban",

  env      = "outdoor",

  where = "seeds",

  seed_w = 2,
  seed_h = 3,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    }
}

--a bedroom with an hidden item
PREFABS.Item_dem_bedroom_closet =
{
  file = "item/dem_item_closets.wad",
  map = "MAP09",

  prob = 2000,

  theme = "urban",

  engine = "zdoom",

  env      = "outdoor",

  where = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    }
}


--an appartment stairwell with a ritual and an item
PREFABS.Item_dem_stairwell_closet =
{
  file = "item/dem_item_closets.wad",
  map = "MAP10",

  prob = 4500,

  theme = "urban",

  engine = "zdoom",

  env      = "outdoor",

  where = "seeds",

  seed_w = 2,
  seed_h = 3,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    }
}

--a bar with an item hidden behind of it
PREFABS.Item_dem_bar_closets =
{
  file = "item/dem_item_closets.wad",
  map    = "MAP11",

  engine = "zdoom",

  prob   = 2000,

  theme  = "urban",
  env      = "outdoor",
  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  }
}

--a waiting room with an item on the desk
PREFABS.Item_dem_waiting_room_closets =
{
  file = "item/dem_item_closets.wad",
  map    = "MAP12",

  engine = "zdoom",

  prob   = 2000,

  theme  = "urban",

  env      = "outdoor",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  },

  tex_CPAQLRRE = {
    CPAQLRRE=50, CPGARDEN=50, CPGARDN2=50,
    CPHRSEMN=50, CPHRSMN2=50,
  }
}

--a raided electronic store with an item
PREFABS.Item_dem_electronic_store_closets =
{
  file = "item/dem_item_closets.wad",
  map    = "MAP13",

  engine = "zdoom",

  prob   = 2000,
  theme  = "urban",
  env      = "outdoor",
  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  }

}

--a raided cornerstore with only one item remaining
PREFABS.Item_dem_cornerstore_closets =
{
  file = "item/dem_item_closets.wad",
  map    = "MAP14",

  engine = "zdoom",

  prob   = 2000,

  theme  = "urban",

  env      = "outdoor",

  where  = "seeds",

  seed_w = 2,
  seed_h = 3,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50,  STUCCO1=50,
    STUCCO3=50, STARGR1=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH31=50, BRICK9=50,
    BRICK10=50,TANROCK2=50, TANROCK3=50,
  }

}

--a fairly intact bookstore with an item inside
PREFABS.Item_dem_bookstore_closets =
{
  file = "item/dem_item_closets.wad",
  map    = "MAP15",

  engine = "zdoom",

  prob   = 2000,

  theme  = "urban",

  env      = "outdoor",

  where  = "seeds",

  seed_w = 2,
  seed_h = 3,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STUCCO=50, STUCCO1=50,
    STUCCO3=50, BRIKS43=50,
    GOTH31=50,GOTH16=50,GOTH02=50,
    BRICK9=50, TANROCK2=50, TANROCK3=50,
  }

}

--a item in a scrying room in hell
PREFABS.Item_dem_scrying1_closet =
{
  file  = "item/dem_item_closets.wad",
  map   = "MAP16",

  engine = "zdoom",

  theme = "hell",
  prob  = 250,

  where  = "seeds",
  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "frame",
}

--a item in a scrying room in hell
PREFABS.Item_dem_scrying2_closet =
{
  file  = "item/dem_item_closets.wad",
  map   = "MAP17",

  engine = "zdoom",

  theme = "hell",
  prob  = 100,

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",
}

---- natural shrine getting corrupted by demon with an item ----

PREFABS.Item_dem_shrine_closetC =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP18",

  engine = "zdoom",

  prob   = 100,

  env = "cave",

  theme  = "!hell",

  where  = "seeds",


  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,64 },

  texture_pack = "armaetus",

}

PREFABS.Item_dem_shrine_closetN =
{
  template = "Item_dem_shrine_closetC",

  map = "MAP19",
  env = "nature",
  group = "natural_walls",


}


----Natural corner with old cabin that have enemies inside and an item----

PREFABS.Item_dem_cabin_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP20",

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
  }

}

----Natural corner with campsite that have an item----

PREFABS.Item_dem_campsiteC_closet =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP21",

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

PREFABS.Item_dem_campsiteN_closet =
{
  template  = "Item_dem_campsiteC_closet",
  map    = "MAP22",
  env = "nature",

  group = "natural_walls",
}

PREFABS.Item_dem_campsiteP_closet =
{
  template  = "Item_dem_campsiteC_closet",
  map    = "MAP23",
  env = "park",
}

----a concrete bunker with an item inside ----

PREFABS.Item_dem_bunker_closetP =
{
  file   = "item/dem_item_closets.wad",
  map    = "MAP24",

  engine = "zdoom",

  game = "doom2",

  prob   = 100,

  theme  = "!hell",

  env = "park",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit  = "frame",
  z_fit = { 56,64 },

  texture_pack = "armaetus",


  thing_3004 =
  {
    nothing = 20,
    zombie = 50,
    shooter = 30,
    imp = 50,
    gunner = 20,
  }

}



PREFABS.Item_dem_bunker_closetC =
{
  template = "Item_dem_bunker_closetP",

  map = "MAP25",
  env    = "cave",
}

PREFABS.Item_dem_bunker_closetN =
{
  template = "Item_dem_bunker_closetP",

  map = "MAP26",
  env = "nature",
  group = "natural_walls",
}
