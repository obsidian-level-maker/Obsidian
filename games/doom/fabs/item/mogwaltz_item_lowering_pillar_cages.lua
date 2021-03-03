PREFABS.Item_mogwaltz_lowering_pillar =
{
  file = "item/mogwaltz_item_lowering_pillar_cages.wad",
  map = "MAP01",

  prob = 18,

  theme = "tech",

  style = "traps",

  where = "seeds",
  seed_w = 3,
  seed_h = 2,

  over = -16,
  deep = 16,

  x_fit = "frame",
  y_fit = "top",

  tex_SUPPORT3 = "DOORSTOP",

  sector_1 =
  {
    [0]=50,
    [1]=50,
    [21]=50,
  },

  thing_2028 =
  {
    [2028] = 50,
    [85] = 50,
    [86] = 50,
  }
}

PREFABS.Item_mogwaltz_lowering_pillar_inactive =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP02",
}

-- gothic version for both urban and hell

PREFABS.Item_mogwaltz_lowering_pillar_gothic =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP01",

  theme = "!tech",

  tex_COMPWERD =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFACE = 50,
  },

  thing_2028 =
  {
    [35]=50,
    [44]=50,
    [45]=50,
    [46]=50,
  }
}

PREFABS.Item_mogwaltz_lowering_pillar_gothic_inactive =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP02",

  theme = "!tech",

  tex_COMPWERD =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFACE = 50,
  },

  thing_2028 =
  {
    [35]=50,
    [44]=50,
    [45]=50,
    [46]=50,
  }
}

PREFABS.Item_mogwaltz_lowering_pillar_alt =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP03",

  prob = 10,

  style = "traps",

  theme = "!hell",
}

PREFABS.Item_mogwaltz_lowering_pillar_alt_fast =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP03",

  prob = 10,

  style = "traps",

  theme = "!hell",

  line_24840 = 24848,
}

PREFABS.Item_mogwaltz_lowering_pillar_alt_caged =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP04",

  prob = 10,

  style = "traps",

  theme = "!hell",
}

PREFABS.Item_mogwaltz_lowering_pillar_alt_lowering =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP05",

  prob = 10,

  style = "traps",

  theme = "!hell",
}

PREFABS.Item_mogwaltz_lowering_pillar_joke_is_on_you =
{
  template = "Item_mogwaltz_lowering_pillar",
  map = "MAP06",

  prob = 10,

  theme = "!hell",
}
