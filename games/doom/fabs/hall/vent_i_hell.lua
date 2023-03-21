PREFABS.Hallway_vent_arch =
{
  file   = "hall/vent_i_hell.wad",
  map    = "MAP01",

  nolimit_compat = true,

  theme  = "hell",
  group  = "vent",
  prob   = 35,

  where  = "seeds",
  shape  = "I",
}

PREFABS.Hallway_vent_arch_once =
{
  template = "Hallway_vent_arch",
  map = "MAP02",

  can_flip = true,
}