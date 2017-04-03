--
-- Window, narrow and short
--

PREFABS.Window_narrow =
{
  file   = "window/narrow.wad"
  map    = "MAP01"

  prob   = 50

  where  = "edge"
  deep   = 16
  over   = 16
  height = 128

  x_fit  = "frame"
--z_fit  = "top"

  bound_z1 = 0
  bound_z2 = 112
}


PREFABS.Window_narrow_diag =
{
  file   = "window/narrow.wad"
  map    = "MAP02"

  prob   = 50

  where  = "diagonal"
  height = 128

--z_fit  = "top"

  bound_z1 = 0
  bound_z2 = 112

}


--------------------------------------------------------

--
-- Tall version (expands vertically)
--

UNFINISHED.Window_narrow_tall =
{
  file   = "window/narrow.wad"
  map    = "MAP01"

  prob   = 90
  group  = "win_tall"

  where  = "edge"
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 72, 96 }
}


UNFINISHED.Window_narrow_tall_diag =
{
  file   = "window/narrow.wad"
  map    = "MAP02"

  prob   = 50
  group  = "win_tall"

  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 72, 96 }
}

