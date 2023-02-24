PREFABS.Hallway_vent_tech_comp1 =
{
  file   = "hall/vent_i_tech.wad",
  map    = "MAP01",

  theme  = "!hell",
  group  = "vent",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  sector_1 = {[0] = 2, [1] = 1, [2] = 1, [3] = 1, [21] = 1},

  can_flip = true,
}

PREFABS.Hallway_vent_tech_comp2 =
{
  template = "Hallway_vent_tech_comp1",
  map = "MAP02",
}

PREFABS.Hallway_vent_tech_tek_grates =
{
  template = "Hallway_vent_tech_comp1",
  map = "MAP03",
}

PREFABS.Hallway_vent_tech_bump =
{
  template = "Hallway_vent_tech_comp1",
  map = "MAP04",
}

PREFABS.Hallway_vent_tech_dip =
{
  template = "Hallway_vent_tech_comp1",
  map = "MAP05",
}
