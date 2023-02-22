PREFABS.Wall_cafeteria_food_trays =
{
  file = "wall/gtd_wall_industrial_cafeteria_set_EPIC.wad",
  map = "MAP01",

  prob = 100,

  group = "gtd_wall_cafeteria_set",

  where = "edge",
  deep = 24,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_cafeteria_food_trays_empty =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP02",
}

PREFABS.Wall_cafeteria_plain =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP03",

  prob = 25,

  deep = 16
}

PREFABS.Wall_cafeteria_inset_vending_machine =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP04",

  prob = 5,

  height = 104,
  deep = 16,

  tex_OBVNMCH1 =
  {
    OBVNMCH1 = 5,
    OBVNMCH2 = 5,
    OBVNMCH3 = 5,
    OBVNMCH4 = 5,
    OBVNMCH5 = 5
  },

  bound_z2 = 104
}

PREFABS.Wall_cafeteria_long_chair =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP05",

  prob = 15,

  deep = 40
}

PREFABS.Wall_cafeteria_food_dispenser =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP06",

  prob = 10,

  deep = 16
}

PREFABS.Wall_cafeteria_disposal_chute =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP07",

  prob = 5,

  deep = 16
}

PREFABS.Wall_cafeteria_food_dispenser_2 =
{
  template = "Wall_cafeteria_food_trays",
  map = "MAP07",

  prob = 10,

  deep = 16
}