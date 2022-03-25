PREFABS.Exit_immersive_point_exit1 =
{
  file   = "exit/gtd_generic_immersive_point_exit.wad",
  map    = "MAP01",

  where  = "point",

  prob   = 1000
}

PREFABS.Exit_immersive_point_exit2 =
{
  template = "Exit_immersive_point_exit1",
  map = "MAP02"
}

PREFABS.Exit_immersive_point_portable_nuke =
{
  template = "Exit_immersive_point_exit1",
  map = "MAP03",

  height = 136,

  size = 64
}

PREFABS.Exit_immersive_point_exit_door =
{
  template = "Exit_immersive_point_exit1",
  map = "MAP04",

  size = 72,

  tex_DOOR1 =
  {
    DOOR1 = 5,
    DOOR3 = 5,
    EXITDOOR = 10
  }
}

PREFABS.Exit_immersive_point_exit_door2 =
{
  template = "Exit_immersive_point_exit1",
  map = "MAP05",

  size = 84
}