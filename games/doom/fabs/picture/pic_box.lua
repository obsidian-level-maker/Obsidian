--
-- Pictures (via the closet system)
--

TEMPLATES.Pic_box_template =
{
  file   = "picture/pic_box.wad",
  map    = "MAP01",

  prob  = 100,
  env   = "building",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  height = 128,
  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_1 = 0,   -- sector special
  line_2   = 0,   -- line special

  offset_1 = 0,   -- X offset
  offset_2 = 0   -- Y offset
}


----- TECH THEME ------------------------------


PREFABS.Pic_box_liteblu1 =
{
  template = "Pic_box_template",
  map      = "MAP13",

  theme = "tech",

  tex_PIPES = "LITEBLU1",
}


PREFABS.Pic_box_tekgren3 =
{
  template = "Pic_box_template",
  map  = "MAP13",
  prob = 10,

  theme = "tech",
  game  = "doom2",

  tex_PIPES = "TEKGREN3",
}


PREFABS.Pic_box_shawn3 =
{
  template = "Pic_box_template",
  map  = "MAP13",

  theme = "tech",

  tex_PIPES = "SHAWN3",
}

PREFABS.Pic_box_silver3 =
{
  template = "Pic_box_template",
  map      = "MAP12",

  theme = "tech",

  height = 176,

  tex_PIPES = "SILVER3",
}

--flashy sides, 128px height
PREFABS.Pic_box_silver2 =
{
  template = "Pic_box_template",
  map      = "MAP11",

  theme = "tech",

  seed_w = 2,
  height = 176,

  tex_PIPES = "SILVER2",
}

--flashy sides, 64px height
PREFABS.Pic_box_UAC =
{
  template = "Pic_box_template",
  map      = "MAP10",

  prob  = 50,
  theme = "tech",

  seed_w = 2,

  tex_PIPES = "SHAWN1",
  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=50, [1]=15 },
}


--flashy sides, 48px height, sides edited to match Tech theme
PREFABS.Pic_box_computer =
{
  template = "Pic_box_template",
  map      = "MAP09",

  prob  = 300,
  theme = "tech",

  seed_w = 2,

  tex_PIPES = { COMPSTA1=40, COMPSTA2=40, SPACEW3=40 },

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=50, [1]=20, [8]=7 },
}

-- References --
--MAP07: 128x96, techy silver sides
--MAP09: 128x48, techy silver sides
--MAP10: 128x64, techy silver sides
--MAP11: 128x128, techy silver sides
--MAP12: 64x128, techy silver sides
--MAP13: 64x64, techy silver sides


----- URBAN THEME -----------------------------


PREFABS.Pic_box_gargoyles =
{
  template = "Pic_box_template",

  prob  = 50,
  theme = "!tech",

  tex_PIPES = { GSTGARG=20, GSTLION=20, GSTSATYR=20 },
  offset_2  = 9,
}


PREFABS.Pic_box_gargoyles2 =
{
  template = "Pic_box_template",

  prob  = 150,
  theme = "!tech",

  tex_PIPES = { SW1GARG=20, SW1LION=20, SW1GARG=20 },
  offset_2  = 55,
}


PREFABS.Pic_box_woodskull =
{
  template = "Pic_box_template",
  map      = "MAP04",

  prob   = 150,
  theme  = "!tech",

  seed_w = 2,

  tex_PIPES = "WOOD4",
}


PREFABS.Pic_box_big_faces =
{
  template = "Pic_box_template",
  map      = "MAP06",

  prob   = 300,
  theme  = "!tech",

  seed_w = 2,
  height = 176,

  tex_PIPES = { MARBFACE=10, MARBFAC2=20, MARBFAC3=40 },
}


----- HELL THEME ------------------------------


PREFABS.Pic_box_marbfac4 =
{
  template = "Pic_box_template",

  theme = "hell",

  tex_PIPES = "MARBFAC4",
  offset_2  = 13,
}


PREFABS.Pic_box_sp_face1 =
{
  template = "Pic_box_template",
  map      = "MAP05",

  seed_w = 2,
  height = 160,

  prob   = 70,
  theme  = "hell",

  tex_PIPES = "SP_FACE1",
  line_2    = 48,  -- scrolling

  sector_1  = { [0]=50, [1]=15 },

}


PREFABS.Pic_box_skinface =
{
  template = "Pic_box_template",
  map      = "MAP05",

  prob   = 70,
  theme  = "hell",

  seed_w = 2,
  height = 160,

  tex_PIPES = { SKINFACE=50, SP_FACE2=50 },
  offset_2  = 16,
  line_2    = 48  -- scrolling
}




----- EGYPT THEME ------------------------------


PREFABS.Pic_box_mural2 =
{
  template = "Pic_box_template",
  map      = "MAP06",

  rank   = 2,
  theme  = "egypt",

  seed_w = 2,
  height = 176,

  tex_PIPES = "MURAL2",
}


PREFABS.Pic_box_huge_mural =
{
  template = "Pic_box_template",
  map      = "MAP08",

  rank  = 3,
  theme = "egypt",

  seed_w = 3,
  height = 176,

  tex_PIPES = "BIGMURAL",
}

-- HELL THEME --

PREFABS.Pic_crucified1 =
{
  template = "Pic_box_template",
  map      = "MAP06",

 prob = 75,

  theme = "hell",

  seed_w = 2,
  height = 176,

  tex_PIPES = { SP_DUDE1=50, SP_DUDE2=50, SP_DUDE7=50 },
}

PREFABS.Pic_crucified2 =
{
  template = "Pic_box_template",
  map      = "MAP02",

 prob = 55,

  theme = "hell",

  seed_w = 2,
  height = 176,

  tex_PIPES = { SP_DUDE4=50, SP_DUDE5=50 },
}
