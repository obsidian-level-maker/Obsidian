--
-- Teleporter pad
--

PREFABS.Teleporter2 =
{
  file   = "teleporter/pad2.wad",
  map    = "MAP01",

  kind = "teleporter",
  game = "heretic",

  prob   = 50,

  where  = "point",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",
}

PREFABS.Teleporter2_no_sparkles =
{
  template = "Teleporter2",

  game = "!heretic",

  thing_74 = 0,
}

