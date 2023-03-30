-- uses slope lines... a lot
--

PREFABS.Wall_modquake_set_industrial =
{
  file   = "wall/gtd_wall_generic_modquake_set.wad",
  map    = "MAP01",

  port = "zdoom",

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

-- LIMIT-SAFE:

PREFABS.Wall_modquake_set_industrial_boom =
{
  template = "Wall_modquake_set_industrial",

  

  rank = 2,

  line_342 = 0
}

PREFABS.Wall_modquake_set_hell_boom =
{
  template = "Wall_modquake_set_industrial",

  theme = "hell",

  
  rank = 1,

  line_342 = 0,

  tex_LITEBLU1 = "METAL",
  tex_COMPBLUE = "CRACKLE2"
}

-- lights arranged like a JAW!
--

PREFABS.Wall_modquake_set_jawlike =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP02",

  theme = "any",
  rank = 2,

  group = "gtd_modquake_jawlike"
}

-- LIMIT-SAFE:

PREFABS.Wall_modquake_set_jawlike_boom =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP02",

  

  theme = "any",
  rank = 1,

  group = "gtd_modquake_jawlike",

  line_342 = 0,
  line_341 = 0
}

-- in reference to Quake's brutalist wall pillars
--

PREFABS.Wall_modquake_top_heavy_brace_set =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP03",

  rank = 2,

  group = "gtd_modquake_top_heavy_brace",

  z_fit = { 104,112 }
}

-- LIMIT-SAFE:

PREFABS.Wall_modquake_top_heavy_brace_set_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP03",

  

  rank = 1,

  group = "gtd_modquake_top_heavy_brace",

  line_344 = 0,

  z_fit = { 104,112 }
}

-- sloped brace textured with the eponymous TEKWALL4
--

PREFABS.Wall_modquake_tek_slope_brace =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP04",

  rank = 2,

  deep = 32,

  group = "gtd_modquake_tek_slope_brace"
}

-- LIMIT-SAFE:

PREFABS.Wall_modquake_tek_slope_brace_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP04",

  

  rank = 1,

  deep = 32,

  group = "gtd_modquake_tek_slope_brace",

  line_341 = 0
}

-- exit light inset into a sloped brace
--

PREFABS.Wall_modquake_ex_light_slope_brace =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP05",

  rank = 2,

  deep = 20,

  group = "gtd_modquake_ex_light_slope_brace"
}

-- LIMIT-SAFE:

PREFABS.Wall_modquake_ex_light_slope_brace_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP05",

  

  rank = 1,

  deep = 20,

  group = "gtd_modquake_ex_light_slope_brace",

  line_341 = 0
}

-- round pillar inset into a wall surrounded
-- by a slope-ish brace

PREFABS.Wall_modquake_round_braced_lit_pillar_industrial =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP06",

  theme = "!hell",

  rank = 2,

  deep = 20,

  group = "gtd_modquake_round_braced_lit_pillar",

  flat_CEIL5_2 = "FLAT23",
  tex_METAL = "SHAWN2",
  tex_SUPPORT3 = "SUPPORT2"
}

PREFABS.Wall_modquake_round_braced_lit_pillar_hell =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP06",

  theme = "hell",

  rank = 3,

  deep = 20,

  group = "gtd_modquake_round_braced_lit_pillar",

  tex_LITEBLU1 = "FIREWALA",
  tex_LITEBLU4 = "FIREMAG1"
}

-- LIMIT-SAFE:

PREFABS.Wall_modquake_round_braced_lit_pillar_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP06",

  theme = "any",

  rank = 1,

  deep = 20,

  group = "gtd_modquake_round_braced_lit_pillar",

  line_342 = 0
}

-- hexagonal wall inset with a brace inside and a light
--

PREFABS.Wall_modquake_hexagon_inset_braced_industrial =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP07",

  theme = "!hell",

  rank = 4,

  group = "gtd_modquake_hexagon_inset_braced",
}

PREFABS.Wall_modquake_hexagon_inset_braced_hell =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP07",

  theme = "hell",

  rank = 3,

  group = "gtd_modquake_hexagon_inset_braced",

  tex_DOORSTOP = "METAL",
  tex_EXITDOOR = "FIREMAG1",
  tex_METAL3 = "METAL2"
}

-- LIMIT-SAFE:

PREFABS.Wall_modquake_hexagon_inset_braced_industrial_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP07",

  theme = "!hell",

  port = "!zdoom",

  rank = 2,

  group = "gtd_modquake_hexagon_inset_braced",

  line_342 = 0,
  line_345 = 0
}

PREFABS.Wall_modquake_hexagon_inset_braced_hell_limit =
{
  template = "Wall_modquake_set_industrial",
  map = "MAP07",

  theme = "hell",

  port = "!zdoom",

  rank = 1,

  group = "gtd_modquake_hexagon_inset_braced",

  line_342 = 0,
  line_345 = 0,

  tex_DOORSTOP = "METAL",
  tex_EXITDOOR = "FIREMAG1",
  tex_METAL3 = "METAL2"
}
