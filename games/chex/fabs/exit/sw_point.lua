--
--  Sewer themed exit switch
--

PREFABS.Exit_point =
{
  file   = "exit/sw_point.wad",
  map    = "MAP01",
  theme  = "bazoik",
  prob   = 5,
  where  = "point",
}

PREFABS.Exit_point_secret =
{
  template = "Exit_point",

  kind   = "secret_exit"
}
