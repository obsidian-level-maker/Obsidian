PREFABS.Switch_armaetus_epic_1 =
{
  file   = "switch/armaetus_epic_switches.wad",

  map = "MAP01",

  theme = "!tech",

  prob   = 15,

  where  = "seeds",

  height = 128,

  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  texture_pack = "armaetus",

  x_fit = "frame",
  y_fit = "top",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=3, [13]=3 },

  tag_1 = "?switch_tag",
}

PREFABS.Switch_armaetus_huge_skull =
{
  template = "Switch_armaetus_epic_1",

  map = "MAP02",

  height = 96,
}

PREFABS.Switch_armaetus_pentagram =
{
  template = "Switch_armaetus_epic_1",

  map = "MAP03",

  height = 112,
}

PREFABS.Switch_armaetus_mouth_ring_lever =
{
  template = "Switch_armaetus_epic_1",

  map = "MAP04",

  height = 96,
}
