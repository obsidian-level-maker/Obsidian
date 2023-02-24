PREFABS.Item_scionox_simple_crates_pile_on_top =
{
  file = "item/scionox_simple_crates.wad",
  map = "MAP01",

  theme = "!hell",

  prob = 65,
  where = "point",

  height = 128,
  size = 64,
}

PREFABS.Item_scionox_simple_crates_pile_on_top_2 =
{
  template = "Item_scionox_simple_crates_pile_on_top",

  flat_CRATOP2 = "CRATOP1",
  tex_CRATE1 = "CRATE2",
}

PREFABS.Item_scionox_simple_crates_pile_on_side =
{
  template = "Item_scionox_simple_crates_pile_on_top",

  map = "MAP02",

  height = 96,
  size  = 96,
}

PREFABS.Item_scionox_simple_crates_pile_on_side_2 =
{
  template = "Item_scionox_simple_crates_pile_on_top",

  map = "MAP02",

  height = 96,
  size  = 96,

  flat_CRATOP2 = "CRATOP1",
  tex_CRATE1 = "CRATE2",
}

PREFABS.Item_scionox_simple_crates_small_pile =
{
  template = "Item_scionox_simple_crates_pile_on_top",
  map = "MAP03",

  height = 64,

  size  = 48,
}

PREFABS.Item_scionox_simple_crates_big_pile =
{
  template = "Item_scionox_simple_crates_pile_on_top",

  map = "MAP04",

  size  = 96,
}

PREFABS.Item_scionox_simple_crates_big_pile_2 =
{
  template = "Item_scionox_simple_crates_pile_on_top",

  map = "MAP04",

  size  = 96,

  flat_CRATOP2 = "CRATOP1",
  tex_CRATE1 = "CRATE2",
}

PREFABS.Item_scionox_simple_crates_single_pile =
{
  template = "Item_scionox_simple_crates_pile_on_top",
  map = "MAP05",
}

PREFABS.Item_scionox_simple_crates_single_pile_2 =
{
  template = "Item_scionox_simple_crates_pile_on_top",

  map = "MAP05",

  flat_CRATOP2 = "CRATOP1",
  tex_CRATE1 = "CRATE2",
}

PREFABS.Item_scionox_simple_crates_closet_tall =
{
  file   = "item/scionox_simple_crates.wad",
  map    = "MAP06",

  height = 128,

  prob   = 50,
  theme  = "!hell",
  env    = "!cave",

  where  = "seeds",

  seed_w = 1,
  seed_h = 1,

  deep =  16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_scionox_simple_crates_closet_tall_2 =
{
  template = "Item_scionox_simple_crates_closet_tall",

  flat_CRATOP2 = "CRATOP1",
  tex_CRATE1 = "CRATE2",
}

PREFABS.Item_scionox_simple_crates_closet_side =
{
  template = "Item_scionox_simple_crates_closet_tall",

  map = "MAP07",
}

PREFABS.Item_scionox_simple_crates_closet_side_2 =
{
  template = "Item_scionox_simple_crates_closet_tall",

  map = "MAP07",

  flat_CRATOP2 = "CRATOP1",
  tex_CRATE1 = "CRATE2",
}

PREFABS.Item_scionox_simple_crates_cluster =
{
  template = "Item_scionox_simple_crates_closet_tall",

  map = "MAP08",
}
