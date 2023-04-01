--
-- Pictures (via the closet system)
--

TEMPLATES.Pic_box_template =
{
  file   = "picture/pic_box.wad",
  map    = "MAP02",

  prob  = 100,
  skip_prob = 40,

  

  env   = "building",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  height = 128,
  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",
}


----- BANNERS ------------------------------

PREFABS.Pic_box_banner =
{
  template = "Pic_box_template",

  tex_CELTIC = { BANNER1=50, BANNER2=50, BANNER5=50, BANNER6=50 }
}


----- 128 HIGH PICTURES ------------------------------

PREFABS.Pic_box_saint1 =
{
  template = "Pic_box_template",
  map      = "MAP04",

  seed_w   = 1,
  height   = 160,

  tex_CELTIC = "SAINT1",
}


PREFABS.Pic_box_glass =
{
  template = "Pic_box_template",
  map      = "MAP05",

  seed_w   = 2,
  height   = 160,

  prob     = 200,

  tex_CELTIC = { STNGLS1=50, STNGLS2=50 }
}


PREFABS.Pic_box_demon =
{
  template = "Pic_box_template",
  map      = "MAP05",

  seed_w   = 2,
  height   = 160,

  tex_CELTIC = { GRSKULL3=50, DMNMSK=30, SKULLSB2=10 }
}


----- VERY WIDE PICTURES ------------------------------

PREFABS.Pic_box_wide =
{
  template = "Pic_box_template",
  map      = "MAP06",

  seed_w   = 3,
  height   = 160,


  skip_prob = 10,

  tex_CELTIC = { HORSES1=50, CHAINMAN=15, CELTIC=5 }
}

