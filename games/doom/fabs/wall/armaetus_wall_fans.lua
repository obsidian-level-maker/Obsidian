PREFABS.Wall_armaetus_fan_general =
{
  file = "wall/armaetus_wall_fans.wad",
  map = "MAP01",

  texture_pack = "armaetus",

  prob = 20,

  theme = "!hell",
  env = "building",

  height = 128,
  where = "edge",
  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  sound = "Indoor_Fan",
}

PREFABS.Wall_armaetus_fan_hell =
{
  template = "Wall_armaetus_fan_general",
  map = "MAP01",

  theme = "hell",

  tex_DOORSTOP = "METAL",

  prob = 3,
}
