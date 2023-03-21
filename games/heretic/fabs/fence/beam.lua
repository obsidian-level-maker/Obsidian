--
-- Beams for internal areas.
--

PREFABS.Beam =
{
  file   = "fence/beam.wad",
  map    = "MAP01",

  group  = "beam_metal",

  kind   = "beam",

  nolimit_compat = true,

  prob   = 50,

  where  = "edge",

  deep   = 8,
  over   = 8,

  bound_z1 = 0,
}


PREFABS.Beam_diagonal =
{
  file   = "fence/beam.wad",
  map    = "MAP02",

  group  = "beam_metal",

  nolimit_compat = true,

  kind   = "beam",

  prob   = 50,

  where  = "diagonal",

  bound_z1 = 0,
}
