--
-- Door requiring two switches to fully open
--

PREFABS.Locked_double =
{
  file   = "door/sw_pair.wad"
  map    = "MAP01"
  where  = "edge"

  x_fit  = "frame"

  long   = 192
  deep   = 16
  over   = 16

  tag_1  = "?lock_tag"

  switch1_special = 23
  switch2_special = 103
}


PREFABS.Locked_double_diag =
{
  file   = "door/sw_pair.wad"
  map    = "MAP02"
  where  = "diagonal"

  tag_1  = "?lock_tag"

  switch1_special = 23
  switch2_special = 103
}

