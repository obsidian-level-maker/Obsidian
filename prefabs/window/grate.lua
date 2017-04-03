--
-- Window, wide but vertically short
--

UNFINISHED.Window_wide =
{
  file   = "window/wide.wad"
  map    = "MAP01"

  prob = 90

  where  = "edge"
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112
}


UNFINISHED.Window_wide_diag =
{
  file   = "window/wide.wad"
  map    = "MAP02"

  prob   = 50

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

  prob = 90

  where  = "edge"
  deep   = 16
  over   = 16

  z_fit = { 64, 88 }

  bound_z1 = 0
  bound_z2 = 112
}


UNFINISHED.Window_wide_tall_diag =
{
  file   = "window/wide.wad"
  map    = "MAP02"

  prob   = 50

  where  = "diagonal"

  z_fit = { 64, 88 }

  bound_z1 = 0
  bound_z2 = 112
}

