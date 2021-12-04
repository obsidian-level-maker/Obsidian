PREFABS.Switch_niche1 =
{
  file   = "switch/armaetus_niche1.wad",
  map = "MAP01",
  prob   = 25,
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep = 16,

  tag_1 = "?switch_tag",

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Switch_niche1_chex3 =
{
  template = "Switch_niche1",
  game = "chex3",
  map = "MAP02"
}

PREFABS.Switch_niche1_hacx =
{
  template = "Switch_niche1",
  game = "hacx",
  forced_offsets =
  {
    [62] = { x=0, y=0 }
  }
}

PREFABS.Switch_niche1_harmony =
{
  template = "Switch_niche1",
  game = "harmony",
  forced_offsets =
  {
    [62] = { x=16, y=16 }
  }
}

PREFABS.Switch_niche1_heretic =
{
  template = "Switch_niche1",
  game = "heretic",
  forced_offsets =
  {
    [62] = { x=16, y=49 }
  }
}

PREFABS.Switch_niche1_hexen =
{
  template = "Switch_niche1",
  game = "hexen",
  forced_offsets =
  {
    [62] = { x=0, y=32 }
  }
}

PREFABS.Switch_niche1_strife =
{
  template = "Switch_niche1",
  game = "strife",
  forced_offsets =
  {
    [62] = { x=0, y=72 }
  }
}

PREFABS.Switch_niche1_up =
{
  file  = "switch/armaetus_niche1.wad",
  map = "MAP03",
  prob   = 25,
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep = 16,

  tag_1 = "?switch_tag",

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Switch_niche1_up_chex3 =
{
  template = "Switch_niche1_up",
  game = "chex3",
  map = "MAP04"
}

PREFABS.Switch_niche1_up_hacx =
{
  template = "Switch_niche1_up",
  game = "hacx",
  forced_offsets =
  {
    [62] = { x=0, y=0 }
  }
}

PREFABS.Switch_niche1_up_harmony =
{
  template = "Switch_niche1_up",
  game = "harmony",
  forced_offsets =
  {
    [62] = { x=16, y=16 }
  }
}

PREFABS.Switch_niche1_up_heretic =
{
  template = "Switch_niche1_up",
  game = "heretic",
  forced_offsets =
  {
    [62] = { x=16, y=49 }
  }
}

PREFABS.Switch_niche1_up_hexen =
{
  template = "Switch_niche1_up",
  game = "hexen",
  forced_offsets =
  {
    [62] = { x=0, y=32 }
  }
}

PREFABS.Switch_niche1_up_strife =
{
  template = "Switch_niche1_up",
  game = "strife",
  forced_offsets =
  {
    [62] = { x=0, y=72 }
  }
}