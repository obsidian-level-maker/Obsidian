--
-- Door requiring all three keys
--

PREFABS.Locked_kc_ALL =
{
  file   = "door/three_key.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "kc_ALL"

  x_fit  = "frame"
  long   = 192
  deep   = 68
  over   = 72
}


PREFABS.Locked_ks_ALL =
{
  file   = "door/three_key.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "ks_ALL"

  x_fit  = "frame"
  long   = 192
  deep   = 68
  over   = 72

  tex_DOORRED  = "DOORRED2"
  tex_DOORYEL  = "DOORYEL2"
  tex_DOORBLU  = "DOORBLU2"
}


----------------------------------------
--   DIAGONAL VERSIONS
----------------------------------------

PREFABS.Locked_kc_ALL_diag =
{
  file   = "door/three_key.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "kc_ALL"
}


PREFABS.Locked_ks_ALL_diag =
{
  file   = "door/three_key.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "ks_ALL"

  tex_DOORRED  = "DOORRED2"
  tex_DOORYEL  = "DOORYEL2"
  tex_DOORBLU  = "DOORBLU2"
}

