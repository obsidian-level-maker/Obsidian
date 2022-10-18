--
--  Secret items closets
--

--a secret shrine to Nine inch nails where you need to be quick and open the 3 doors on the proper order to acess it.
PREFABS.Item_secret_NIN_closet =
{
  file  = "item/dem_secret_closets_hell.wad",
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
  file  = "item/dem_secret_closets_hell.wad",
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
  file  = "item/dem_secret_closets_hell.wad",
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
  file  = "item/dem_secret_closets_hell.wad",
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
  file  = "item/dem_secret_closets_hell.wad",
  map   = "MAP07",
  port = "zdoom",

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
  file  = "item/dem_secret_closets_hell.wad",
  map   = "MAP08",
  port = "zdoom",

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

---Garrett blood fountain with a secret---
PREFABS.Item_dem_garrett_fountain1 =
{
  file = "item/dem_secret_closets_hell.wad",
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
  file   = "item/dem_secret_closets_hell.wad",
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
  file   = "item/dem_secret_closets_hell.wad",
  map    = "MAP28",

  port = "zdoom",
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

--Sgt's new flesh machine secret --
PREFABS.Item_secret_hellmachine2_closet =
{
  file  = "item/dem_secret_closets_hell.wad",
  map   = "MAP31",
  port = "zdoom",

  theme = "hell",
  env = "!nature",

  prob  = 30,

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

--a shrine in a hell rift without an item, an eye hidden will reveal something.--
PREFABS.Item_secret_dem_rift_closet =
{
  file  = "item/dem_secret_closets_hell.wad",
  map   = "MAP32",

  port = "zdoom",

  theme = "hell",
  prob  = 100,

  key   = "secret",

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
