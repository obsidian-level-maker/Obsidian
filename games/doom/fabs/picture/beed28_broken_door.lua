PREFABS.Pic_beed28_broken_door =
{
  file   = "picture/beed28_broken_door.wad",
  map    = "MAP01",

  prob   = 12,
  env   = "building",
  theme = "!hell",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  tex_BIGDOOR2 =
  {
    BIGDOOR2 = 50,
    BIGDOOR3 = 50,
    BIGDOOR4 = 50,
  },

  thing_10 =
  {
    gibs = 1,
    gibbed_player = 1,
    dead_player   = 1,
    dead_zombie = 1,
    dead_shooter = 1,
    dead_imp = 1,
    dead_demon = 1,
    [0] = 5,
  },

  sound = "Electric_Sparks",
}

PREFABS.Pic_beed28_broken_door2 =
{
  template = "Pic_beed28_broken_door",

  map = "MAP02",
}
