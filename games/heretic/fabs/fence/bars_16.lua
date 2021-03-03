--
-- Lowering bars  (for outdoor locks)
--

PREFABS.Bars_shiny =
{
  file   = "fence/bars_16.wad",
  map    = "MAP01",

  prob   = 120,

  where  = "edge",
  key    = "barred",

  seed_w = 2,
  deep   = 16,
  over   = 16,

  fence_h = 32,

  x_fit  = "frame",

  bound_z1 = 0,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}
