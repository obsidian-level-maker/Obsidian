--
--  Niche switch
--

PREFABS.Switch_wall_box1 =
{
  file   = "switch/wall_box1.wad",

  prob   = 50,

  game = {heretic=1, hexen=1},

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

PREFABS.Switch_wall_box1_chex3 = 
{
  template = "Switch_wall_box1",

  game = "chex3",
  
  forced_offsets = 
  {
    [7] = { x=0,y=64 },
    [8] = { x=0,y=64 },
    [9] = { x=0,y=64 },
  }
}

PREFABS.Switch_wall_box1_hacx = 
{
  template = "Switch_wall_box1",

  game = "hacx",
  
  forced_offsets = 
  {
    [7] = { x=64,y=33 },
    [8] = { x=64,y=33 },
    [9] = { x=64,y=33 },
  }
}

PREFABS.Switch_wall_box1_harmony = 
{
  template = "Switch_wall_box1",

  game = "harmony",
  
  forced_offsets = 
  {
    [7] = { x=0,y=66 },
    [8] = { x=0,y=66 },
    [9] = { x=0,y=66 },
  }
}

PREFABS.Switch_wall_box1_strife = 
{
  template = "Switch_wall_box1",

  game = "strife",
  
  forced_offsets = 
  {
    [7] = { x=0,y=46 },
    [8] = { x=0,y=46 },
    [9] = { x=0,y=46 },
  }
}

