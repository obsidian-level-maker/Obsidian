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

  theme = "any",

  group = "gtd_mining_set"
}

PREFABS.Decor_tech_drilling_rig_small_grouped =
{
  template = "Decor_tech_drilling_rig",
  map = "MAP02",

  theme = "any",

  size = 96,
  height = 96,

  group = "gtd_mining_set",

  bound_z2 = 96
}

PREFABS.Decor_tech_drilling_rig_empty_grouped =
{
  template = "Decor_tech_drilling_rig",
  map = "MAP03",

  prob = 18000,

  theme = "any",

  size = 128,
  height = 48,

  group = "gtd_mining_set",

  delta = 16,

  bound_z2 = 48
}
