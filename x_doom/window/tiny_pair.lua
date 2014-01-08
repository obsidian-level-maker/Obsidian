--
-- Window with two 64x64 holes
--

DOOM.SKINS.Window_tiny_pair =
{
  file   = "window/tiny_pair.wad"
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

DOOM.SKINS.Window_tall_pair =
{
  file   = "window/tiny_pair.wad"
  where  = "edge"
  long   = 192
  deep   = 32

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 64, 88 }

  prob = 90
}

