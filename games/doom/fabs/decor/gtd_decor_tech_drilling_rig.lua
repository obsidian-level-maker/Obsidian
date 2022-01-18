PREFABS.Decor_tech_drilling_rig =
{
  file = "decor/gtd_decor_tech_drilling_rig.wad",
  map = "MAP01",

  where = "point",

  prob = 10000,
  theme = "tech",
  env = "building",

  size = 132,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  sink_mode = "never",

  delta = 128,

  z_fit = "top"
}

-- group version for mining themed wall set
PREFABS.Decor_tech_drilling_rig_grouped =
{
  template = "Decor_tech_drilling_rig",

  group = "gtd_mining_set"
}
