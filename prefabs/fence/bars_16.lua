--
-- Lowering bars  (for outdoor locks)
--

PREFABS.Bars_shiny =
{
  file   = "fence/bars_16.wad"
  map    = "MAP01"

  prob   = 100

  where  = "edge"
  key    = "barred"

  seed_w = 2
  deep   = 16
  over   = 16

  fence_h = 32

  x_fit  = "frame"

  bound_z1 = 0

  tag_1  = "?door_tag"
  door_action = "S1_LowerFloor"
}


PREFABS.Bars_shiny_diag =
{
  file   = "fence/bars.wad"
  map    = "MAP02"

  prob   = 100

  where  = "diagonal"
  key    = "barred"

  fence_h = 32

  tag_1  = "?door_tag"
  door_action = "S1_LowerFloor"

  bound_z1 = 0
}

