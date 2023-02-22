PREFABS.Pic_grocery_shelf_EPIC =
{
  file = "picture/gtd_pic_urban_grocery_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  where = "seeds",
  height = 128,

  group = "gtd_grocery",

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,

  x_fit = { 120,136 },
  y_fit = "top",

  tex_DNSTOR01 =
  {
    DNSTOR01 = 5,
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 12
  }
}

PREFABS.Pic_grocery_shelf_2_EPIC =
{
  template = "Pic_grocery_shelf_EPIC",

  group = "gtd_grocery_2"
}
