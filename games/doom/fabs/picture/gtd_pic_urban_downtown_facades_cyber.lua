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

  -- texture for the terraced wall
  tex_CITY02 =
  {
    BLAKWAL1 = 15,
    BLAKWAL2 = 15,
    MODWALL3 = 15,
    MODWALL4 = 15,
    CITY02 = 15,
    CITY03 = 15,
    CITY04 = 15,
    CITY05 = 15,
    CITY06 = 15,
    CITY07 = 15,
    CITY11 = 15,
    CITY12 = 15,
    CITY13 = 15,
    CITY14 = 15,

    -- technological-looking facades
    CMPTILE = 5,
    --
    COMPTIL2 = 2,
    COMPTIL3 = 2,
    COMPTIL4 = 2,
    COMPTIL5 = 2,
    COMPTIL6 = 2,
    --
    SHAWNDR = 2,
    SHAWVENT = 2,
    SHAWVEN2 = 2,
    SILVBLU1 = 2,
    TEKGRBLU = 2,
    --
    GRAYMET4 = 2,
    GRAYMET6 = 2,
    GRAYMET7 = 2,
    GRAYMET8 = 2,
    GRAYMET9 = 2,
    GRAYMETA = 2,
    GRAYMETB = 2,
    GRAYMETC = 2,
    --
    TEKWALL8 = 2,
    TEKWALL9 = 2,
    TEKWALLA = 2,
    TEKWALLB = 2,
    TEKWALLC = 2,
    TEKWALLD = 2,
    TEKWALLE = 2,
  
    BIGDOORF = 5,
    BIGBRIK3 = 5,
    BRONZE4 = 5,
    TEKGREN5 = 5,
    METAL6 = 5,
    METAL7 = 5,
  },

  -- texture for the top third
  tex_CITY05 =
  {
    BLAKWAL1 = 15,
    BLAKWAL2 = 15,
    MODWALL3 = 15,
    MODWALL4 = 15,
    CITY02 = 15,
    CITY03 = 15,
    CITY04 = 15,
    CITY05 = 15,
    CITY06 = 15,
    CITY07 = 15,
    CITY11 = 15,
    CITY12 = 15,
    CITY13 = 15,
    CITY14 = 15,

    -- technological-looking facades
    CMPTILE = 5,
    --
    COMPTIL2 = 2,
    COMPTIL3 = 2,
    COMPTIL4 = 2,
    COMPTIL5 = 2,
    COMPTIL6 = 2,
    --
    SHAWNDR = 2,
    SHAWVENT = 2,
    SHAWVEN2 = 2,
    SILVBLU1 = 2,
    TEKGRBLU = 2,
    --
    GRAYMET4 = 2,
    GRAYMET6 = 2,
    GRAYMET7 = 2,
    GRAYMET8 = 2,
    GRAYMET9 = 2,
    GRAYMETA = 2,
    GRAYMETB = 2,
    GRAYMETC = 2,
    --
    BIGDOORF = 5,
    BIGBRIK3 = 5,
    BRONZE4 = 5,
    TEKGREN5 = 5,
    METAL6 = 5,
    METAL7 = 5,
  },

  tex_FENCE1 =
  {
    FENCE2 = 1,
    FENCE3 = 1,
    FENCE6 = 1,
    FENCE7 = 1,
    O_INVIST = 5
  },

  bound_z1 = 0,
  bound_z2 = 368
}

PREFABS.Pic_urban_downtown_facade_cyber_mid_inset_top_fit =
{
  template = "Pic_urban_downtown_facade_cyber_mid_inset",

  z_fit = { 260,264 }
}

PREFABS.Pic_urban_downtown_facade_cyber_walltop =
{
  template = "Pic_urban_downtown_facade_cyber_mid_inset",
  map = "MAP02",

  height = 256,

  z_fit = "top",

  bound_z2 = 256
}
