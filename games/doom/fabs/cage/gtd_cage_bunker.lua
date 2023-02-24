PREFABS.Cage_wall_bunker_tech =
{
  file   = "cage/gtd_cage_bunker.wad",

  prob  = 800,

  theme  = "tech",

  where  = "seeds",
  shape  = "U",

  height = 112,

  seed_w = 2,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = { 120,136 },
  y_fit = "top",

  sector_8  = { [8]=60, [2]=10, [3]=10, [17]=10, [21]=5 },

  tex_DOOR3 =
  {
    DOOR1=50,
    DOOR3=50,
  }
}

PREFABS.Cage_wall_bunker_hell =
{
  template = "Cage_wall_bunker_tech",

  theme    = "hell",

  tex_DOOR3 = "WOODMET1",
}
