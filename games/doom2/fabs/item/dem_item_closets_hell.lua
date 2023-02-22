--
--  item closets
--

--a item in a maze of mirrors1 in hell
PREFABS.Item_dem_mirrormaze_closet =
{
  file  = "item/dem_item_closets_hell.wad",
  map   = "MAP01",

  port = "zdoom",

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
  file  = "item/dem_item_closets_hell.wad",
  map   = "MAP03",

  port = "zdoom",

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

--a item in a scrying room in hell
PREFABS.Item_dem_scrying1_closet =
{
  file  = "item/dem_item_closets_hell.wad",
  map   = "MAP16",

  port = "zdoom",

  theme = "hell",
  prob  = 250,

  texture_pack = "armaetus",
  replaces = "Item_dem_scrying1_closet_vanilla",

  where  = "seeds",
  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "frame",
}

PREFABS.Item_dem_scrying1_closet_vanilla =
{
  file  = "item/dem_item_closets_hell.wad",
  map   = "MAP16",

  port = "zdoom",

  theme = "hell",
  prob  = 250,

  where  = "seeds",
  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "frame",

  tex_CRACKRD2 = "CRACKLE4",
  flat_FLOOR7_3 = "RROCK03"
}

--a item in a scrying room in hell
PREFABS.Item_dem_scrying2_closet =
{
  file  = "item/dem_item_closets_hell.wad",
  map   = "MAP17",

  port = "zdoom",

  theme = "hell",
  prob  = 100,

  texture_pack = "armaetus",
  replaces = "Item_dem_scrying2_closet_vanilla",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",
}

PREFABS.Item_dem_scrying2_closet_vanilla =
{
  file  = "item/dem_item_closets_hell.wad",
  map   = "MAP17",

  port = "zdoom",

  theme = "hell",
  prob  = 100,

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit  = "frame",

  tex_CRACKRD2 = "CRACKLE4",
  flat_FLOOR7_3 = "RROCK03"
}
