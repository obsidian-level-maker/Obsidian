--
-- Switched doors
--

PREFABS.Template_locked_door =
{
  file   = "door/sw_door.wad"
  map    = "MAP01"

  where  = "edge"
  x_fit  = "frame"

  long   = 192
  deep   = 16
  over   = 16

  tag_1  = "?lock_tag"
}

PREFABS.Template_locked_door_diag =
{
  file   = "door/sw_door.wad"
  map    = "MAP02"

  where  = "diagonal"

  tag_1  = "?lock_tag"
}

--------------------------------------------------

PREFABS.Locked_sw_blue =
{
  template = "Template_locked_door"

  switch = "sw_blue"
}

PREFABS.Locked_sw_blue_diag =
{
  template = "Template_locked_door_diag"

  switch = "sw_blue"
}


PREFABS.Locked_sw_red =
{
  template = "Template_locked_door"

  switch = "sw_red"

  tex_COMPBLUE = "REDWALL"
  flat_FLAT14  = "REDWALL"
}

PREFABS.Locked_sw_red_diag =
{
  template = "Template_locked_door_diag"

  switch = "sw_red"

  tex_COMPBLUE = "REDWALL"
  flat_FLAT14  = "REDWALL"
}


PREFABS.Locked_sw_ash =
{
  template = "Template_locked_door"

  switch = "sw_ash"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}

PREFABS.Locked_sw_ash_diag =
{
  template = "Template_locked_door_diag"

  switch = "sw_ash"

  tex_COMPBLUE = "ASHWALL2"
  flat_FLAT14  = "FLOOR6_2"
}


PREFABS.Locked_sw_snake =
{
  template = "Template_locked_door"

  switch = "sw_snake"

  tex_COMPBLUE = "SKSNAKE1"
  flat_FLAT14  = "SKSNAKE1"
}

PREFABS.Locked_sw_snake_diag =
{
  template = "Template_locked_door_diag"

  switch = "sw_snake"

  tex_COMPBLUE = "SKSNAKE1"
  flat_FLAT14  = "SKSNAKE1"
}

