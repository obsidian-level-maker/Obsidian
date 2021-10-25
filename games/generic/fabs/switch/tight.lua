PREFABS.Switch_wall_tight =
{
  file   = "switch/tight.wad",

  map = "MAP01",
  game = "heretic",

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

PREFABS.Switch_wall_tight_doomish =
{
  template   = "Switch_wall_tight",

  game = { doom1=1, doom2=1 },
  forced_offsets = 
  {
    [8] = { x=4,y=72 },
    [9] = { x=4,y=72 },
    [10] = { x=4,y=72 },
  }
}

PREFABS.Switch_wall_tight_chex3 =
{
  template   = "Switch_wall_tight",

  game = "chex3",
  forced_offsets = 
  {
    [8] = { x=4,y=76 },
    [9] = { x=4,y=76 },
    [10] = { x=4,y=76 },
  }
}

PREFABS.Switch_wall_tight_hacx =
{
  template   = "Switch_wall_tight",

  game = "hacx",
  forced_offsets = 
  {
    [8] = { x=68,y=65 },
    [9] = { x=68,y=65 },
    [10] = { x=68,y=65 },
  }
}

PREFABS.Switch_wall_tight_harmony =
{
  template   = "Switch_wall_tight",

  game = "harmony",
  forced_offsets = 
  {
    [8] = { x=4,y=80 },
    [9] = { x=4,y=80 },
    [10] = { x=4,y=80 },
  }
}

PREFABS.Switch_wall_tight_strife =
{
  template   = "Switch_wall_tight",

  game = "strife",
  forced_offsets = 
  {
    [8] = { x=4,y=62 },
    [9] = { x=4,y=62 },
    [10] = { x=4,y=62 },
  }
}
