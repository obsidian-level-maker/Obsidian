PREFABS.Joiner_fake_switch_joiner =
{
  file   = "joiner/gtd_fake_switch.wad",
  map    = "MAP01",

  theme  = "!hell",

  prob   = 100,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 40,120 },
}

PREFABS.Joiner_fake_switch_joiner_trapped =
{
  template = "Joiner_fake_switch_joiner",
  map = "MAP02",

  style = "traps",
}

PREFABS.Joiner_fake_switch_joiner_hell =
{
  template = "Joiner_fake_switch_joiner",
  map = "MAP01",

  theme = "hell",

  tex_SW1COMP =
  {
    SW1GARG = 50,
    SW1LION = 50,
    SW1SATYR = 50,
  },
}

PREFABS.Joiner_fake_switch_joiner_hell_trapped =
{
  template = "Joiner_fake_switch_joiner",
  map = "MAP02",

  style = "traps",

  theme = "hell",

  tex_SW1COMP =
  {
    SW1GARG = 50,
    SW1LION = 50,
    SW1SATYR = 50,
  },
}
