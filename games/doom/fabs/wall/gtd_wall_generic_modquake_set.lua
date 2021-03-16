--
-- uses slope lines... a lot
--

PREFABS.Wall_modquake_set_industrial =
{
  file   = "wall/gtd_wall_generic_modquake_set.wad",
  map    = "MAP01",

  engine = "zdoom",

  theme  = "!hell",

  group = "gtd_modquake_set",

  prob   = 50,
  rank   = 4,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Wall_modquake_set_hell =
{
  template = "Wall_modquake_set_industrial",

  theme = "hell",

  rank = 3,

  tex_LITEBLU1 = "METAL",
  tex_COMPBLUE = "CRACKLE2"
}

-- LIMIT-safe versions

PREFABS.Wall_modquake_set_industrial_boom =
{
  template = "Wall_modquake_set_industrial",

  engine = "limit",

  rank = 2,

  line_342 = 0
}

PREFABS.Wall_modquake_set_hell_boom =
{
  template = "Wall_modquake_set_industrial",

  theme = "hell",

  engine = "limit",
  rank = 1,

  line_342 = 0,

  tex_LITEBLU1 = "METAL",
  tex_COMPBLUE = "CRACKLE2"
}

--
-- like a JAW!
--

PREFABS.Wall_modquake_set_jawlike =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP02",

  theme = "any",
  rank = 2,

  group = "gtd_modquake_jawlike"
}

-- LIMIT-safe versions

PREFABS.Wall_modquake_set_jawlike_boom =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP02",

  engine = "limit",

  theme = "any",
  rank = 1,

  group = "gtd_modquake_jawlike",

  line_342 = 0,
  line_341 = 0
}

--
-- in reference to Quake's brutalist wall pillars
--

PREFABS.Wall_modquake_top_heavy_brace_set =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP03",

  rank = 2,

  group = "gtd_modquake_top_heavy_brace"
}

PREFABS.Wall_modquake_top_heavy_brace_set_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP03",

  engine = "limit",

  rank = 1,

  group = "gtd_modquake_top_heavy_brace",

  line_344 = 0
}
