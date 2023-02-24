
PREFABS.Pic_bookstore =
{
  file   = "picture/gtd_pic_urban_commercial_frontages.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "urban",

  where  = "seeds",
  height = 128,

  env = "!cave",

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Pic_lounge =
{
  template = "Pic_bookstore",
  map    = "MAP02",

  seed_w = 3,
}

PREFABS.Pic_fresh_produce_grocery =
{
  template = "Pic_bookstore",
  map    = "MAP03",

  seed_w = 3,
}

PREFABS.Pic_bank =
{
  template = "Pic_bookstore",
  map    = "MAP04",
}

PREFABS.Pic_some_sort_of_thing_people_do_in_the_future =
{
  template = "Pic_bookstore",
  map    = "MAP05",

  seed_w = 3,
}

PREFABS.Pic_electronics_store =
{
  template = "Pic_bookstore",
  map    = "MAP06",

  seed_w = 3,
}

PREFABS.Pic_locked_double_door_front =
{
  template = "Pic_bookstore",
  map    = "MAP07",

  seed_w = 3,
  seed_h = 1,
}
