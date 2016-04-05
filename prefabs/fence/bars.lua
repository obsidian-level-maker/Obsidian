--
-- Lowering bars  (for outdoor locks)
--

PREFABS.Bars_shiny =
{
  file   = "fence/bars.wad"
  map    = "MAP01"
  where  = "edge"

  key    = "barred"

  long   = 192
  deep   = 16
  over   = 16

  z_fit  = "bottom"

  bound_z1 = 0
  bound_z2 = 128

  tag_1 = "?lock_tag"
}


PREFABS.Bars_shiny_diag =
{
  file   = "fence/bars.wad"
  map    = "MAP02"
  where  = "diagonal"

  key    = "barred"

  z_fit  = "bottom"

  bound_z1 = 0
  bound_z2 = 128

  tag_1  = "?lock_tag"
}

