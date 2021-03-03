--
--  Secret items closets
--

--a secret aera in a garage you need to duck
PREFABS.Item_secret_garage_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP01",

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
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STONE3=50, BRICK12=50, BRICK5=50,
    BRONZE1=50, BROWN1=50, BROWN96=50,
    BROWNGRN=50, CEMENT7=50,
    CEMENT9=50,
    },

  can_flip = true,
}

--a secret in a grocery store, shoot the electric panel
PREFABS.Item_secret_store_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP02",

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

  can_flip = true,

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

--a secret shrine to Nine inch nails where you need to be quick and open the 3 doors on the proper order to acess it.
PREFABS.Item_secret_NIN_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP03",

  env   = "building",

  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  thing_2018 =
  {
    green_armor = 50,
    blue_armor = 50,
  },

  can_flip = true,
}

--The hell item shrine with a really crummy item, teach this cheeky gargoyle a lesson to reveal your prize.
PREFABS.Item_secret_hellgargoyle_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP04",

  theme = "hell",
  env = "!nature",

  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  },

  can_flip = true,
}

--To the one who sit upon this throne, secrets should be bestowed upon him.
PREFABS.Item_secret_hellthrone_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP05",

  theme = "hell",
  env = "!nature",

  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  },

  can_flip = true,
}

--To the one preaching spin yourself and shoot evil in its eye.
PREFABS.Item_secret_lectern_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP06",

  theme = "hell",
  env = "!nature",

  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  },

  can_flip = true,
}

--Stretch your arm under the hatch to open the machine V1,
PREFABS.Item_secret_hellmachine1V1_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP07",
  engine = "zdoom",

  theme = "hell",
  env = "!nature",

  prob  = 15,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  can_flip = true,

  texture_pack = "armaetus",
}

--Stretch your arm under the hatch to open the machine V2,
PREFABS.Item_secret_hellmachine1V2_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP08",
  engine = "zdoom",

  theme = "hell",
  env = "!nature",

  prob  = 15,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  can_flip = true,

  texture_pack = "armaetus",
}

--One of the cpu chip is defective, shoot it to open the core! V1,
PREFABS.Item_secret_techmachine1V1_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP09",
  engine = "zdoom",

  theme = "tech",
  env = "!nature",

  prob  = 15,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  can_flip = true,

  texture_pack = "armaetus",

}

--One of the cpu chip is defective, shoot it to open the core! V2,
PREFABS.Item_secret_techmachine1V2_closet =
{
  file  = "item/dem_secret_closets.wad",
  map   = "MAP10",
  engine = "zdoom",

  theme = "tech",
  env = "!nature",

  prob  = 15,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  can_flip = true,

  texture_pack = "armaetus",

}


---- natural shrine getting corrupted by demon with an hidden item, find the switch.----

PREFABS.Item_dem_shrine_secretclosetC =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP11",

  engine = "zdoom",

  prob   = 100,

  key   = "secret",

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

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }

}

PREFABS.Item_dem_shrine_secretclosetN =
{
  template = "Item_dem_shrine_secretclosetC",

  map = "MAP12",
  env = "nature",
  group = "natural_walls",


}


----Natural corner with campsite that have a book than can be used to reveal a dark secret.----

PREFABS.Item_dem_campsiteC_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP13",

  engine = "gzdoom",

  theme = "!hell",

  prob   = 100,

  key   = "secret",

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

PREFABS.Item_dem_campsiteN_secretcloset =
{
  template  = "Item_dem_campsiteC_secretcloset",
  map    = "MAP14",
  env = "nature",

  group = "natural_walls",
}

---- Natural corners with a hidden secret ----

PREFABS.Item_dem_cavein_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP15",

  engine = "zdoom",

  prob   = 100,

  key   = "secret",

  env = "cave",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 88,96 },

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

texture_pack = "armaetus",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }

}

PREFABS.Item_dem_nook_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP16",

  engine = "zdoom",

  theme = "!hell",

  prob   = 100,

  key   = "secret",

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
  }

}

PREFABS.Item_dem_cavestal_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP17",

  engine = "zdoom",

  prob   = 100,

  key   = "secret",

  env = "cave",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 88,96 },

texture_pack = "armaetus",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }

}

----Natural corner with waterfall or lake with a secret----

PREFABS.Pic_dem_waterfallC1_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP18",

  engine = "zdoom",

  theme = "!hell",

  prob   = 100,

  key   = "secret",

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

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }

}

PREFABS.Pic_dem_lakeC1_secretcloset =
{
  template  = "Pic_dem_waterfallC1_secretcloset",
  map    = "MAP19",
}


PREFABS.Pic_dem_waterfallN1_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP20",

  engine = "zdoom",


  theme = "!hell",

  prob   = 100,

  key   = "secret",

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

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    }

}

PREFABS.Pic_dem_lakeN1_secretcloset =
{
  template  = "Pic_dem_waterfallN1_secretcloset",
  map    = "MAP21",
}

---- Jumpy natural closet fabs ----

PREFABS.Pic_dem_jumpy1_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP22",

  engine = "zdoom",

  theme = "!hell",
  height = 192,

  prob   = 100,

  key   = "secret",

  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 192,

  x_fit = "stretch",
  z_fit = { 128,136 },

  texture_pack = "armaetus",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }

}

PREFABS.Pic_dem_jumpy2_secretcloset =
{
  template  = "Pic_dem_jumpy1_secretcloset",
  map    = "MAP23",

  height = 256,
  
  z_fit = { 88,96 },

  bound_z2 = 256,
}

---Garrett blood fountain with a secret---
PREFABS.Item_dem_garrett_fountain1 =
{
  file = "item/dem_secret_closets.wad",
  map  = "MAP24",

  theme = "hell",
  env  = "building",
  prob = 30,

  key = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 48,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit  = "top",
  z_fit  = "top",

  can_flip = true,
}

PREFABS.Item_dem_garrett_fountain2 =
{
  template  = "Item_dem_garrett_fountain1",
  map    = "MAP25",
}

PREFABS.Item_dem_garrett_fountain3 =
{
  template  = "Item_dem_garrett_fountain1",
  map    = "MAP26",
}

---Garrett overturned cross with a secret---
PREFABS.Item_dem_garrett_cross =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP27",

  theme  = "hell",
  env      = "building",
  prob   = 100,

  key = "secret",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep = 48,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,


  x_fit = "frame",
  y_fit  = "top",
  z_fit  = "top",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }

}

---Sgt sharp alcoves with a secret---
PREFABS.Item_dem_gtd_alcove_secret =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP28",

  theme  = "hell",
  env    = "building",
  prob   = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 48,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit  = "top",
  z_fit  = "top",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }
}
