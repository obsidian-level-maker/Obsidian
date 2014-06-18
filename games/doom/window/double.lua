--
-- Window with two narrow holes
--

PREFABS.Window_double =
{
  file   = "window/double.wad"
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

PREFABS.Window_double_tall =
{
  file   = "window/double.wad"
  where  = "edge"
  long   = 192
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 64, 88 }

  prob = 90
}

