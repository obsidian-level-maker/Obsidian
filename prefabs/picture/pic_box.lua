--
-- Pictures (via the closet system)
--

----- TECH THEME ------------------------------

PREFABS.Pic_box_base =
{
  file   = "picture/pic_box.wad"
  map    = "MAP01"

  where  = "seeds"
  seed_w = 1
  seed_h = 1

  x_fit = "frame"
  y_fit = "top"

  offset_1000 = 0   -- X offset
  offset_2000 = 0   -- Y offset

  tex_PIPES = "LITEBLU1"

  theme = "tech"
  prob  = 100
}


PREFABS.Pic_box_tekgren3 =
{
  template = "Pic_box_base"

  tex_PIPES = "TEKGREN3"
}


PREFABS.Pic_box_silver3 =
{
  template = "Pic_box_base"
  map = "MAP02"

  tex_PIPES = "SILVER3"
}


----- URBAN THEME -----------------------------


----- HELL THEME ------------------------------

