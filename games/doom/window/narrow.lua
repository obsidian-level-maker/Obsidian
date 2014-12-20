--
-- Window, narrow and short
--

PREFABS.Window_narrow =
{
  file   = "window/narrow.wad"
  where  = "edge"
  long   = 192
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  prob = 90
}


--
-- Tall version (expands vertically)
--

PREFABS.Window_narrow_tall =
{
  file   = "window/narrow.wad"
  where  = "edge"
  long   = 192
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 72, 96 }

  prob = 90
}


----------------------------------------
--   DIAGONAL VERSIONS
----------------------------------------

PREFABS.Window_narrow_diag =
{
  file   = "window/narrow_dg.wad"
  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 112
}


PREFABS.Window_narrow_tall_diag =
{
  file   = "window/narrow_dg.wad"
  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 72, 96 }
}

