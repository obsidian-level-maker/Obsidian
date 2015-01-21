--
-- Small switch
--

PREFABS.Switch_small_sw_blue =
{
  file   = "switch/small.wad"
  where  = "middle"
  switch = "sw_blue"

  tag_1 = "?lock_tag"

  line_103 = "?special"
}


PREFABS.Switch_small_sw_red =
{
  copy = "Switch_small_sw_blue"

  switch = "sw_red"

  tex_COMPBLUE = "REDWALL"
  flat_FLAT14  = "REDWALL"
}


PREFABS.Switch_small_sw_ash =
{
  copy = "Switch_small_sw_blue"

  switch = "sw_ash"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}


PREFABS.Switch_small_sw_snake =
{
  copy = "Switch_small_sw_blue"

  switch = "sw_snake"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}


PREFABS.Switch_small_sw_metal =
{
  copy = "Switch_small_sw_blue"

  switch = "sw_metal"

  tex_COMPBLUE = "METAL"
  flat_FLAT14  = "METAL"
}

