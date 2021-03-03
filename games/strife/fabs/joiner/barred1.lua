--
-- Joiner with opening bars
--

PREFABS.Joiner_barred1 =
{
  file   = "joiner/barred1.wad",
  where  = "seeds",
  shape  = "I",

  key    = "barred",

  prob   = 70 --50,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
},
