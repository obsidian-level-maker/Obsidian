--
-- Lowering bars  (for outdoor locks)
--

PREFABS.Bars_shiny =
{
  file   = "fence/bars.wad"
  map    = "MAP01"

  prob   = 500

  kind   = "door"
  where  = "edge"
  key    = "barred"

  env      = "outdoor"
  neighbor = "outdoor"

  seed_w = 2
  deep   = 16
  over   = 16

  x_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

  tag_1 = "?door_tag"
  door_action = "S1_LowerFloor"
}


PREFABS.Bars_shiny_diag =
{
  file   = "fence/bars.wad"
  map    = "MAP02"

  prob   = 500

  where  = "diagonal"
  key    = "barred"

  bound_z1 = 0
  bound_z2 = 128

  tag_1  = "?door_tag"
  door_action = "S1_LowerFloor"
}

