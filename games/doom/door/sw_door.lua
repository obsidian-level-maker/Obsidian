--
-- Switched doors
--

PREFABS.Locked_sw_blue =
{
  file   = "door/sw_door.wad"
  map    = "MAP01"

  where  = "edge"
  switch = "sw_blue"

  x_fit  = "frame"

  long   = 192
  deep   = 16
  over   = 16

  tag_1  = "?lock_tag"
}

PREFABS.Locked_sw_blue_diag =
{
  file   = "door/sw_door.wad"
  map    = "MAP02"

  where  = "diagonal"
  switch = "sw_blue"

  tag_1  = "?lock_tag"
}



PREFABS.Locked_sw_red =
{
  copy = "Locked_sw_blue"

  switch = "sw_red"

  tex_COMPBLUE = "REDWALL"
  flat_FLAT14  = "REDWALL"
}

PREFABS.Locked_sw_red_diag =
{
  copy = "Locked_sw_blue_diag"

  switch = "sw_red"

  tex_COMPBLUE = "REDWALL"
  flat_FLAT14  = "REDWALL"
}



PREFABS.Locked_sw_ash =
{
  copy = "Locked_sw_blue"

  switch = "sw_ash"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}

PREFABS.Locked_sw_ash_diag =
{
  copy = "Locked_sw_blue_diag"

  switch = "sw_ash"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}



PREFABS.Locked_sw_snake =
{
  copy = "Locked_sw_blue"

  switch = "sw_snake"

  tex_COMPBLUE = "SKSNAKE1"
  flat_FLAT14  = "SKSNAKE1"
}

PREFABS.Locked_sw_snake_diag =
{
  copy = "Locked_sw_blue_diag"

  switch = "sw_snake"

  tex_COMPBLUE = "SKSNAKE1"
  flat_FLAT14  = "SKSNAKE1"
}

