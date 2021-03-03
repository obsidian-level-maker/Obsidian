PREFABS.Wall_hell_thin_vaulted_outdoor =
{
  file   = "wall/gtd_wall_steel_arch.wad",
  map    = "MAP01",

  prob   = 50,
  env   = "!building",
  theme = "!tech",

  where  = "edge",
  height = 128,
  deep   = 20,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  z_fit = { 72-32,72-16 },
}

PREFABS.Wall_hell_thin_vaulted_outdoor_diagonal =
{
  template = "Wall_hell_thin_vaulted_outdoor",
  map  = "MAP02",

  deep = 16,

  where = "diagonal",
}
