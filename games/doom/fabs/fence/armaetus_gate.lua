PREFABS.Bars_armaetus_solid_gate =
{
  file   = "fence/armaetus_gate.wad",
  map    = "MAP01",

  prob   = 75,

  theme  = "!hell",

  where  = "edge",
  key    = "barred",

  seed_w = 2,

  deep   = 16,
  over   = 16,

  fence_h = 32,

  x_fit  = "frame",

  bound_z1 = 0,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Bars_wooden_gate =
{
  template = "Bars_armaetus_solid_gate",
  map      = "MAP02",

  theme    = "!tech",
}

PREFABS.Bars_urban_spikes =
{
  template = "Bars_armaetus_solid_gate",
  map      = "MAP03",

  theme    = "!hell",
}
