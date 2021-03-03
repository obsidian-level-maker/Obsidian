--
-- Beams for internal areas.
--

PREFABS.Beam =
{
  file   = "fence/beam.wad",
  map    = "MAP01",

  group  = "beam_gothic",

  kind   = "beam",

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

  group  = "beam_gothic",

  kind   = "beam",

  prob   = 50,

  where  = "diagonal",

  bound_z1 = 0,
}

PREFABS.Beam_tech =
{
  template = "Beam",
  map = "MAP03",

  group = "beam_shiny",
}

PREFABS.Beam_diagonal_tech =
{
  template = "Beam_diagonal",
  map = "MAP04",

  group = "beam_shiny",
}

PREFABS.Beam_wall_textured =
{
  template = "Beam",
  map = "MAP05",

  theme = "!tech",

  group = "beam_textured",
}

PREFABS.Beam_wall_textured_diagonal =
{
  template = "Beam_diagonal",
  map = "MAP06",

  theme = "!tech",

  group = "beam_textured",
}

PREFABS.Beam_wall_textured_tech =
{
  template = "Beam",
  map = "MAP05",

  theme = "tech",

  group = "beam_textured",

  tex_METAL = "SHAWN2",
}

PREFABS.Beam_wall_textured_diagonal_tech =
{
  template = "Beam_diagonal",
  map = "MAP06",

  theme = "tech",

  group = "beam_textured",

  tex_METAL = "SHAWN2",
}
