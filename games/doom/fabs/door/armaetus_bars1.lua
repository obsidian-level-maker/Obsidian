--
-- Archway with bars
--

PREFABS.Decor_Armaetus_bars_EPIC =
{
  file   = "door/armaetus_bars1.wad",
  map    = "MAP01",
  theme  = "!tech",

  texture_pack = "armaetus",

  prob   = 50,

  where  = "edge",
  key    = "barred",

  deep   = 16,
  over   = 16,


  bound_z1 = 0,
  bound_z2 = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}


PREFABS.Decor_Armaetus_bars_EPIC_wide =
{
  template = "Decor_Armaetus_bars_EPIC",
  map      = "MAP03",
  theme    = "!tech",

  seed_w = 2,

  x_fit  = "frame",
}


-- Does this even work???
-- Left UNFINISHED because unsure if it will even work!
-- Remove it if nothing for it from testing.
UNFINISHED.Armaetus_bars_EPIC_diag =
{
  file   = "door/armaetus_bars1.wad",
  map    = "MAP02",
  theme  = "!tech",

  texture_pack = "armaetus",

  prob   = 50,

  where  = "diagonal",
  key    = "barred",

  bound_z1 = 0,
  bound_z2 = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}
