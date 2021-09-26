--
--  Exit switch for Heretic
--

PREFABS.Exit_point =
{
  file   = "exit/sw_point.wad",
  map    = "MAP01",
  game = { heretic=1,hacx=1,chex3=0,strife=1,harmony=1 },
  prob   = 5,
  where  = "point",
}

PREFABS.Exit_point_chex3 =
{
  file   = "exit/sw_point.wad",
  map    = "MAP01",
  game = "chex3",
  prob   = 5,
  where  = "point",

  tex__EXITSW1 = "SW1CMT",
  flat__EXITSW1 = "FLOOR0_1",
  tex__FLOOR = "SEWER1",
  flat__FLOOR = "FLOOR0_1",

  forced_offsets =
  {
    [2] = { x=9,y=52 },
    [6] = { x=9,y=52 },
    [12] = { x=23,y=-92 },
    [16] = { x=23,y=-92 },
    [18] = { x=23,y=-92 },
    [22] = { x=23,y=-92 },
    [14] = { x=17,y=36 },
    [20] = { x=17,y=36 },
    [0] =  {x=25,y=-15 },
    [4] =  {x=25,y=-15 },
  }
}

PREFABS.Exit_point_secret =
{
  file   = "exit/sw_point.wad",
  map    = "MAP02",

  prob   = 5,

  kind   = "secret_exit",
  where  = "point",
}

PREFABS.Exit_point_secret_chex3 =
{
  template   = "Exit_point_chex3",
  map    = "MAP02",
  kind   = "secret_exit",
}

