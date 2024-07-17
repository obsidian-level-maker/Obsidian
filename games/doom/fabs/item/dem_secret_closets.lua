--
--  Secret items closets
--

---- natural shrine getting corrupted by demon with an hidden item, find the switch.----

PREFABS.Item_dem_shrine_secretclosetC =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP11",

  port = "zdoom",

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

  port = "zdoom",

  theme = "!hell",

  prob   = 100,

  key   = "secret",

  env = "cave",

  where  = "seeds",

  jump_crouch = true,

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

  port = "zdoom",

  prob   = 100,

  jump_crouch = true,

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

  port = "zdoom",

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
  },

  tex_BLAKMBGY = "MARBGRAY"

}

PREFABS.Item_dem_cavestal_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP17",

  port = "zdoom",

  prob   = 100,

  key   = "secret",

  env = "cave",

  where  = "seeds",

  jump_crouch = true,

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

  port = "zdoom",

  theme = "!hell",

  prob   = 100,

  key   = "secret",

  env = "cave",

  where  = "seeds",
  jump_crouch = true,

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

  port = "zdoom",


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

  jump_crouch = true
}

---- Jumpy natural closet fabs ----

PREFABS.Pic_dem_jumpy1_secretcloset =
{
  file   = "item/dem_secret_closets.wad",
  map    = "MAP22",

  port = "zdoom",

  theme = "!hell",
  height = 192,

  prob   = 100,

  jump_crouch = true,

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

-- Phytolizer's secret cave nook for Hell's mass 2021---

PREFABS.Item_dem_cavein7_secret =
{
  file = "item/dem_secret_closets.wad",
  map = "MAP29",

  prob = 100,

  key = "secret",
  env = "cave",

  port = "!limit",
  where = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  }
}

-- Secret cavenook with liquid --

PREFABS.Item_dem_cavein23_secret =
{
  template = "Item_dem_cavein7_secret",

  map = "MAP30",

  liquid = true,

  sound = "Water_Streaming",
}
