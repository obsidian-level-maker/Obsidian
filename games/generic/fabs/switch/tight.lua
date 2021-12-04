PREFABS.Switch_wall_tight =
{
  file   = "switch/tight.wad",

  map = "MAP01",
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

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

PREFABS.Switch_wall_tight_chex3 =
{
  template   = "Switch_wall_tight",
  game = "chex3",
  map = "MAP02"
}

PREFABS.Switch_wall_tight_hacx =
{
  template   = "Switch_wall_tight",

  game = "hacx",
  forced_offsets = 
  {
    [9] = { x=32,y=0 },
  }
}

PREFABS.Switch_wall_tight_harmony =
{
  template   = "Switch_wall_tight",

  game = "harmony",
  forced_offsets = 
  {
    [9] = { x=16,y=88 },
  }
}

PREFABS.Switch_wall_tight_heretic =
{
  template   = "Switch_wall_tight",

  game = "heretic",
  forced_offsets = 
  {
    [9] = { x=16,y=49 },
  }
}

PREFABS.Switch_wall_tight_hexen =
{
  template   = "Switch_wall_tight",

  game = "hexen",
  forced_offsets = 
  {
    [9] = { x=0,y=96 },
  }
}


PREFABS.Switch_wall_tight_strife =
{
  template   = "Switch_wall_tight",

  game = "strife",
  forced_offsets = 
  {
    [9] = { x=0,y=72 },
  }
}
