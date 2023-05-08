--
-- Teleporter closet
--

PREFABS.Teleporter_closet =
{
  file   = "teleporter/closet2.wad",

  game = "heretic",

  prob   = 50,

  kind = "teleporter",
  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",
}

PREFABS.Teleporter_closet_no_sparkles =
{
  template   = "Teleporter_closet",

  game = "!heretic",

  thing_74 = 0,
}

