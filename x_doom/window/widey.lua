--
-- Window, wide but vertically short
--

DOOM.SKINS.Window_wide_short =
{
  file   = "window/widey.wad"
  where  = "edge"
  long   = 192
  deep   = 32

  bound_z1 = 0
  bound_z2 = 112

  prob = 90
}


--
-- Tall version (expands vertically)
--

DOOM.SKINS.Window_wide_tall =
{
  file   = "window/widey.wad"
  where  = "edge"
  long   = 192
  deep   = 32

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 64, 88 }

  prob = 90
}

