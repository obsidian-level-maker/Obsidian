--
-- Joiner with remote door
--

PREFABS.Joiner_remote_door_rails =
{
  file   = "joiner/barred2.wad",
  where  = "seeds",
  shape  = "I",

  key    = "barred",

  prob   = 20,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor"
}

