--
--  Niche switch
--

PREFABS.Switch_wall_box1 =
{
  file   = "switch/wall_box1.wad",
  map = "MAP01",

  prob   = 50,

  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

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
  map = "MAP02"
}

PREFABS.Switch_wall_box1_hacx = 
{
  template = "Switch_wall_box1",

  game = "hacx",
  
  forced_offsets = 
  {
    [8] = { x=0,y=0 },
  }
}

PREFABS.Switch_wall_box1_harmony = 
{
  template = "Switch_wall_box1",

  game = "harmony",
  
  forced_offsets = 
  {
    [8] = { x=16,y=16 },
  }
}

PREFABS.Switch_wall_box1_heretic = 
{
  template = "Switch_wall_box1",

  game = "heretic",
  
  forced_offsets = 
  {
    [8] = { x=16,y=49 },
  }
}

PREFABS.Switch_wall_box1_hexen = 
{
  template = "Switch_wall_box1",

  game = "hexen",
  
  forced_offsets = 
  {
    [8] = { x=0,y=32 },
  }
}

PREFABS.Switch_wall_box1_strife = 
{
  template = "Switch_wall_box1",

  game = "strife",
  
  forced_offsets = 
  {
    [8] = { x=0,y=72 },
  }
}

