--
-- a simple, narrow bridge
--

PREFABS.Bridge_narrow1 =
{
  file   = "bridge/narrow.wad",
  map    = "MAP01",

  prob   = 90,

  where  = "point",
}

PREFABS.Bridge_narrow1_hell =
{
  template   = "Bridge_narrow1",
  map    = "MAP01",
  theme  = "hell",

  tex_SUPPORT3 = "WOOD1",
  tex_SUPPORT2 = "SUPPORT3",
  flat_FLAT20  = "CEIL5_2",
  flat_CEIL5_2 = "FLAT5_2",
}
