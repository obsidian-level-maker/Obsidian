--
-- Graveyard fence
--

PREFABS.Fence_dem_graves =
{
  file   = "fence/dem_graves_fence.wad",
  map    = "MAP01",

  group = "dem_wall_graveyard",

  prob   = 50,

  where  = "edge",

  deep   = 16,
  over   = 16,

  post_offset_h = 96,

  fence_h  = 32,

  bound_z1 = 0
}

PREFABS.Fence_dem_graves_diag =
{
  file   = "fence/dem_graves_fence.wad",
  map    = "MAP02",

  group = "dem_wall_graveyard",

  prob   = 50,

  where  = "diagonal",

  post_offset_h = 96,

  fence_h = 32,

  bound_z1 = 0
}
