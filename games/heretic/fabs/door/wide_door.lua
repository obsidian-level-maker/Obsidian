--
-- Wide doors
--

PREFABS.Door_wide_wood =
{
  file   = "door/wide_door.wad",
  map    = "MAP01",

  prob   = 40,

  kind   = "arch",
  where  = "edge",

  nolimit_compat = true,

  seed_w = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
}


PREFABS.Door_wide_chainman =
{
  template = "Door_wide_wood",
  map      = "MAP03",

  prob   = 40,

  seed_w = 3,
}

