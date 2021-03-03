--Generic secret lift

PREFABS.Joiner_scionox_secret_lift =
{
  file   = "joiner/scionox_secret_lift.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "tech",
  key    = "secret",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = 16,

  delta_h  = 120,
  nearby_h = 128,

  bound_z1 = 0,
  bound_z2 = 192,

  x_fit  = "frame",
  y_fit  = {72,152},

  tex_PIPES = { PIPES=50, BLAKWAL1=50, COMPBLUE=50, GRAY5=50, PIPEWAL2=50, SILVER3=50, TEKLITE2=50 },
}

PREFABS.Joiner_scionox_secret_lift_2 =
{
  template = "Joiner_scionox_secret_lift",
  theme  = "urban",
  tex_PIPES = { PIPES=50, BLAKWAL1=50, CEMENT9=50, GRAY5=50, PIPEWAL2=50, MODWALL1=50, MODWALL3=50 },
}

PREFABS.Joiner_scionox_secret_lift_3 =
{
  template = "Joiner_scionox_secret_lift",
  theme  = "hell",
  tex_PIPES = { BSTONE3=50, CRACKLE2=50, GSTGARG=50, GSTLION=50, GSTSATYR=50, SKSNAKE1=50, SP_DUDE4=50 },
}

PREFABS.Joiner_scionox_secret_lift_4 =
{
  file   = "joiner/scionox_secret_lift.wad",
  map    = "MAP02",

  prob   = 50,
  theme  = "tech",
  key    = "secret",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = 16,

  delta_h  = 120,
  nearby_h = 128,

  bound_z1 = 0,
  bound_z2 = 192,

  x_fit  = "frame",
  y_fit  = {72,152},

  thing_15 =
  {
    dead_player = 10,
    dead_imp = 10,
    gibs = 10,
    gibbed_player = 10,
    pool_brains = 10,
    candle = 10,
  },
  tex_PIPES = { PIPES=50, BLAKWAL1=50, COMPBLUE=50, GRAY5=50, PIPEWAL2=50, SILVER3=50, TEKLITE2=50 },
}

PREFABS.Joiner_scionox_secret_lift_5 =
{
  template = "Joiner_scionox_secret_lift_4",
  theme  = "urban",
  tex_PIPES = { PIPES=50, BLAKWAL1=50, CEMENT9=50, GRAY5=50, PIPEWAL2=50, MODWALL1=50, MODWALL3=50 },
}

PREFABS.Joiner_scionox_secret_lift_6 =
{
  template = "Joiner_scionox_secret_lift_4",
  theme  = "hell",
  tex_PIPES = { BSTONE3=50, CRACKLE2=50, GSTGARG=50, GSTLION=50, GSTSATYR=50, SKSNAKE1=50, SP_DUDE4=50 },
}

--Generic secret lift (downward version)

PREFABS.Joiner_scionox_secret_lift_down =
{
  file   = "joiner/scionox_secret_lift.wad",
  map    = "MAP03",

  prob   = 50,
  theme  = "tech",
  key    = "secret",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = 16,

  delta_h = -128,
  nearby_h = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit  = "frame",
  y_fit  = {84,156},

  tex_PIPES = { PIPES=50, BLAKWAL1=50, COMPBLUE=50, GRAY5=50, PIPEWAL2=50, SILVER3=50, TEKLITE2=50 },
}

PREFABS.Joiner_scionox_secret_lift_down_2 =
{
  template = "Joiner_scionox_secret_lift_down",
  theme  = "urban",
  tex_PIPES = { PIPES=50, BLAKWAL1=50, CEMENT9=50, GRAY5=50, PIPEWAL2=50, MODWALL1=50, MODWALL3=50 },
}

PREFABS.Joiner_scionox_secret_lift_down_3 =
{
  template = "Joiner_scionox_secret_lift_down",
  theme  = "hell",
  tex_PIPES = { BSTONE3=50, CRACKLE2=50, GSTGARG=50, GSTLION=50, GSTSATYR=50, SKSNAKE1=50, SP_DUDE4=50 },
}

PREFABS.Joiner_scionox_secret_lift_down_corpse_hint =
{
  file   = "joiner/scionox_secret_lift.wad",
  map    = "MAP04",

  prob   = 50,
  theme  = "tech",
  key    = "secret",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = 16,

  delta_h = -128,
  nearby_h = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit  = "frame",
  y_fit  = {84,156},

  thing_15 =
  {
    dead_player = 10,
    dead_imp = 10,
    gibs = 10,
    gibbed_player = 10,
    pool_brains = 10,
    candle = 10,
  },

  tex_PIPES = { PIPES=50, BLAKWAL1=50, COMPBLUE=50, GRAY5=50, PIPEWAL2=50, SILVER3=50, TEKLITE2=50 },
}

PREFABS.Joiner_scionox_secret_lift_down_corpse_hint_2 =
{
  template = "Joiner_scionox_secret_lift_down_corpse_hint",
  theme  = "urban",
  tex_PIPES = { PIPES=50, BLAKWAL1=50, CEMENT9=50, GRAY5=50, PIPEWAL2=50, MODWALL1=50, MODWALL3=50 },
}

PREFABS.Joiner_scionox_secret_lift_down_corpse_hint_3 =
{
  template = "Joiner_scionox_secret_lift_down_corpse_hint",
  theme  = "hell",
  tex_PIPES = { BSTONE3=50, CRACKLE2=50, GSTGARG=50, GSTLION=50, GSTSATYR=50, SKSNAKE1=50, SP_DUDE4=50 },
}
