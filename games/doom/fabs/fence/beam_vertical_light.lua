--
-- Beams for internal areas.
--

PREFABS.Beam_vertical_lights_tech =
{
  file   = "fence/beam_vertical_light.wad",
  map    = "MAP01",

  group  = "beam_lights_vertical_tech",

  kind   = "beam",

  prob   = 50,

  where  = "edge",

  deep   = 8,
  over   = 8,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 24,78 }
}

PREFABS.Beam_vertical_lights_diagonal_tech =
{
  file   = "fence/beam_vertical_light.wad",
  map    = "MAP03",

  group  = "beam_lights_vertical_tech",

  kind   = "beam",

  prob   = 50,

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 24,78 }
}

PREFABS.Beam_vertical_lights_hell =
{
  template = "Beam_vertical_lights_tech",
  map      = "MAP02",

  group    = "beam_lights_vertical_hell",
}

PREFABS.Beam_vertical_lights_diagonal_hell =
{
  template = "Beam_vertical_lights_diagonal_tech",
  map      = "MAP04",

  group    = "beam_lights_vertical_hell",
}
