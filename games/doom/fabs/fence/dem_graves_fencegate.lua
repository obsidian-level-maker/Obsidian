--
-- Graveyard lowering bars  (for outdoor graveyard lock)
--

PREFABS.Fence_dem_graves_barred =
{
  file   = "fence/dem_graves_fencegate.wad",
  map    = "MAP01",

  group = "dem_wall_graveyard",

  prob   = 5000,

  where  = "edge",
  key    = "barred",

  seed_w = 2,
  deep   = 16,
  over   = 16,

  fence_h = 32,

  x_fit  = "frame",

  bound_z1 = 0,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor"
}

--[[PREFABS.Fence_dem_graves_barred_diag =
{
  file   = "fence/dem_graves_fencegate.wad",
  map    = "MAP02",

  prob   = 5000,

  where  = "diagonal",
  key    = "barred",

  fence_h = 32,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  bound_z1 = 0
}]]
