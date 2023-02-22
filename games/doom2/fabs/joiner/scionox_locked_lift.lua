PREFABS.Joiner_scionox_locked_lift_barred =
{
  file   = "joiner/scionox_locked_lift.wad",
  map    = "MAP01",

  prob   = 125,
  theme  = "tech",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",
  key = "sw_metal",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  delta_h  = 128,
  nearby_h = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",

  can_flip = true,

  tex_COMPBLUE = { COMPBLUE=50, METAL1=50, SHAWN2=50, SILVER1=50, SPACEW4=60, TEKLITE=50 },

  x_fit = {20,28 , 36,44 , 52,60 , 68,76 , 84,92 , 100,108},
  y_fit = { 56,232 },
}

PREFABS.Joiner_scionox_locked_lift_barred_urban =
{
  template = "Joiner_scionox_locked_lift_barred",
  theme  = "urban",
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
}

PREFABS.Joiner_scionox_locked_lift_barred_2 =
{
  template = "Joiner_scionox_locked_lift_barred",
  map    = "MAP02",
  delta_h  = 72,
}

PREFABS.Joiner_scionox_locked_lift_barred_urban_2 =
{
  template = "Joiner_scionox_locked_lift_barred",
  map    = "MAP02",
  theme  = "urban",
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
  delta_h  = 72,
}

PREFABS.Joiner_scionox_locked_lift_thicc_barred_hell =
{
  template = "Joiner_scionox_locked_lift_barred",
  map    = "MAP04",
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },

  x_fit = {28,36 , 60,68 , 92,100},
}

PREFABS.Joiner_scionox_locked_lift_thicc_barred_hell_2 =
{
  template = "Joiner_scionox_locked_lift_barred",
  map    = "MAP05",
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },
  delta_h  = 72,

  x_fit = {28,36 , 60,68 , 92,100},
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_tech_red =
{
  file   = "joiner/scionox_locked_lift.wad",
  map    = "MAP03",

  prob   = 125,
  theme  = "tech",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",
  key = "k_red",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  delta_h  = 128,
  nearby_h = 128,

  can_flip = true,

  tex_COMPBLUE = { COMPBLUE=50, METAL1=50, SHAWN2=50, SILVER1=50, SPACEW4=60, TEKLITE=50 },

  x_fit = {20,28 , 36,44 , 52,60 , 68,76 , 84,92 , 100,108},
  y_fit = {192,224},
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_tech_blue =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",

  key    = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_135     = 133,
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_tech_yellow =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",

  key    = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_135     = 137,
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_urban_red =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",
  theme  = "urban",
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_urban_blue =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",
  theme  = "urban",
  key    = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_135     = 133,
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_urban_yellow =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",
  theme  = "urban",
  key    = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_135     = 137,
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_hell_red =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",
  map    = "MAP06",
  key = "ks_red",
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },

  x_fit = {28,36 , 60,68 , 92,100},
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_hell_blue =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",
  map    = "MAP06",
  key = "ks_blue",
  tex_DOORRED2 = "DOORBLU2",
  line_135     = 133,
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },

  x_fit = {28,36 , 60,68 , 92,100},
}

PREFABS.Joiner_scionox_locked_lift_keyed_bars_hell_yellow =
{
  template = "Joiner_scionox_locked_lift_keyed_bars_tech_red",
  map    = "MAP06",
  key = "ks_yellow",
  tex_DOORRED2 = "DOORYEL2",
  line_135     = 137,
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },

  x_fit = {28,36 , 60,68 , 92,100},
}

PREFABS.Joiner_scionox_locked_lift_gated_switch =
{
  file   = "joiner/scionox_locked_lift.wad",
  map    = "MAP07",

  prob   = 225,
  theme  = "tech",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",
  key = "sw_metal",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = {56,64 , 224,232},

  delta_h  = 128,
  nearby_h = 128,

  can_flip = true,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",

  tex_COMPBLUE = { COMPBLUE=50, METAL1=50, SHAWN2=50, SILVER1=50, SPACEW4=60, TEKLITE=50 },
}

