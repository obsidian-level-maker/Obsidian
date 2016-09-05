--
-- Pictures (via the closet system)
--

TEMPLATES.Pic_box_template =
{
  file   = "picture/pic_box.wad"
  map    = "MAP01"

  where  = "seeds"
  seed_w = 1
  seed_h = 1
  height = 128

  x_fit = "frame"
  y_fit = "top"

  env   = "building"
  prob  = 100

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

  tex_PIPES = "TEKGREN3"
}


PREFABS.Pic_box_silver3 =
{
  template = "Pic_box_template"

  map    = "MAP02"
  height = 176

  theme = "tech"

  tex_PIPES = "SILVER3"
}


PREFABS.Pic_box_silver2 =
{
  template = "Pic_box_template"

  map    = "MAP06"
  seed_w = 2
  height = 176

  theme = "tech"

  tex_PIPES = "SILVER2"
}


PREFABS.Pic_box_UAC =
{
  template = "Pic_box_template"

  map    = "MAP04"
  seed_w = 2

  theme = "tech"
  prob  = 50

  tex_PIPES = "SHAWN1"
}


PREFABS.Pic_box_computer =
{
  template = "Pic_box_template"

  map    = "MAP03"
  seed_w = 2

  theme = "tech"
  prob  = 300

  tex_PIPES = { COMPSTA1=40, COMPSTA2=40 }

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=30, [1]=10 }
}


----- URBAN THEME -----------------------------


PREFABS.Pic_box_gargoyles =
{
  template = "Pic_box_template"

  theme = "urban"

  tex_PIPES = { GSTGARG=20, GSTLION=20, GSTSATYR=20 }
  offset_2  = 9
}


PREFABS.Pic_box_big_faces =
{
  template = "Pic_box_template"

  map    = "MAP06"
  seed_w = 2
  height = 176

  theme  = "!tech"
  prob   = 300

  tex_PIPES = { MARBFACE=10, MARBFACE2=20, MARBFACE3=40 }
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

  map    = "MAP05"
  seed_w = 2
  height = 160

  theme  = "hell"
  prob   = 70

  tex_PIPES = "SP_FACE1"
  line_2    = 48  -- scrolling
}


PREFABS.Pic_box_skinface =
{
  template = "Pic_box_template"

  map    = "MAP05"
  seed_w = 2
  height = 160

  theme  = "hell"
  prob   = 70

  tex_PIPES = "SKINFACE"
  offset_2  = 16
  line_2    = 48  -- scrolling
}


PREFABS.Pic_box_huge_demon =
{
  template = "Pic_box_template"

  map    = "MAP08"
  seed_w = 3
  height = 176

  theme = "hell"
  prob  = 4000

  tex_PIPES = "ZZZFACE4"
}

