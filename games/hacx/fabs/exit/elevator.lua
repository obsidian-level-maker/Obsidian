--
-- Simple exit closet (with door)
--

PREFABS.Exit_elevator =
{
  file  = "exit/elevator.wad",
  map   = "MAP01",

  prob  = 80,

  where = "seeds",
  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  start_fab_peer = "Start_elevator",
}