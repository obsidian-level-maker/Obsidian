--
-- Small switch
--

PREFABS.Switch_small_sw_blue =
{
  file   = "switch/small.wad"
  where  = "point"
  size   = 64

  switch = "sw_blue"

  tag_1  = "?lock_tag"

  -- prefab has COMPBLUE / FLAT14 textures
}


PREFABS.Switch_small_sw_red =
{
  template = "Switch_small_sw_blue"

  switch = "sw_red"

  tex_COMPBLUE = "REDWALL"
  flat_FLAT14  = "REDWALL"
}


PREFABS.Switch_small_sw_ash =
{
  template = "Switch_small_sw_blue"

  switch = "sw_ash"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}


PREFABS.Switch_small_sw_snake =
{
  template = "Switch_small_sw_blue"

  switch = "sw_snake"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}


PREFABS.Switch_small_sw_metal =
{
  template = "Switch_small_sw_blue"

  switch = "sw_metal"

  tex_COMPBLUE = "METAL"
  flat_FLAT14  = "METAL"
}

