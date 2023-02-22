--
-- Joiner with remote door
--

PREFABS.Joiner_remote2 =
{
  file   = "joiner/remote2.wad",
  where  = "seeds",
  shape  = "I",

  key    = "sw_metal",

  prob   = 20,

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = "stretch",

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

