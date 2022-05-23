--
--  Techy exit pillar
--

PREFABS.Exit_pillar2 =
{
  file  = "exit/pillar2.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, nukem=1, quake=1, strife=0 },

  prob  = 100,

  where = "point",
  forced_offsets = 
  {
    [26] = { x=0, y=16 },
    [34] = { x=0, y=16 },
    [44] = { x=0, y=16 },
    [54] = { x=0, y=16 },
  }
}

PREFABS.Exit_pillar2_chex3 = 
{
  template = "Exit_pillar2",
  game = "chex3",
  engine = "advanced",
  forced_offsets = 
  {
    [26] = { x=47, y=11 },
    [34] = { x=47, y=11 },
    [44] = { x=47, y=11 },
    [54] = { x=47, y=11 },
  }
}

PREFABS.Exit_pillar2_chex3_nosign = 
{
  template = "Exit_pillar2",
  game = "chex3",
  engine = "!advanced",
  map = "MAP02",
  forced_offsets = 
  {
    [26] = { x=47, y=11 },
    [34] = { x=47, y=11 },
    [44] = { x=47, y=11 },
    [54] = { x=47, y=11 },
  }
}

PREFABS.Exit_pillar2_hacx = 
{
  template = "Exit_pillar2",
  game = "hacx",
  engine = "advanced",
  forced_offsets = 
  {
    [26] = { x=0, y=96 },
    [34] = { x=0, y=96 },
    [44] = { x=0, y=96 },
    [54] = { x=0, y=96 },
  }
}

PREFABS.Exit_pillar2_hacx_nosign = 
{
  template = "Exit_pillar2",
  game = "hacx",
  engine = "!advanced",
  map = "MAP02",
  forced_offsets = 
  {
    [26] = { x=0, y=96 },
    [34] = { x=0, y=96 },
    [44] = { x=0, y=96 },
    [54] = { x=0, y=96 },
  }
}

PREFABS.Exit_pillar2_harmony = 
{
  template = "Exit_pillar2",
  game = "harmony",
  forced_offsets = 
  {
    [26] = { x=16, y=79 },
    [34] = { x=16, y=79 },
    [44] = { x=16, y=79 },
    [54] = { x=16, y=79 },
  }
}

PREFABS.Exit_pillar2_heretic = 
{
  template = "Exit_pillar2",
  game = "heretic",
  engine = "advanced",
  forced_offsets = 
  {
    [12] = { x=0, y=-1 },
    [14] = { x=0, y=-1 },
    [16] = { x=0, y=-1 },
    [18] = { x=0, y=-1 },
    [26] = { x=16, y=50 },
    [34] = { x=16, y=50 },
    [44] = { x=16, y=50 },
    [54] = { x=16, y=50 },
  }
}

PREFABS.Exit_pillar2_heretic_nosign = 
{
  template = "Exit_pillar2",
  game = "heretic",
  engine = "!advanced",
  map = "MAP02",
  forced_offsets = 
  {
    [26] = { x=16, y=50 },
    [34] = { x=16, y=50 },
    [44] = { x=16, y=50 },
    [54] = { x=16, y=50 },
  }
}

PREFABS.Exit_pillar2_hexen_nosign = 
{
  template = "Exit_pillar2",
  game = "hexen",
  --engine = "!advanced",
  map = "MAP02",
  forced_offsets = 
  {
    [26] = { x=0, y=0 },
    [34] = { x=0, y=0 },
    [44] = { x=0, y=0 },
    [54] = { x=0, y=0 },
  }
}

PREFABS.Exit_pillar2_strife =
{
  template = "Exit_pillar2",
  game = "strife",
  forced_offsets = 
  {
    [12] = { x=0, y=9 },
    [14] = { x=0, y=9 },
    [16] = { x=0, y=9 },
    [18] = { x=0, y=9 },
    [26] = { x=0, y=66 },
    [34] = { x=0, y=66 },
    [44] = { x=0, y=66 },
    [54] = { x=0, y=66 },
  }
}

PREFABS.Exit_pillar2_secret =
{
  file  = "exit/pillar2.wad",
  map    = "MAP03",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },
  where  = "point",
  prob = 100,

  -- this kind means "an exit to a secret level"
  kind = "secret_exit",
  forced_offsets = 
  {
    [26] = { x=0, y=16 },
    [34] = { x=0, y=16 },
    [44] = { x=0, y=16 },
    [54] = { x=0, y=16 },
  }
}

PREFABS.Exit_pillar2_secret_chex3 = 
{
  template = "Exit_pillar2_secret",
  game = "chex3",
  engine = "advanced",
  map = "MAP04",
  forced_offsets = 
  {
    [26] = { x=47, y=11 },
    [34] = { x=47, y=11 },
    [44] = { x=47, y=11 },
    [54] = { x=47, y=11 },
  }
}

PREFABS.Exit_pillar2_secret_chex3_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "chex3",
  engine = "!advanced",
  forced_offsets = 
  {
    [26] = { x=47, y=11 },
    [34] = { x=47, y=11 },
    [44] = { x=47, y=11 },
    [54] = { x=47, y=11 },
  }
}

PREFABS.Exit_pillar2_secret_hacx = 
{
  template = "Exit_pillar2_secret",
  game = "hacx",
  engine = "advanced",
  map = "MAP04",
  forced_offsets = 
  {
    [26] = { x=0, y=96 },
    [34] = { x=0, y=96 },
    [44] = { x=0, y=96 },
    [54] = { x=0, y=96 },
  }
}

PREFABS.Exit_pillar2_secret_hacx_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "hacx",
  engine = "!advanced",
  forced_offsets = 
  {
    [26] = { x=0, y=96 },
    [34] = { x=0, y=96 },
    [44] = { x=0, y=96 },
    [54] = { x=0, y=96 },
  }
}

PREFABS.Exit_pillar2_secret_harmony = 
{
  template = "Exit_pillar2_secret",
  game = "harmony",
  forced_offsets = 
  {
    [26] = { x=16, y=79 },
    [34] = { x=16, y=79 },
    [44] = { x=16, y=79 },
    [54] = { x=16, y=79 },
  }
}

PREFABS.Exit_pillar2_secret_heretic = 
{
  template = "Exit_pillar2_secret",
  game = "heretic",
  engine = "advanced",
  map = "MAP04",
  forced_offsets = 
  {
    [26] = { x=16, y=50 },
    [34] = { x=16, y=50 },
    [44] = { x=16, y=50 },
    [54] = { x=16, y=50 },
  }
}

PREFABS.Exit_pillar2_secret_heretic_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "heretic",
  engine = "!advanced",
  forced_offsets = 
  {
    [26] = { x=16, y=50 },
    [34] = { x=16, y=50 },
    [44] = { x=16, y=50 },
    [54] = { x=16, y=50 },
  }
}

PREFABS.Exit_pillar2_secret_hexen_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "hexen",
  --engine = "!advanced",
  forced_offsets = 
  {
    [26] = { x=0, y=0 },
    [34] = { x=0, y=0 },
    [44] = { x=0, y=0 },
    [54] = { x=0, y=0 },
  }
}

PREFABS.Exit_pillar2_secret_strife =
{
  template = "Exit_pillar2_secret",
  game = "strife",
  forced_offsets = 
  {
    [12] = { x=0, y=9 },
    [14] = { x=0, y=9 },
    [16] = { x=0, y=9 },
    [18] = { x=0, y=9 },
    [26] = { x=0, y=66 },
    [34] = { x=0, y=66 },
    [44] = { x=0, y=66 },
    [54] = { x=0, y=66 },
  }
}