PREFABS.Joiner_armaetus_stairs_alternating_lights =
{
  file   = "joiner/armaetus_joiner_stairs_altern_lights.wad",

  prob   = 180,
  style  = "steepness",

  theme  = "!hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = { 20,28 , 260,268 },

  delta_h  = 56,
  nearby_h = 128,

  can_flip = true,
}

PREFABS.Joiner_armaetus_stairs_alternating_lights_hell =
{
  template = "Joiner_armaetus_stairs_alternating_lights",

  prob = 180,

  theme = "hell",

  tex_LITE3 = "SP_FACE2",
  tex_DOORSTOP = "DOORTRAK",
}
