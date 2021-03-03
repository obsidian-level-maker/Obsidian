PREFABS.Cage_gtd_D2_floor_urban =
{
  file   = "cage/gtd_cage_d2_floor.wad",
  map = "MAP01",

  prob  = 800,
  theme = "urban",

  where  = "seeds",
  shape  = "U",

  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = { 20,88 },
  y_fit = "top",

  sector_1 = {
    [0] = 8,
    [1] = 1,
    [2] = 0.5,
    [3] = 0.5,
    [21] = 1,
  },

  tex_MISDPSACE =
  {
    MIDSPACE = 1,
    MIDGRATE = 1,
    MIDBARS1 = 1,
  }
}

PREFABS.Cage_gtd_D2_floor_tech =
{
  template = "Cage_gtd_D2_floor_urban",

  theme = "tech",

  tex_SUPPORT3 = "SHAWN2",
  tex_METAL = "SHAWN2",

  tex_LITE5 = "LITEBLU4",
  tex_PANBOOK = "COMPTALL",

  tex_MIDSPACE =
  {
    MIDSPACE = 1,
    MIDBARS1 = 1,
    BRNSMALC = 1,
  }
}

PREFABS.Cage_gtd_D2_floor_hell =
{
  template = "Cage_gtd_D2_floor_urban",

  theme = "hell",

  tex_LITE5 = "FIRELAVA",
  tex_PANBOOK =
  {
    SK_LEFT = 1,
    SK_RIGHT = 1,
  },

  tex_MIDSPACE =
  {
    MIDSPACE = 1,
    MIDBRN1 = 1,
    MIDGRATE = 1,
  }
}
