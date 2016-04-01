--
-- Archway with bars
--

PREFABS.Arch_barred =
{
  file   = "door/barred_arch.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "barred"

  deep   = 16
  over   = 16

  x_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

  tag_1 = "?lock_tag"
}


PREFABS.Arch_barred_diag =
{
  file   = "door/barred_arch.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "barred"

  bound_z1 = 0
  bound_z2 = 128

  tag_1 = "?lock_tag"
}

