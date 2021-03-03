PREFABS.Fence_corrugated_steel =
{
  file   = "fence/gtd_fence_corrugated_steel.wad",
  map    = "MAP01",

  prob   = 50,

  replaces = "Fence_corrugated_steel_plain",
  texture_pack = "armaetus",

  group  = "fence_corrugated_steel",

  where  = "edge",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,

  tex_GRAYMET3 =
  {
    GRAYMET2 = 1,
    GRAYMET3 = 5,
    GRAYMET5 = 1,
  }
}

PREFABS.Fence_corrugated_steel_diag =
{
  template = "Fence_corrugated_steel",
  map    = "MAP02",

  replaces = "Fence_corrugated_steel_plain_diag",
  texture_pack = "armaetus",

  where  = "diagonal",
}

-- fallbacks

PREFABS.Fence_corrugated_steel_plain =
{
  file   = "fence/gtd_fence_corrugated_steel.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "fence_corrugated_steel",

  where  = "edge",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,

  tex_GRAYMET3 = "SHAWN2",
  tex_BARBWIRE = "ZZWOLF10",
}

PREFABS.Fence_corrugated_steel_plain_diag =
{
  file   = "fence/gtd_fence_corrugated_steel.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "fence_corrugated_steel",

  where  = "diagonal",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,

  tex_GRAYMET3 = "SHAWN2",
  tex_BARBWIRE = "ZZWOLF10",
}
