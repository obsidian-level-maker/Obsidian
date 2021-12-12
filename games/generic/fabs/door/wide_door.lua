--
-- Wide doors
--

PREFABS.Door_wide_wood =
{
  file   = "door/wide_door.wad",
  map    = "MAP01",
  game = { chex3=1, doom1=0, doom2=0, hacx=1, harmony=1, heretic=1, hexen=1, strife=1 },

  prob   = 40,

  kind   = "arch",
  where  = "edge",

  seed_w = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
}

PREFABS.Door_wide_wood_doom =
{
  template = "Door_wide_wood",
  game = "doomish",
  forced_offsets = 
  {
    [1] = { x=0, y=-7 },
    [4] = { x=0, y=-7 },
  }
}


PREFABS.Door_wide_chainman =
{
  file   = "door/wide_door.wad",
  map    = "MAP03",
  game = { chex3=1, doom1=0, doom2=0, hacx=1, harmony=1, heretic=1, hexen=1, strife=1 },

  prob   = 40,

  kind   = "arch",
  where  = "edge",

  seed_w = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  seed_w = 3,
}

PREFABS.Door_wide_chainman_doom =
{
  template = "Door_wide_chainman",
  game = "doomish",
  forced_offsets = 
  {
    [1] = { x=0, y=-7 },
    [4] = { x=0, y=-7 },
  }
}

