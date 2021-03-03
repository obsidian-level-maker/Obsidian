PREFABS.Item_tech_window =
{
  file   = "item/gtd_item_tech_window.wad",
  map    = "MAP01",

  engine = "zdoom",
  game   = "doom2",

  prob   = 50,
  theme  = "!hell",
  env    = "building",

  where  = "seeds",

  seed_w = 2,
  seed_h = 1,

  deep =  16,
  over = -16,

  bound_z1 = 0,

  y_fit = "top",
  x_fit = "frame",

  sound = "Outdoors_Tech",
}

PREFABS.Item_tech_window_doom1 =
{
  template   = "Item_tech_window",
  map    = "MAP01",
  game   = "doom",

  tex_BRONZE4 = "BROWN96",
}

PREFABS.Item_tech_window_2 =
{
  file   = "item/gtd_item_tech_window.wad",
  map    = "MAP02",

  prob   = 50,
  theme  = "!hell",
  env    = "building",

  where  = "seeds",

  seed_w = 2,
  seed_h = 1,

  deep =  16,

  bound_z1 = 0,

  y_fit = "top",
  x_fit = "frame",

  sound = "Outdoors_Tech",
}
