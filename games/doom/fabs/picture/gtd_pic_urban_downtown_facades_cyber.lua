PREFABS.Pic_urban_downtown_facade_cyber_mid_inset =
{
  file = "picture/gtd_pic_urban_downtown_facades_cyber.wad",
  map  = "MAP01",

  prob  = 100,
  theme = "urban",

  env = "outdoor",

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  where = "seeds",

  height = 368,

  y_fit = "top",
  x_fit = { 124,132 },
  z_fit = { 140,252 },

  texture_pack = "armaetus",

  tex_MODWALL3 =
  {
    MODWALL2 = 5,
    MODWALL3 = 5,
    MODWALL4 = 5,
    BLAKWAL1 = 5,
    BLAKWAL2 = 5,
    STEP1 = 5,
    STEP3 = 5,
    STEP4 = 5,
    STEP5 = 5,
    STEPLAD1 = 5,
  },

  tex_MODWALL4 =
  {
    MODWALL2 = 5,
    MODWALL3 = 5,
    MODWALL4 = 5,
    BLAKWAL1 = 5,
    BLAKWAL2 = 5,
  },

  tex_CITY02 =
  {
    BLAKWAL1 = 1,
    BLAKWAL2 = 1,
    MODWALL3 = 1,
    MODWALL4 = 1,
    CITY02 = 1,
    CITY03 = 1,
    CITY04 = 1,
    CITY05 = 1,
    CITY06 = 1,
    CITY07 = 1,
    CITY11 = 1,
    CITY12 = 1,
    CITY13 = 1,
    CITY14 = 1,
  },

  tex_CITY05 =
  {
    BLAKWAL1 = 1,
    BLAKWAL2 = 1,
    MODWALL3 = 1,
    MODWALL4 = 1,
    CITY02 = 1,
    CITY03 = 1,
    CITY04 = 1,
    CITY05 = 1,
    CITY06 = 1,
    CITY07 = 1,
    CITY11 = 1,
    CITY12 = 1,
    CITY13 = 1,
    CITY14 = 1,
  },

  tex_FENCE1 =
  {
    FENCE2 = 1,
    FENCE3 = 1,
    FENCE6 = 1,
    FENCE7 = 1,
    ZZWOLF10 = 5,
  },

  bound_z1 = 0,
  bound_z2 = 368,
}

PREFABS.Pic_urban_downtown_facade_cyber_mid_inset_top_fit =
{
  template = "Pic_urban_downtown_facade_cyber_mid_inset",

  z_fit = { 260,264 },
}

PREFABS.Pic_urban_downtown_facade_cyber_notched =
{
  template = "Pic_urban_downtown_facade_cyber_mid_inset",
  map = "MAP02",

  height = 256,

  z_fit = { 140,252 },

  bound_z2 = 256,
}
