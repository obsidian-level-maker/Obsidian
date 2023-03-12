PREFABS.Pic_urban_downtown_facade1_vanilla =
{
  file   = "picture/gtd_pic_urban_downtown_facades.wad",
  map    = "MAP01",

  prob   = 200,
  theme  = "urban",

  env    = "outdoor",

  seed_w = 2,
  seed_h = 1,

  where  = "seeds",
  deep   = 16,

  height = 256,

  y_fit  = "top",
  x_fit  = { 124,132 },

  tex_CITY01 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,

    BIGBRIK3 = 7,
    BRONZE4 = 10,
    METAL6 = 10,
    METAL7 = 10,
    TEKGREN5 = 10,
    TEKBRON2 = 10
  },

  flat_TLITE6_6 =
  {
    TLITE6_5 = 25,
    TLITE6_6 = 25
  },

  -- textures for the top half of the 'door' area
  tex_MODWALL3 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50
  },

  -- textures for the bottom half (and all of the 'doors' in facade2)
  tex_MODWALL4 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP4 = 50,
    STEP5 = 50,
    STEPLAD1 = 50
  },

  tex_STEP4 =
  {
    STEP1=50,
    STEP2=50,
    STEP3=50,
    STEP4=50,
    STEP5=50,
    STEP6=50,
    STEPLAD1=50,
    COMPBLUE=50,
    REDWALL=50
  }
}

PREFABS.Pic_urban_downtown_facade2_vanilla =
{
  template = "Pic_urban_downtown_facade1_vanilla",
  map      = "MAP02"
}

PREFABS.Pic_urban_downtown_facade1_EPIC =
{
  file   = "picture/gtd_pic_urban_downtown_facades.wad",
  map    = "MAP01",

  prob   = 200,
  theme  = "urban",

  env    = "outdoor",

  replaces = "Pic_urban_downtown_facade1_vanilla",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 1,

  where  = "seeds",
  deep   = 16,

  height = 256,

  y_fit  = "top",
  x_fit  = { 124,132 },

  tex_CITY01 =
  {
    MODWALL2 = 25,
    MODWALL3 = 25,
    MODWALL4 = 25,
    BLAKWAL1 = 25,
    BLAKWAL2 = 25,

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25,

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

    TEKGREN5 = 10,
    TEKBRON2 = 10
  },

  flat_TLITE6_6 =
  {
    TLITE5_2 = 25,
    TLITE5_3 = 25,
    TLITE6_5 = 25,
    TLITE6_6 = 25,
    TLITE65B = 25,
    TLITE65G = 25,
    TLITE65O = 25,
    TLITE65W = 25,
    TLITE65Y = 25,
    GLITE04 = 50,
    GLITE06 = 50,
    GLITE07 = 50,
    GLITE08 = 50,
    GLITE09 = 50,
    LIGHTS1 = 50,
    LIGHTS2 = 50,
    LIGHTS3 = 50,
    LIGHTS4 = 50
  },

  -- textures for the top half of the 'door' area
  tex_MODWALL3 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,
    TEKWALL8 = 15,
    TEKWALL9 = 15,
    TEKWALLA = 15,
    TEKWALLB = 15,
    TEKWALLC = 15,
    TEKWALLD = 15,
    TEKWALLE = 15,
    COLLITE1 = 50,
    COLLITE2 = 50,
    COLLITE3 = 50
  },

  -- textures for the bottom half (and all of the 'doors' in facade2)
  tex_MODWALL4 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP4 = 50,
    STEP5 = 50,
    STEPLAD1 = 50,
    URBAN6 = 175,
    URBAN8 = 175
  },

  tex_STEP4 =
  {
    STEP1=50,
    STEP2=50,
    STEP3=50,
    STEP4=50,
    STEP5=50,
    STEP6=50,
    STEPLAD1=50,
    COMPBLUE=50,
    REDWALL=50
  }
}

PREFABS.Pic_urban_downtown_facade2_EPIC =
{
  template = "Pic_urban_downtown_facade1_EPIC",
  map      = "MAP02",

  replaces = "Pic_urban_downtown_facade2_vanilla"
}




---------------------------------------------------------------------------------
-- Facade3 are buildings that don't have sort of window shop entrances
---------------------------------------------------------------------------------

PREFABS.Pic_urban_downtown_facade3_vanilla =
{
  file   = "picture/gtd_pic_urban_downtown_facades.wad",
  map    = "MAP01",

  prob   = 250,
  theme  = "urban",

  env    = "outdoor",

  seed_w = 2,
  seed_h = 1,

  where  = "seeds",
  deep   = 16,
  over   = -16,

  height = 256,

  y_fit  = "top",
  x_fit  = { 168,216 },

  tex_CITY01 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,

    BIGBRIK3 = 7,
    BRONZE4 = 10,
    METAL6 = 10,
    METAL7 = 10,
    TEKGREN5 = 10,
    TEKBRON2 = 10
  },

  flat_TLITE6_6 =
  {
    TLITE6_5 = 25,
    TLITE6_6 = 25
  },

  -- textures for the top half of the 'door' area
  tex_MODWALL3 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50
  },

  -- textures for the bottom half (and all of the 'doors' in facade2)
  tex_MODWALL4 =
  {
    MODWALL2 = 50,
    MODWALL3 = 50,
    MODWALL4 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP4 = 50,
    STEP5 = 50,
    STEPLAD1 = 50
  },

  tex_STEP4 =
  {
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP4 = 50,
    STEP5 = 50,
    STEP6 = 50,
    STEPLAD1 = 50,
    COMPBLUE = 50,
    REDWALL = 50
  }
}

