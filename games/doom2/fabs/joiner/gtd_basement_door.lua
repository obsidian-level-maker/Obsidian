PREFABS.Joiner_gtd_basement_door_plain =
{
  file   = "joiner/gtd_basement_door.wad",
  map = "MAP01",

  prob   = 75,
  style  = "steepness",

  theme = "!hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 16,40 , 248,264 },

  delta_h  = 64,
  nearby_h = 96,
  can_flip = true,
}

PREFABS.Joiner_gtd_basement_door_plain_fenced =
{
  template = "Joiner_gtd_basement_door_plain",
  map = "MAP02",
}

-- hell version

PREFABS.Joiner_gtd_basement_door_plain_hell =
{
  template = "Joiner_gtd_basement_door_plain",
  map = "MAP01",

  theme = "hell",

  tex_METAL5 = "SKINEDGE",
  tex_DOORSTOP = "METAL",
  tex_DOOR1 = "WOODMET2",
  tex_MIDSPACE = "MIDGRATE",
  flat_FLAT19 = "CEIL5_2",
}

PREFABS.Joiner_gtd_basement_door_plain_fenced_hell =
{
  template = "Joiner_gtd_basement_door_plain",
  map = "MAP02",

  theme = "hell",

  tex_METAL5 = "SKINEDGE",
  tex_DOORSTOP = "METAL",
  tex_DOOR1 = "WOODMET2",
  tex_MIDSPACE = "MIDGRATE",
  flat_FLAT19 = "CEIL5_2",
}

-- staired arch

PREFABS.Joiner_gtd_basement_arched =
{
  template = "Joiner_gtd_basement_door_plain",
  map = "MAP03",

  theme = "!tech",

  prob = 150,

  tex_GSTSATYR =
  {
    GSTSATYR = 50,
    GSTLION = 50,
    GSTGARG = 50,
    MARBFAC4 = 50,
  },

  thing_57 = -- lamp color change
  {
    [57]=50,
    [56]=50,
    [55]=50,
  },

  y_fit = { 16,56 , 136,168 },
}
