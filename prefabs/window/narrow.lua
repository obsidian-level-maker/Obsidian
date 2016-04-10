--
-- Window, narrow and short
--

PREFABS.Window_narrow =
{
  file   = "window/narrow.wad"
  map    = "MAP01"
  where  = "edge"

  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  height = 128
}


PREFABS.Window_narrow_diag =
{
  file   = "window/narrow.wad"
  map    = "MAP02"
  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 112

  height = 128
}


--------------------------------------------------------

--
-- Tall version (expands vertically)
--

UNFINISHED.Window_narrow_tall =
{
  file   = "window/narrow.wad"
  map    = "MAP01"
  where  = "edge"

  group  = "win_tall"

  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 72, 96 }

  prob = 90
}


UNFINISHED.Window_narrow_tall_diag =
{
  file   = "window/narrow.wad"
  map    = "MAP02"
  where  = "diagonal"

  group  = "win_tall"

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 72, 96 }
}

