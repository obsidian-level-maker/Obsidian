PREFABS.Pic_EPIC_box_template = -- this is now a base template and is disabled.
{
  file   = "picture/gtd_pic_EPIC.wad",
  map    = "MAP01",

  prob  = 0,
  env   = "building",
  theme = "!tech",

  texture_pack = "armaetus",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  height = 160,
  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_1 = 0,
  line_2   = 0,

  offset_1 = 0,
  offset_2 = 0,
}

--[[PREFABS.Pic_EPIC_box_gothic_tall =
{
  template = "Pic_EPIC_box_template",
  map = "MAP02",

  prob = 40 * 5,

  seed_w = 1,

  tex_GLASS11 =
  {
    GLASS9 = 50,
    GLASS11 = 50,
    GLASS12 = 50,
    GLASS13 = 50,
    GLASS14 = 50,
  },
}

PREFABS.Pic_EPIC_box_gothic_semibig =
{
  template = "Pic_EPIC_box_template",
  map = "MAP03",

  prob = 40 * 2,

  seed_w = 1,

  tex_GLASS10 =
  {
    GLASS10 = 50,
    GLASS7 = 50,
  },
}]]

PREFABS.Pic_EPIC_box_skeletons =
{
  template = "Pic_EPIC_box_template",
  map = "MAP20", -- low brightness version of MAP01,

  prob = 35 * 8,

  theme = "hell",

  seed_w = 2,

  tex_GLASS1 =
  {
    DEATH1 = 50,
    DEATH2 = 50,
    DEATH3 = 50,
    GUY1   = 25,
    PENTA1 = 5,
  },
}

PREFABS.Pic_EPIC_box_marblefaces =
{
  template = "Pic_EPIC_box_template",
  map = "MAP20", -- low brightness version of MAP01,

  prob = 32 * 7,

  theme = "hell",

  seed_w = 2,

  tex_GLASS1 =
  {
    MARBFAB1 = 50,
    MARBFAB2 = 50,
    MARBFAB3 = 50,
    MARBFAC5 = 50,
    MARBFAC6 = 50,
    MARBFAC7 = 50,
    MARBFAC8 = 50,
    MARBFAC9 = 50,
    MARBFACA = 50,
    MARBFACB = 50,
    MARBFACF = 50,
  },
}

PREFABS.Pic_EPIC_box_wallofskulls =
{
  template = "Pic_EPIC_box_template",
  map = "MAP01",

  prob = 35 * 8,

  theme = "hell",

  seed_w = 2,

  tex_GLASS1 =
  {
   SKULLS  = 50,
   SKULLS2 = 50,
   BODIESB = 50,
   SKULLS3 = 50,
   SKULLS4 = 50,
  },
}

PREFABS.Pic_EPIC_box_doom2bodies =
{
  template = "Pic_EPIC_box_template",
  map = "MAP20", -- dark version of MAP01,

  prob = 30 * 8,

  theme = "hell",

  seed_w = 2,

  tex_GLASS1 =
  {
    SPDUDE7 = 50,
    SPDUDE8 = 50,
  },
}

PREFABS.Pic_EPIC_box_gothic_hangingbodies =
{
  template = "Pic_EPIC_box_template",
  map = "MAP03",

  prob = 30 * 2,

  theme = "hell",

  seed_w = 1,

  tex_GLASS10 =
  {
   SPDUDE3 = 50, -- Doom1 exclusive
   SPDUDE6 = 50, -- Doom1 exclusive
   SP_DUDE4 = 30,
   SP_DUDE5 = 30,
  },
}

PREFABS.Pic_EPIC_box_small_facesofevil =
{
  template = "Pic_EPIC_box_template",
  map = "MAP04",

  prob = 40 * 9,

  height = 128,

  theme = "hell",

  seed_w = 1,

  tex_COMPSA1 =
  {
    EVILFAC2 = 50,
    EVILFAC4 = 50,
    EVILFAC5 = 50,
    EVILFAC6 = 50,
    EVILFAC7 = 50,
  },
}

