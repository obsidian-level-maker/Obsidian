PREFABS.Wall_tech_server_wall =
{
  file   = "wall/gtd_wall_tech_server_room.wad",
  map    = "MAP01",

  prob   = 300,
  theme  = "tech",
  env = "building",

  group = "gtd_wall_server_room",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_tech_server_wall_diag =
{
  file   = "wall/gtd_wall_tech_server_room.wad",
  map    = "MAP02",

  prob   = 50,
  theme = "tech",
  group = "gtd_wall_server_room",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_tech_server_wall1 =
{
  template = "Wall_tech_server_wall",

  prob = 50,

  map = "MAP03",
}

PREFABS.Wall_tech_server_wall2 =
{
  template = "Wall_tech_server_wall",

  prob = 50,

  map = "MAP04",
}

PREFABS.Wall_tech_server_wall3 =
{
  template = "Wall_tech_server_wall",

  prob = 50,

  map = "MAP05",
}

-- Epic versions:

PREFABS.Wall_tech_server_room_diag_EPIC =
{
  file   = "wall/gtd_wall_tech_server_room.wad",
  map    = "MAP07",

  prob   = 50,
  theme = "tech",
  group = "gtd_wall_server_room2",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_tech_server_room1_EPIC =
{
  template = "Wall_tech_server_wall",

  group = "gtd_wall_server_room2",

  prob = 50,

  map = "MAP06",

  tex_COMPSD1 = { COMPSD1=50, COMPFUZ1=50, COMPY1=50, COMPCT07=20 },
}

PREFABS.Wall_tech_server_room2_EPIC =
{
  template = "Wall_tech_server_wall",

  group = "gtd_wall_server_room2",

  prob = 200,

  map = "MAP08",
}
