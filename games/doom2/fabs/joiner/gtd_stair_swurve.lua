PREFABS.Joiner_stairs_swurve_tech =
{
  file   = "joiner/gtd_stair_swurve.wad",
  map    = "MAP01",

  theme  = "tech",

  prob   = 250,

  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  delta_h = 48,
  nearby_h = 128,

  x_fit = { 136,152 },
  y_fit = { 12,20 , 268,276 },

  can_flip = true,

  tex_PANEL5 = "LITEBLU1",

  tex_LITE5 =
  {
    LITE5=1,
    LITEBLU4=1,
  },
}

PREFABS.Joiner_stairs_swurve_urban =
{
  template = "Joiner_stairs_swurve_tech",

  theme = "urban",
}

PREFABS.Joiner_stairs_swurve_deimos =
{
  template = "Joiner_stairs_swurve_tech",
  game = "doom",

  theme = "deimos",

  tex_PANEL5 =
  {
    GSTGARG=1,
    GSTLION=1,
    GSTSATYR=1,
    WOOD4=1,
    SP_FACE1=1,
    TEKWALL4=2,
    TEKWALL2=2,
    TEKWALL3=2,
  },

}

PREFABS.Joiner_stairs_swurve_hell =
{
  template = "Joiner_stairs_swurve_tech",

  theme = "hell",

  tex_PANEL5 =
  {
    GSTGARG=1,
    GSTLION=1,
    GSTSATYR=1,
    SP_FACE1=1,
  },

  tex_LITE5 =
  {
    FIRELAVA=1,
    FIREBLU1=1,
    FIREWALL=1,
  },
}

PREFABS.Joiner_stairs_swurve_flesh =
{
  template = "Joiner_stairs_swurve_tech",
  game = "doom",

  theme = "flesh",

  tex_PANEL5 =
  {
    GSTGARG=1,
    GSTLION=1,
    GSTSATYR=1,
    WOOD4=1,
    SKINBORD=1,
    SKINTEK1=1,
    TEKWALL2=1,
    TEKWALL3=1,
    SP_FACE1=1,
  },

  tex_LITE5 =
  {
    FIRELAVA=1,
    FIREBLU1=1,
    FIREWALL=1,
  },
}

PREFABS.Joiner_stairs_swurve_tech_mirrored =
{
  template = "Joiner_stairs_swurve_tech",

  map = "MAP02",

  x_fit = { 104,120 },

  tex_PANEL5 = "LITEBLU1",

  tex_LITE5 =
  {
    LITE5=1,
    LITEBLU4=1,
  },
}

PREFABS.Joiner_stairs_swurve_deimos_mirrored =
{
  template = "Joiner_stairs_swurve_tech",
  game = "doom",

  map = "MAP02",

  x_fit = { 104,120 },

  tex_PANEL5 = "LITEBLU1",

  tex_PANEL5 =
  {
    GSTGARG=1,
    GSTLION=1,
    GSTSATYR=1,
    WOOD4=1,
    SP_FACE1=1,
    TEKWALL4=2,
    TEKWALL2=2,
    TEKWALL3=2,
  },

  tex_LITE5 =
  {
    LITE5=1,
    LITEBLU4=1,
  },
}

PREFABS.Joiner_stairs_swurve_urban_mirrored =
{
  template = "Joiner_stairs_swurve_tech",

  theme = "urban",

  map = "MAP02",

  x_fit = { 104,120 },
}

PREFABS.Joiner_stairs_swurve_hell_mirrored =
{
  template = "Joiner_stairs_swurve_tech",

  theme = "hell",

  map = "MAP02",

  tex_PANEL5 =
  {
    GSTGARG=1,
    GSTLION=1,
    GSTSATYR=1,
    WOOD4=1,
    SP_FACE1=1,
  },

  tex_LITE5 =
  {
    FIRELAVA=1,
    FIREBLU1=1,
    FIREWALL=1,
  },

  x_fit = { 104,120 },
}

PREFABS.Joiner_stairs_swurve_flesh_mirrored =
{
  template = "Joiner_stairs_swurve_tech",
  game = "doom",

  theme = "flesh",

  map = "MAP02",

  tex_PANEL5 =
  {
    GSTGARG=1,
    GSTLION=1,
    GSTSATYR=1,
    WOOD4=1,
    SKINBORD=1,
    SKINTEK1=1,
    TEKWALL2=1,
    TEKWALL3=1,
    SP_FACE1=1,
  },

  tex_LITE5 =
  {
    FIRELAVA=1,
    FIREBLU1=1,
    FIREWALL=1,
  },

  x_fit = { 104,120 },
}
