PREFABS.Joiner_gtd_bridge_action =
{
  file = "joiner/gtd_bridge_action.wad",
  map = "MAP01",

  prob = 150,

  theme = "!hell",

  where = "seeds",
  shape = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = { 72,76 , 180,184 },
  y_fit = { 64,96 },

  can_flip = true,
}

PREFABS.Joiner_gtd_bridge_action_hell =
{
  template = "Joiner_gtd_bridge_action",
  map = "MAP02",

  theme = "hell",

  seed_w = 3,
  seed_h = 1,

  x_fit = { 96,104 , 280,288 },
  y_fit = { 40,48 , 112,120 },
}
