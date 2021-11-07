PREFABS.Hallway_curve_lift = -- Default offsets are for Doom
{
  file   = "hall/curve_lf.wad",
  map    = "MAP01",

  game   = { chex3=1, doom1=1, doom2=1 },
  group  = "curve",
  prob   = 25,

  --style = "steepness",

  where  = "seeds",
  shape  = "I",

  delta_h = 104,

  can_flip = true,

  forced_offsets = -- Need to force 1,1 otherwise Obsidian will think it wants to be 0,0
  {
    [13] = { x=1, y=1 },
    [17] = { x=1, y=1 },
    [18] = { x=1, y=1 },
  }
}

PREFABS.Hallway_curve_lift_hacx = 
{
  template = "Hallway_curve_lift",
  game = "hacx",
  {
    [13] = { x=64, y=6 },
    [17] = { x=64, y=6 },
    [18] = { x=64, y=6 },
  } 
}