PREFABS.Joiner_scionox_locked_lift_gated_switch_urban =
{
  template = "Joiner_scionox_locked_lift_gated_switch",
  theme  = "urban",
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_locked_lift_gated_switch_hell =
{
  template = "Joiner_scionox_locked_lift_gated_switch",
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },
  tex_SUPPORT2 = "SUPPORT3",
  tex_SW1GRAY1 = "SW1PANEL",
  tex_SHAWN1 = "SKSPINE1",
  tex_PLAT1 = "SUPPORT3",
  thing_2028 = "red_torch_sm",
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch =
{
  file   = "joiner/scionox_locked_lift.wad",
  map    = "MAP08",

  prob   = 125,
  theme  = "tech",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",
  key = "k_red",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = {56,64 , 224,232},

  can_flip = true,

  delta_h  = 128,
  nearby_h = 128,

  tex_COMPBLUE = { COMPBLUE=50, METAL1=50, SHAWN2=50, SILVER1=50, SPACEW4=60, TEKLITE=50 },
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_blue =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",

  key    = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_135     = 133,
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_yellow =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",

  key    = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_135     = 137,
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_red_urban =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  theme  = "urban",
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_blue_urban =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  theme  = "urban",
  key    = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_135     = 133,
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_yellow_urban =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  theme  = "urban",
  key    = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_135     = 137,
  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },
  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_hell_red =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  key = "ks_red",
  theme  = "hell",
  tex_DOORRED = "DOORRED2",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },
  tex_SW1GRAY1 = "SW1PANEL",
  tex_PLAT1 = "SUPPORT3",
  tex_SUPPORT2 = "SUPPORT3",
  tex_SHAWN1 = "SKSPINE1",
  thing_2028 = "red_torch_sm",
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_hell_blue =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  key = "ks_blue",
  tex_DOORRED = "DOORBLU2",
  line_135     = 133,
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },
  tex_SW1GRAY1 = "SW1PANEL",
  tex_PLAT1 = "SUPPORT3",
  tex_SUPPORT2 = "SUPPORT3",
  tex_SHAWN1 = "SKSPINE1",
  thing_2028 = "red_torch_sm",
}

PREFABS.Joiner_scionox_locked_lift_lockgate_switch_hell_yellow =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  key = "ks_yellow",
  tex_DOORRED = "DOORYEL2",
  line_135     = 137,
  theme  = "hell",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },
  tex_SW1GRAY1 = "SW1PANEL",
  tex_PLAT1 = "SUPPORT3",
  tex_SUPPORT2 = "SUPPORT3",
  tex_SHAWN1 = "SKSPINE1",
  thing_2028 = "red_torch_sm",
}

PREFABS.Joiner_scionox_locked_lift_trikey_lockgate_switch =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",

  map    = "MAP09",
  key    = "k_ALL",
}

PREFABS.Joiner_scionox_locked_lift_trikey_lockgate_switch_urban =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",

  map    = "MAP09",

  key    = "k_ALL",
  theme  = "urban",

  tex_COMPBLUE = { BIGBRIK1=50, BRICK10=50, BRICK11=50, WOOD12=50, WOOD1=60, PANEL4=50 },

  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_locked_lift_trikey_lockgate_switch_urban =
{
  template = "Joiner_scionox_locked_lift_lockgate_switch",
  map    = "MAP09",
  key = "k_ALL",
  theme  = "hell",

  tex_DOORRED = "DOORRED2",
  tex_DOORBLU = "DOORBLU2",
  tex_DOORYEL = "DOORYEL2",
  tex_COMPBLUE = { REDWALL=50, GSTONE1=50, METAL=50, SP_FACE2=50, SKSNAKE2=60, WOODVERT=50 },
  tex_SW1GRAY = "SW1MARB",
  tex_PLAT1 = "SUPPORT3",
  tex_SUPPORT2 = "SUPPORT3",
  tex_BIGDOOR1 = "MARBFAC3",

  thing_2028 = "red_torch_sm",
}
