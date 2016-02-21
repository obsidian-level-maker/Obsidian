--
-- Door with raising bars (remote activated)
--

PREFABS.Door_with_bars =
{
  file   = "door/door_w_bars.wad"
  map    = "MAP01"

  where  = "edge"
  switch = "sw_blue"

  x_fit  = "frame"

  long   = 192
  deep   = 16
  over   = 16

  tex_COMPBLUE = "GRAY1"
  flat_FLAT14  = "GRAY1"

  tag_1 = "?lock_tag"
}


PREFABS.Door_with_bars_diag =
{
  file   = "door/door_w_bars.wad"
  map    = "MAP02"

  where  = "diagonal"
  switch = "sw_blue"

  tag_1  = "?lock_tag"
}

