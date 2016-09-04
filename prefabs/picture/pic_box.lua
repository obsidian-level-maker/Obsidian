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
  map = "MAP02"

  theme = "tech"

  tex_PIPES = "SILVER3"
}


----- URBAN THEME -----------------------------


----- HELL THEME ------------------------------

