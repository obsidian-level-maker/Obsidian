PREFABS.Item_craneo_marble_key_trap =
{
  file  = "item/craneo_item_marble_key_trap.wad",

  map   = "MAP01",

  style = "traps",

  rank  = 2,
  prob  = 400,
  theme = "!tech",
  env   = "outdoor",

  texture_pack = "armaetus",

  where = "seeds",
  height = 160,

  seed_w = 3,
  seed_h = 2,

  item_kind = "key",

  x_fit = "frame",

  open_to_sky = true,

  flat_CARPET5 =
  {
    CARPET5 = 50,
    CARPET7 = 50,
    CARPET8 = 50,
  },

  tex_MARBFACF =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFAC6 = 50,
    MARBFAC7 = 50,
    MARBFACF = 50,
  }
}

PREFABS.Item_craneo_marble_item_trap_interior =
{
  file  = "item/craneo_item_marble_key_trap.wad",

  map   = "MAP02",

  style = "traps",

  texture_pack = "armaetus",

  prob  = 30,
  theme = "!tech",

  where = "seeds",
  height = 128,

  seed_w = 3,
  seed_h = 2,


  flat_CARPET5 =
  {
    CARPET5 = 50,
    CARPET7 = 50,
    CARPET8 = 50,
  },

  tex_MARBFACF =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFAC6 = 50,
    MARBFAC7 = 50,
    MARBFACF = 50,
  },

  x_fit = "frame",
  y_fit = "top",
}