PREFABS.Pic_EPIC_box_metal_big =
{
  template = "Pic_EPIC_box_template",
  map = "MAP01",

  prob = 40 * 8,

  theme = "tech",

  seed_w = 2,

  tex_GLASS1 =
  {
    COMPCT01 = 50,
    COMPCT02 = 50,
    COMPCT03 = 50,
    COMPCT04 = 50,
    COMPCT05 = 50,
    COMPCT06 = 50,
    SHAWVENT = 50,
    SHAWVEN2 = 50,
    CGCANI00 = 50,
  },
}

PREFABS.Pic_EPIC_box_bishop =
{
  template = "Pic_EPIC_box_template",
  map = "MAP01",

  prob = 30 * 8,

  theme = "!tech",

  seed_w = 2,

  tex_GLASS1 =
  {
   BISHOP = 100,
   GOTH50 = 25,
  },
}

PREFABS.Pic_EPIC_box_metal_big =
{
  template = "Pic_EPIC_box_template",
  map = "MAP01",

  prob = 40 * 8,

  theme = "tech",

  seed_w = 2,

  tex_GLASS1 =
  {
    COMPCT01 = 50,
    COMPCT02 = 50,
    COMPCT03 = 50,
    COMPCT04 = 50,
    COMPCT05 = 50,
    COMPCT06 = 50,
    SHAWVENT = 50,
    SHAWVEN2 = 50,
    CGCANI00 = 50,
  },
}

PREFABS.Pic_EPIC_box_metal_big_bunchacomputers =
{
  template = "Pic_EPIC_box_template",
  map = "MAP01",

  prob = 40 * 8,

  theme = "tech",

  seed_w = 2,

  tex_GLASS1 =
  {
    CONSOLE4 = 50,
    CONSOLE6 = 50,
    CONSOLE7 = 25,
    CONSOLE8 = 50,
    CONSOLE9 = 25,
    CONSOLEA = 50,
    CONSOLEB = 50,
    CONSOLEC = 50,
    CONSOLED = 50,
    CONSOLEE = 50,
    CGCANI00 = 50,
    NOISE1   = 50,
  },
}

PREFABS.Pic_EPIC_box_static =
{
  template = "Pic_EPIC_box_template",
  map = "MAP04",

  prob = 25 * 10,

  height = 128,

  theme = "tech",

  seed_w = 1,

  tex_COMPSA1 =
  {
    NOISE2A = 50,
    NOISE3A = 50,
    TVSNOW01 = 50,
    COMPFUZ1 = 50,
  },
}

PREFABS.Pic_EPIC_box_metal_small =
{
  template = "Pic_EPIC_box_template",
  map = "MAP04",

  prob = 40 * 10,

  height = 128,

  theme = "tech",

  seed_w = 1,

  tex_COMPSA1 =
  {
    COMPSA1 = 50,
    COMPSC1 = 50,
    COMPSD1 = 50,
    COMPY1 = 50,
    COMPFUZ1 = 30,
    COMPU1 = 50,
    COMPU2 = 50,
    COMPU3 = 50,
    COMPVENT = 50,
    COMPVEN2 = 50,
    NMONIA1 = 50,
    DECMP04A = 50,
  },
}

PREFABS.Pic_EPIC_box_metal_wide =
{
  template = "Pic_EPIC_box_template",
  map = "MAP05",

  prob = 40 * 9,

  height = 128,

  theme = "tech",

  seed_w = 2,

  tex_COMPSTA3 =
  {
    COMPSTA1 = 50,
    COMPSTA2 = 50,
    COMPSTA3 = 50,
    COMPSTA4 = 50,
    COMPSTA5 = 50,
    COMPSTA6 = 50,
    COMPSTA7 = 50,
    COMPSTA8 = 50,
    COMPSTA9 = 50,
    COMPSTAA = 50,
    COMPSTAB = 50,
  },
}

PREFABS.Pic_EPIC_box_silverwall =
{
  template = "Pic_EPIC_box_template",
  map = "MAP01",

  prob = 25 * 7,

  theme = "tech",

  seed_w = 2,

  tex_GLASS1 =
  {
   SILVER2 = 50,
   SILVER2G = 50,
   SILVER2O = 50,
   SILVER2R = 50,
   SILVER2W = 50,
   SILVER2Y = 50,
  },
}

