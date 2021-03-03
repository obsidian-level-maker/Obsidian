PREFABS.Wall_tech_grated_machines_plain =
{
  file = "wall/gtd_wall_tech_grated_machines.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_wall_grated_machines",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Wall_tech_grated_machines_diagonal =
{
  template = "Wall_tech_grated_machines_plain",
  map = "MAP02",

  prob = 50,

  group = "gtd_wall_grated_machines",

  where = "diagonal",
}
