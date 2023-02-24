-- simple teleport with midtex decor, inspired by one tele in MAP29,

PREFABS.Teleporter_scionox_middeco_teleport =
{
  file   = "teleporter/scionox_middeco_teleport.wad",
  map    = "MAP01",
  prob   = 50,

  theme  = "hell",
  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  sector_8  = { [8]=50, [1]=10, [2]=10, [3]=10, [17]=10 },
}

PREFABS.Teleporter_scionox_middeco_teleport_2 =
{
  template = "Teleporter_scionox_middeco_teleport",
  theme  = "tech",

  tex_MIDGRATE = "MIDSPACE",
  tex_SP_FACE2 = "COMPBLUE",
  tex_SUPPORT3 = "LITEBLU1",
  tex_STEP6 = "STEP3",
  tex_METAL = "SILVER1",
  flat_GATE2 = "FLAT22",
  flat_RROCK09 = "FLOOR4_6",
  flat_FLOOR1_6 = "CEIL4_2",
}

PREFABS.Teleporter_scionox_middeco_teleport_3 =
{
  template = "Teleporter_scionox_middeco_teleport",
  theme  = "tech",

  tex_MIDGRATE = "MIDSPACE",
  tex_SP_FACE2 = "COMPWERD",
  tex_STEP6 = "STEP3",
  flat_GATE2 = "GATE4",
  flat_RROCK09 = "FLOOR0_3",
  flat_FLOOR1_6 = "CEIL5_1",
}

PREFABS.Teleporter_scionox_middeco_teleport_4 =
{
  template = "Teleporter_scionox_middeco_teleport",
  theme  = "urban",

  tex_MIDGRATE = "MIDBRONZ",
  tex_SP_FACE2 = "BRONZE2",
  flat_GATE2 = "GATE4",
  flat_RROCK09 = "FLAT5_5",
  flat_FLOOR1_6 = "FLOOR7_1",
}

PREFABS.Teleporter_scionox_middeco_teleport_5 =
{
  template = "Teleporter_scionox_middeco_teleport",
  theme  = "urban",

  tex_MIDGRATE = "MIDBRONZ",
  tex_SP_FACE2 = "WOODGARG",
  flat_GATE2 = "GATE3",
  flat_RROCK09 = "FLAT5_1",
  flat_FLOOR1_6 = "FLAT5_2",
}

PREFABS.Teleporter_scionox_middeco_teleport_6 =
{
  template = "Teleporter_scionox_middeco_teleport",
  theme  = "hell",

  tex_SP_FACE2 = "SP_DUDE4",
  tex_STEP6 = "MARBFAC4",
  flat_GATE2 = "GATE1",
  flat_RROCK09 = "FLOOR7_2",
  flat_FLOOR1_6 = "FLOOR7_2",
}
