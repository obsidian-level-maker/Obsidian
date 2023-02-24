--
-- Teleporter closet
--

PREFABS.Teleporter_Closet2 =
{
  file   = "teleporter/closet2.wad",

  prob   = 50,
  map    = "MAP01",
  theme  = "!tech",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  flat_FLAT5_3 = "REDWALL",

  sector_8 = { [8]=50, [1]=15, [2]=10, [3]=10, [0]=5 },
}


PREFABS.Teleporter_Closet_tech =
{
  file   = "teleporter/closet2.wad",

  prob   = 50,
  theme  = "tech",
  map    = "MAP02",

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

PREFABS.Teleporter_Closet_urban =
{
  file   = "teleporter/closet2.wad",

  prob   = 50,
  map    = "MAP03",
  theme  = "urban",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  sector_8 = { [8]=50, [1]=15, [2]=10, [3]=10, [0]=3 },

}

PREFABS.Teleporter_Closet_hell =
{
  file   = "teleporter/closet2.wad",

  prob   = 50,
  map    = "MAP04",
  theme  = "hell",

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

PREFABS.Teleporter_Closet_general =
{
  file   = "teleporter/closet2.wad",

  prob   = 50,
  map    = "MAP05",
  theme  = "!tech",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  sector_13 = { [13]=50, [12]=25, [1]=15, [2]=10, [3]=10, [0]=5 },
  tex_SW1GARG = { SW1GARG=50, SW1LION=50, SW1SATYR=50 },

}
