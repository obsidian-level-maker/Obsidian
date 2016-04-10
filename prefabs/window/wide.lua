--
-- Window, wide but vertically short
--

UNFINISHED.Window_wide =
{
  file   = "window/wide.wad"
  map    = "MAP01"

  where  = "edge"

  long   = 192
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  prob = 90
}


UNFINISHED.Window_wide_diag =
{
  file   = "window/wide.wad"
  map    = "MAP02"

  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 112
}


----------------------------------------------------

--
-- Tall version (expands vertically)
--

UNFINISHED.Window_wide_tall =
{
  file   = "window/wide.wad"
  map    = "MAP01"

  where  = "edge"

  long   = 192
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 64, 88 }

  prob = 90
}


UNFINISHED.Window_wide_tall_diag =
{
  file   = "window/wide.wad"
  map    = "MAP02"

  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 64, 88 }
}

