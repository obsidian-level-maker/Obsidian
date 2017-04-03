--
-- Window with two narrow holes
--

UNFINISHED.Window_double =
{
  file   = "window/double.wad"

  prob   = 90

  where  = "edge"
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112
}


--
-- Tall version (expands vertically)
--

UNFINISHED.Window_double_tall =
{
  file   = "window/double.wad"

  prob   = 90

  where  = "edge"
  deep   = 16
  over   = 16

  bound_z1 = 0
  bound_z2 = 112

  z_fit = { 64, 88 }
}

