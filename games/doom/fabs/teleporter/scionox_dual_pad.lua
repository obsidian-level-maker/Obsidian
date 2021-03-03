-- Point version of dual teleport

PREFABS.Teleporter_scionox_dual_pad =
{
  file   = "teleporter/scionox_dual_pad.wad",
  map    = "MAP01",

  theme  = "tech",
  prob   = 75,

  where  = "point",
  size   = 104,
  height = 128,

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  tex_COMPSTA1 = { COMPSTA1=50, COMPSTA2=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT20=50, FLAT19=50, FLAT5=50 },

  face_open = true,
}

PREFABS.Teleporter_scionox_dual_pad_2 =
{
  template = "Teleporter_scionox_dual_pad",
  theme  = "urban",

  tex_COMPSTA1 = { SPACEW3=50, COMPWERD=50 },
  flat_FLOOR4_6 = { FLAT3=50, FLAT5_1=50, FLAT5_5=50, FLOOR5_4=50 },
  flat_FLAT22 = "GATE4",
  flat_FLAT23 = "CEIL1_2",
  tex_SILVER1 = "SUPPORT3",
}

PREFABS.Teleporter_scionox_dual_pad_3 =
{
  template = "Teleporter_scionox_dual_pad",
  theme  = "hell",
  map    = "MAP03",

  tex_SW2SATYR = { SW2SATYR=50, SW2GARG=50, SW2LION=50 },
  flat_RROCK15 = { RROCK15=50, FLOOR7_2=50, FLAT5_1=50, RROCK10=50 },
}

-- Point version of dual teleport with pillar element

PREFABS.Teleporter_scionox_dual_pad_4 =
{
  file   = "teleporter/scionox_dual_pad.wad",
  map    = "MAP02",

  theme  = "tech",
  prob   = 60,

  where  = "point",
  size   = 104,
  height = 128,

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  tex_COMPSTA1 = { COMPSTA1=50, COMPSTA2=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT20=50, FLAT19=50, FLAT5=50 },

  face_open = true,
}

PREFABS.Teleporter_scionox_dual_pad_5 =
{
  template = "Teleporter_scionox_dual_pad_4",
  theme  = "urban",

  tex_COMPSTA1 = { SPACEW3=50, COMPWERD=50 },
  flat_FLOOR4_6 = { FLAT3=50, FLAT5_1=50, FLAT5_5=50, FLOOR5_4=50 },
  flat_FLAT22 = "GATE4",
  flat_FLAT23 = "CEIL1_2",
  tex_SILVER1 = "SUPPORT3",
}
PREFABS.Teleporter_scionox_dual_pad_6 =
{
  template = "Teleporter_scionox_dual_pad_4",
  theme  = "hell",
  map    = "MAP04",

  tex_SW2SATYR = { SW2SATYR=50, SW2GARG=50, SW2LION=50 },
  flat_RROCK15 = { RROCK15=50, FLOOR7_2=50, FLAT5_1=50, RROCK10=50 },
}
