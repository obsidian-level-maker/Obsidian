--
--  Basic item pedestal
--

PREFABS.Item_pedestal =
{
  file  = "item/pedestal.wad",
  where = "point",
  theme = "!tech",

  prob = 50,
}

PREFABS.Item_pedestal_tech =
{
  template = "Item_pedestal",
  theme = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL1_2 = "FLAT20",
}
