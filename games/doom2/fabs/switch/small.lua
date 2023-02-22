--
-- Small switch
--

PREFABS.Switch_small_sw_blue =
{
  file   = "switch/small.wad",

  key    = "sw_blue",
  prob   = 50,

  where  = "point",
--???  size   = 64,

  tag_1  = "?switch_tag",

  -- prefab has COMPBLUE / FLAT14 textures
}


PREFABS.Switch_small_sw_red =
{
  template = "Switch_small_sw_blue",

  key = "sw_red",

  tex_COMPBLUE = "REDWALL",
  flat_FLAT14  = "REDWALL",
}


PREFABS.Switch_small_sw_metal =
{
  template = "Switch_small_sw_blue",

  key = "sw_metal",

  tex_COMPBLUE = "METAL",
  flat_FLAT14  = "METAL",
}

