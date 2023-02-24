PREFABS.Decor_grocery_shelf_1x =
{
  file = "decor/gtd_decor_urban_grocery_set_EPIC.wad",
  map = "MAP01",

  prob = 5000,

  where = "point",

  size = 104,
  height = 128,

  group = "gtd_grocery",

  bound_z1 = 0,
  bound_z2 = 128,

  tex_DNSTOR02 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },

  tex_DNSTOR03 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  }
}

PREFABS.Decor_grocery_shelf_2x =
{
  template = "Decor_grocery_shelf_1x",
  map = "MAP02",

  tex_DNSTOR02 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },

  tex_DNSTOR03 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },
  
  tex_DNSTOR04 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },

  tex_DNSTOR05 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  }
}

PREFABS.Decor_grocery_counter =
{
  template = "Decor_grocery_shelf_1x",
  map = "MAP03",

  prob = 1500,

  height = 72,

  size = 80,

  tex_DNSTOR03 = "DNSTOR03"
}

PREFABS.Decor_grocery_shelf_square =
{
  template = "Decor_grocery_shelf_1x",
  map = "MAP04",

  height = 88,

  size = 80,

  tex_DNSTOR02 = "DNSTOR02",
  tex_DNSTOR04 = "DNSTOR04"
}

--

PREFABS.Decor_grocery_shelf_1x_group_2 =
{
  template = "Decor_grocery_shelf_1x",

  group = "gtd_grocery_2"
}

PREFABS.Decor_grocery_shelf_2x_group_2 =
{
  template = "Decor_grocery_shelf_1x",
  map = "MAP02",

  group = "gtd_grocery_2",

  tex_DNSTOR02 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },

  tex_DNSTOR03 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },
  
  tex_DNSTOR04 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  },

  tex_DNSTOR05 =
  {
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 20,
  }
}

PREFABS.Decor_grocery_counter_group_2 =
{
  template = "Decor_grocery_shelf_1x",
  map = "MAP03",

  prob = 1500,

  group = "gtd_grocery_2",

  height = 72,

  size = 80,

  tex_DNSTOR03 = "DNSTOR03"
}

PREFABS.Decor_grocery_shelf_square_group_2 =
{
  template = "Decor_grocery_shelf_1x",
  map = "MAP04",

  group = "gtd_grocery_2",

  height = 88,

  size = 80,

  tex_DNSTOR02 = "DNSTOR02",
  tex_DNSTOR04 = "DNSTOR04"
}
