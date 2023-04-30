PREFABS.Joiner_service_door_1 =
{
  file   = "joiner/gtd_stair_swurve.wad",
  map    = "MAP01",

  theme  = "tech",

  prob   = 250,

  texture_pack = "armaetus",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  delta_h = 32,
  nearby_h = 128,

  x_fit = { 120,136 },
  y_fit = { 48,56 , 136,144 },

  can_flip = true,
}

PREFABS.Joiner_service_door_1_mirrored =
{
  template = "Joiner_service_door_1",
  map = "MAP02"
}
