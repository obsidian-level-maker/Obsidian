PREFABS.Joiner_circle_lift = -- Default offsets are for Doom
{
  file   = "joiner/circle_lift.wad",
  map    = "MAP01",

  game   = { chex3=1, doom1=1, doom2=1 },
  prob   = 100,

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep   = 16,
  over   = 16,
  
  delta_h = 104,

  can_flip = true,

  forced_offsets = -- Need to force 1,1 otherwise Obsidian will think it wants to be 0,0
  {
    [13] = { x=1, y=1 },
    [17] = { x=1, y=1 },
    [18] = { x=1, y=1 },
  }
}

PREFABS.Joiner_circle_lift_hacx = 
{
  template = "Joiner_circle_lift",
  game = "hacx",

  force_offsets =
  {
    [13] = { x=64, y=6 },
    [17] = { x=64, y=6 },
    [18] = { x=64, y=6 },
  } 
}