-- Pick one of four doors, sir! One has what you seek,
-- the others may end you!

PREFABS.Item_gtd_gameshow_doors_1 =
{
  file  = "item/gtd_item_gameshow_doors.wad",
  map    = "MAP01",

  prob   = 6,

  theme  = "!hell",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  over = 16,
  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_gtd_gameshow_doors_2 =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP02",
}

PREFABS.Item_gtd_gameshow_doors_3 =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP03",
}

PREFABS.Item_gtd_gameshow_doors_4 =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP04",
}

PREFABS.Item_gtd_gameshow_doors_1_hell =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP01",

  theme = "hell",

  tex_DOOR1 = "WOODMET1",
  flat_FLAT19 = "FLOOR6_1",
}

PREFABS.Item_gtd_gameshow_doors_2_hell =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP02",

  theme = "hell",

  tex_DOOR1 = "WOODMET1",
  flat_FLAT19 = "FLOOR6_1",
}

PREFABS.Item_gtd_gameshow_doors_3_hell =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP03",

  theme = "hell",

  tex_DOOR1 = "WOODMET1",
  flat_FLAT19 = "FLOOR6_1",
}

PREFABS.Item_gtd_gameshow_doors_4_hell =
{
  template = "Item_gtd_gameshow_doors_1",
  map = "MAP04",

  theme = "hell",

  tex_DOOR1 = "WOODMET1",
  flat_FLAT19 = "FLOOR6_1",
}
