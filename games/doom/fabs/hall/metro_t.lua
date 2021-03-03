PREFABS.Hallway_metro_t =
{
  file   = "hall/metro_t.wad",
  map    = "MAP01",

  engine = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "T",

  seed_w = 2,
  seed_h = 2,
}

PREFABS.Hallway_metro_t_plain =
{
  template = "Hallway_metro_t",
  map = "MAP02",
}

-- slopeless engine fallback

PREFABS.Hallway_metro_t_boxy =
{
  template = "Hallway_metro_t",
  map = "MAP10",

  engine = "any",

  prob = 20,
}

PREFABS.Hallway_metro_t_boxy_vending_machine =
{
  template = "Hallway_metro_t",
  map = "MAP11",

  theme = "!hell",

  engine = "zdoom",

  texture_pack = "armaetus",

  prob = 25,

  tex_OBVNMCH1 =
  {
    OBVNMCH1 = 50,
    OBVNMCH2 = 50,
    OBVNMCH3 = 50,
    OBVNMCH4 = 50,
    OBVNMCH5 = 50,
  }
}
