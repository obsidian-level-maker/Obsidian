--
-- a window with thick bars
--

PREFABS.Window_barred1 =
{
  file   = "window/barred.wad"
  map    = "MAP01"

  group  = "barred"
  prob   = 50

  where  = "edge"
  seed_w = 1

  deep   = 16
  over   = 16
  height = 128

  bound_z1 = 0
  bound_z2 = 128
}


PREFABS.Window_barred2 =
{
  template = "Window_barred1"

  map      = "MAP02"
  seed_w   = 2
}


PREFABS.Window_barred3 =
{
  template = "Window_barred1"

  map      = "MAP03"
  seed_w   = 3
}

