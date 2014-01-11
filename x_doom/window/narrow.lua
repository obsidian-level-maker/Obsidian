--
-- Window, narrow and short
--

DOOM.SKINS.Window_narrow =
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

DOOM.SKINS.Window_narrow_tall =
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

