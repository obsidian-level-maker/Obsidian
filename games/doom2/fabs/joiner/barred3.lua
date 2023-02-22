--
-- Joiner with opening bars
--

PREFABS.Joiner_barred3 =
{
  file   = "joiner/barred3.wad",
  map    = "MAP01",
  where  = "seeds",
  shape  = "I",

  key    = "barred",

  prob   = 70, --50,

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}
