--
-- Pictures (via the closet system)
--

TEMPLATES.Pic_box_template =
{
  file   = "picture/pic_box.wad"
  map    = "MAP01"

  prob  = 100
  env   = "building"

  where  = "seeds"
  seed_w = 1
  seed_h = 1

  height = 128
  deep   =  16
  over   = -16

  x_fit = "frame"
  y_fit = "top"

  sector_1 = 0   -- sector special
  line_2   = 0   -- line special

  offset_1 = 0   -- X offset
  offset_2 = 0   -- Y offset
}


----- TECH THEME ------------------------------


PREFABS.Pic_box_liteblu1 =
{
  template = "Pic_box_template"

  theme = "tech"

  tex_PIPES = "LITEBLU1"
}


PREFABS.Pic_box_tekgren3 =
{
  template = "Pic_box_template"

  theme = "tech"
  game  = "doom2"

  tex_PIPES = "TEKGREN3"
}


PREFABS.Pic_box_silver3 =
{
  template = "Pic_box_template"
  map      = "MAP02"

  theme = "tech"

  height = 176

  tex_PIPES = "SILVER3"
}


PREFABS.Pic_box_silver2 =
{
  template = "Pic_box_template"
  map      = "MAP06"

  theme = "tech"

  seed_w = 2
  height = 176

  tex_PIPES = "SILVER2"
}


PREFABS.Pic_box_UAC =
{
  template = "Pic_box_template"
  map      = "MAP04"

  prob  = 50
  theme = "tech"

  seed_w = 2

  tex_PIPES = "SHAWN1"
}


PREFABS.Pic_box_computer =
{
  template = "Pic_box_template"
  map      = "MAP03"

  prob  = 300
  theme = "tech"

  seed_w = 2

  tex_PIPES = { COMPSTA1=40, COMPSTA2=40 }

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=30, [1]=10 }
}


----- URBAN THEME -----------------------------


PREFABS.Pic_box_gargoyles =
{
  template = "Pic_box_template"

  prob  = 50
  theme = "urban"

  tex_PIPES = { GSTGARG=20, GSTLION=20, GSTSATYR=20 }
  offset_2  = 9
}


PREFABS.Pic_box_gargoyles2 =
{
  template = "Pic_box_template"

  prob  = 150
  theme = "urban"

  tex_PIPES = { SW1GARG=20, SW1LION=20, SW1GARG=20 }
  offset_2  = 55
}


PREFABS.Pic_box_woodskull =
{
  template = "Pic_box_template"
  map      = "MAP04"

  prob   = 150
  theme  = "urban"

  seed_w = 2

  tex_PIPES = "WOOD4"
}


PREFABS.Pic_box_big_faces =
{
  template = "Pic_box_template"
  map      = "MAP06"

  prob   = 300
  theme  = "!tech"

  seed_w = 2
  height = 176

  tex_PIPES = { MARBFACE=10, MARBFAC2=20, MARBFAC3=40 }
}


----- HELL THEME ------------------------------


PREFABS.Pic_box_marbfac4 =
{
  template = "Pic_box_template"

  theme = "hell"

  tex_PIPES = "MARBFAC4"
  offset_2  = 13
}


PREFABS.Pic_box_sp_face1 =
{
  template = "Pic_box_template"
  map      = "MAP05"

  seed_w = 2
  height = 160

  prob   = 70
  theme  = "hell"

  tex_PIPES = "SP_FACE1"
  line_2    = 48  -- scrolling
}


PREFABS.Pic_box_skinface =
{
  template = "Pic_box_template"
  map      = "MAP05"

  prob   = 70
  theme  = "hell"

  seed_w = 2
  height = 160

  tex_PIPES = "SKINFACE"
  offset_2  = 16
  line_2    = 48  -- scrolling
}


PREFABS.Pic_box_huge_demon =
{
  template = "Pic_box_template"
  map      = "MAP08"

  rank  = 3
  theme = "hell"

  seed_w = 3
  height = 176

  tex_PIPES = "ZZZFACE4"
}


----- EGYPT THEME ------------------------------


PREFABS.Pic_box_mural2 =
{
  template = "Pic_box_template"
  map      = "MAP06"

  rank   = 2
  theme  = "egypt"

  seed_w = 2
  height = 176

  tex_PIPES = "MURAL2"
}


PREFABS.Pic_box_huge_mural =
{
  template = "Pic_box_template"
  map      = "MAP08"

  rank  = 3
  theme = "egypt"

  seed_w = 3
  height = 176

  tex_PIPES = "BIGMURAL"
}