-- 3 seeds wide!!
PREFABS.Pic_EPIC_box_metal_superwide =
{
  template = "Pic_EPIC_box_template",
  map = "MAP06",

  prob = 30 * 6,

  height = 160,

  theme = "tech",

  seed_w = 3,

  tex_GLASS1 =
  {
    PLAN1    = 75,
    PLAN2    = 75,
    COMPCT07 = 50,
    CONSOLE3 = 50,
    CONSOLEF = 50,
    CONSOLEG = 50,
    SHAWCOMP = 10,
    METACOMP = 10,
    SILVCOMP = 10,
  },

  sector_1  = { [0]=70, [1]=15 },

}

-- This is 256x56,
PREFABS.Pic_EPIC_superwide_longconsole =
{
  template = "Pic_EPIC_box_template",
  map = "MAP07",

  prob = 25 * 5,

  theme = "tech",

  seed_w = 3,

  tex_GLASS1 =
  {
   CONSOLE5 = 100,
  },

  sector_1  = { [0]=70, [1]=20 },

}

-- 64x192,
PREFABS.Pic_EPIC_ridiculously_tall =
{
  template = "Pic_EPIC_box_template",

  map = "MAP08",

  prob = 25 * 5,

  theme = "!tech",

  height = 224,

  seed_w = 1,

  tex_WINGLAS1 =
  {
    WINGLAS1 = 50,
    WINGLAS2 = 50,
    WINGLAS3 = 50,
    WINGLAS4 = 50,
  },
}

PREFABS.Pic_EPIC_box_whitelion_and_goat =
{
  template = "Pic_EPIC_box_template",
  map = "MAP10",

  prob = 35 * 4,

  theme = "!tech",

  seed_w = 2,

  tex_GLASS1 =
  {
    LIONMRB1 = 50,
    LIONMRB2 = 50,
    LIONMRB3 = 50,
    GOATMARB = 50,
  },
}


PREFABS.Pic_EPIC_GreekDude =
{
  template = "Pic_EPIC_box_template",
  map = "MAP11",

  prob = 35,

  height = 128,

  theme = "!tech",

  seed_w = 3,

  tex_GLASS1 = "MARBLFAC",

  sector_1  = { [0]=70, [1]=10 },

}

PREFABS.Pic_EPIC_Devilish =
{
  template = "Pic_EPIC_box_template",
  map = "MAP03",

  prob = 35 * 3,

  theme = "hell",

  seed_w = 1,

  tex_GLASS10 =
  {
    DEMSTAT = 60,
    GOTH50  = 30,
    GOTH04  = 15,
  },
}

PREFABS.Pic_EPIC_WoodenDemon =
{
  template = "Pic_EPIC_box_template",
  map = "MAP11",

  prob = 35,

  height = 160,

  theme = "!tech",

  seed_w = 3,

  tex_GLASS1 = "WOODDEM1",

  sector_1  = { [0]=75, [1]=15 },
}


-- Modified to have Static Sounds

PREFABS.Pic_EPIC_box_static_sounds =
{
  template = "Pic_EPIC_box_template",
  map = "MAP12",

  prob = 25 * 10,

  height = 128,

  theme = "tech",

  seed_w = 1,

  tex_COMPSA1 =
  {
   NOISE2A = 50,
   NOISE3A = 50,
   TVSNOW01 = 50,
   COMPFUZ1 = 50,
  },

  sound = "Static_Monitor",
}

PREFABS.Pic_EPIC_box_metal_small_sounds =
{
  template = "Pic_EPIC_box_template",
  map = "MAP12",

  prob = 40 * 10,

  height = 128,

  theme = "tech",

  seed_w = 1,

  tex_COMPSA1 =
  {
    COMPSA1 = 50,
    --COMPSC1 = 50,
    COMPSD1 = 50,
    --COMPY1 = 50,
    COMPFUZ1 = 30,
    --COMPU1 = 50,
    --COMPU2 = 50,
    --COMPU3 = 50,
    --COMPVENT = 50,
    --COMPVEN2 = 50,
    --NMONIA1 = 50,
    DECMP04A = 50,
  },

  sound = "Static_Monitor",
}
