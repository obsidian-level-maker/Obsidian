PREFABS.Arch_gtd_beed28_door_crouch =
{
  file = "door/gtd_beed28_doors.wad",
  map = "MAP01",

  style = "doors",

  engine = "zdoom",

  prob = 150,
  theme = "!hell",

  kind = "arch",
  where = "edge",

  deep = 16,
  over = 16,

  seed_w = 2,

  x_fit = "frame",
  z_fit = "top",

  bound_z1 = 0,
  bound_z2 = 130,

  tex_BIGDOOR2 =
  {
    BIGDOOR2 = 50,
    BIGDOOR3 = 50,
    BIGDOOR4 = 50,
  },

  thing_10 =
  {
    gibs = 1,
    gibbed_player = 1,
    dead_player   = 1,
    dead_zombie = 1,
    dead_shooter = 1,
    dead_imp = 1,
    dead_demon = 1,
    [0] = 5,
  }
}

PREFABS.Arch_gtd_beed28_door_usable =
{
  template = "Arch_gtd_beed28_door_crouch",
  map = "MAP02",
}
