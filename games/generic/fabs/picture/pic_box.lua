--
-- Pictures (via the closet system)
--

TEMPLATES.Pic_box =
{
  file   = "picture/pic_box.wad",
  map    = "MAP02",

  prob  = 100,
  skip_prob = 40,

  env   = "building",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,
  tex__NPIC = { _NPIC=50, _NPIC2=50, _NPIC3=50 },

  height = 128,
  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",
}

----- 128 HIGH PICTURES ------------------------------

PREFABS.Pic_box_saint1 =
{
  template = "Pic_box",
  map      = "MAP04",

  seed_w   = 1,
  height   = 160,

  tex__NPIC = { _NPIC=50, _NPIC2=50, _NPIC3=50 }
}


PREFABS.Pic_box_glass =
{
  template = "Pic_box",
  map      = "MAP05",

  seed_w   = 2,
  height   = 160,

  prob     = 200,

  tex__MPIC = { _MPIC=50, _MPIC2=50, _MPIC3=50, _MPIC4=50, _MPIC5=50, _MPIC6=50, _MPIC7=50 }
}

----- VERY WIDE PICTURES ------------------------------

PREFABS.Pic_box_wide =
{
  template = "Pic_box",
  map      = "MAP06",

  seed_w   = 3,
  height   = 160,

  rank      = 3,
  skip_prob = 10,

  tex__WPIC = { _WPIC=50, _WPIC2=50, _WPIC3=50 }
}