PREFABS.Pic_urban_downtown_facade3_EPIC =
{
  file   = "picture/gtd_pic_urban_downtown_facades.wad",
  map    = "MAP03",

  prob   = 250,
  theme  = "urban",

  env    = "outdoor",

  replaces = "Pic_urban_downtown_facade3_vanilla",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 1,

  where  = "seeds",
  deep   = 16,

  height = 256,

  y_fit  = "top",
  x_fit  = { 168,216 },

  tex_CITY01 =
  {
    MODWALL2 = 25,
    MODWALL3 = 25,
    MODWALL4 = 25,
    BLAKWAL1 = 25,
    BLAKWAL2 = 25,

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25,

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

    TEKGREN5 = 10,
    TEKBRON2 = 10
  },

  tex_STEP4 =
  {
    STEP1=50,
    STEP2=50,
    STEP3=50,
    STEP4=50,
    STEP5=50,
    STEP6=50,
    STEPLAD1=50,
    COMPBLUE=50,
    REDWALL=50
  }
}

PREFABS.Pic_urban_downtown_facade_EPIC_destroyed =
{
  template = "Pic_urban_downtown_facade3_EPIC",
  map = "MAP04",

  replaces = nil,

  skip_prob = 50,
  prob = 80,

  over = 0,

  x_fit = "frame"
}

PREFABS.Pic_urban_downtown_facade_fenced_out =
{
  template = "Pic_urban_downtown_facade3_EPIC",
  map = "MAP05",

  prob = 200,

  y_fit = { 32,40 },
  z_fit = "top",

  tex_CITY01 =
  {
    MODWALL2 = 25,
    MODWALL3 = 25,
    MODWALL4 = 25,
    BLAKWAL1 = 25,
    BLAKWAL2 = 25,

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25
  }
}

PREFABS.Pic_urban_downtown_facade_alley =
{
  template = "Pic_urban_downtown_facade3_EPIC",
  map = "MAP06",

  height = 256,

  in_porches = "never",

  seed_h = 2,

  prob = 200,

  y_fit = { 32,40 },
  z_fit = { 176,184 },

  tex_CITY01 =
  {
    MODWALL2 = 25,
    MODWALL3 = 25,
    MODWALL4 = 25,
    BLAKWAL1 = 25,
    BLAKWAL2 = 25,

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25
  }
}

PREFABS.Pic_urban_downtown_facade_fenced_roof =
{
  template = "Pic_urban_downtown_facade3_EPIC",
  map = "MAP07",

  height = 304,

  prob = 150,

  in_porches = "never",

  y_fit = { 16,122 },
  z_fit = { 144,156 },

  bound_z1 = 0,
  bound_z2 = 304,

  tex_MIDBARS3 =
  {
    MIDBARS3 = 1,
    MIDSPACE = 1,
    MIDSPAC2 = 1,
    MIDSPAC3 = 1,
    MIDSPAC4 = 1,
    MIDSPAC5 = 1,
    MIDWIND1 = 1,
    MIDWIND6 = 1,
    FENCE1 = 1,
    FENCE2 = 1,
    FENCE3 = 1,
    FENCE6 = 1,
    FENCE7 = 1
  }
}

PREFABS.Pic_urban_downtown_facade_destroyed_roof =
{
  template = "Pic_urban_downtown_facade3_EPIC",
  map = "MAP08",

  height = 240,

  skip_prob = 50,
  prob = 80,

  deep = 16,

  in_porches = "never",

  x_fit = { 16,240 },
  y_fit = "top",
  z_fit = { 88,104 , 216,236 },

  bound_z1 = 0,
  bound_z2 = 240
}

  -- Garage door fakeout

PREFABS.Pic_urban_downtown_facade4_vanilla =
{
  template = "Pic_urban_downtown_facade3_vanilla",
  map      = "MAP09",

  prob = 300,

  seed_w = 3
}

PREFABS.Pic_urban_downtown_facade_advert =
{
  template = "Pic_urban_downtown_facade3_EPIC",
  map = "MAP10",

  height = 296,

  in_porches = "never",

  seed_h = 2,

  prob = 200,

  x_fit  = { 48,56 , 200,208 },
  y_fit = { 64,80 },
  z_fit = "top",

  sector_17 = { [0]=50, [17]=50 },

  tex_CITY01 =
  {
    MODWALL2 = 25,
    MODWALL3 = 25,
    MODWALL4 = 25,
    BLAKWAL1 = 25,
    BLAKWAL2 = 25,

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25
  },

  tex_WOOD8 =
  {

    CRGNRCK2 = 50,
    ADVCR1 = 50,
    ADVCR2 = 50,
    ADVCR4 = 50,
    ADVDE1 = 50,
    ADVDE2 = 50,
    ADVDE3 = 50,
    ADVDE5 = 50,
    ADVDE7 = 50
  }
}
