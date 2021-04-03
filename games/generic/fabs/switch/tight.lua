PREFABS.Switch_wall_tight =
{
  file   = "switch/tight.wad",

  map = "MAP01",


  prob   = 18,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?switch_tag",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=3, [13]=3 },

}

PREFABS.Switch_wall_tight2 =
{
  template = "Switch_wall_tight",

  map = "MAP02",
}

PREFABS.Switch_wall_tight3 =
{
  template = "Switch_wall_tight",

  map = "MAP03",
}
