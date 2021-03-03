PREFABS.Beam_quakeish =
{
  file   = "fence/beam_quakeish.wad",
  map    = "MAP01",

  group = "beam_quakeish",

  engine = "zdoom",

  kind   = "beam",

  rank   = 2,
  prob   = 50,

  where  = "edge",

  deep   = 24,
  over   = 24,

  z_fit = {32,48},

  bound_z1 = 0,
  bound_z2 = 96,
}

PREFABS.Beam_quakeish_diagonal =
{
  file   = "fence/beam_quakeish.wad",
  map    = "MAP02",

  group = "beam_quakeish",

  engine = "zdoom",

  kind   = "beam",

  rank   = 2,
  prob   = 50,

  where  = "diagonal",

  z_fit = {32,48},

  bound_z1 = 0,
  bound_z2 = 96,
}

-- fallbacks for non ZDoom-slope supporting engines

PREFABS.Beam_quakeish_fallback =
{
  file   = "fence/beam.wad",
  map    = "MAP01",

  group  = "beam_quakeish",

  kind   = "beam",

  prob   = 1,

  where  = "edge",

  deep   = 8,
  over   = 8,

  bound_z1 = 0,
}

PREFABS.Beam_quakeish_diagonal_fallback =
{
  file   = "fence/beam.wad",
  map    = "MAP02",

  group  = "beam_quakeish",

  kind   = "beam",

  prob   = 1,

  where  = "diagonal",

  bound_z1 = 0,
}
