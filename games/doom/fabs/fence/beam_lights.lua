--
-- Beams for internal areas.
--

PREFABS.Beam_lights =
{
  file   = "fence/beam_lights.wad",
  map    = "MAP01",

  group  = "beam_lights",

  kind   = "beam",

  prob   = 50,

  where  = "edge",

  deep   = 8,
  over   = 8,

  z_fit = { 56,72 },

  bound_z1 = 0,
  bound_z2 = 96,
}

PREFABS.Beam_lights_diagonal =
{
  file   = "fence/beam_lights.wad",
  map    = "MAP02",

  group  = "beam_lights",

  kind   = "beam",

  prob   = 50,

  where  = "diagonal",

  z_fit = { 56,72 },

  bound_z1 = 0,
  bound_z2 = 96,
}

PREFABS.Beam_lights_white =
{
  template = "Beam_lights",
  map = "MAP03",

  group = "beam_lights_white",
}

PREFABS.Beam_lights_white_diagonal =
{
  template = "Beam_lights_diagonal",
  map = "MAP04",

  group = "beam_lights_white",
}
