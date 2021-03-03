-- small compact version of pillar teleport idea

PREFABS.Teleporter_scionox_small_pillar_teleport =
{
  file   = "teleporter/scionox_small_pillar_teleport.wad",
  map    = "MAP01",
  prob   = 50,

  theme  = "tech",
  where  = "seeds",

  seed_w = 1,
  seed_h = 1,

  deep  =  16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",
}

PREFABS.Teleporter_scionox_small_pillar_teleport_2 =
{
  template = "Teleporter_scionox_small_pillar_teleport",
  theme  = "urban",

  tex_SW1BRIK = "SW1CMT",
  tex_SILVER2 = "PANRED",
  tex_GATE4 = "GATE3",
  thing_2028 = "mercury_lamp",
}

PREFABS.Teleporter_scionox_small_pillar_teleport_3 =
{
  template = "Teleporter_scionox_small_pillar_teleport",
  theme  = "hell",

  tex_SW1BRIK = "SW1WOOD",
  tex_SILVER2 = "MARBFAC4",
  tex_GATE4 = "GATE2",
  tex_LITE5 = "METAL",
  flat_FLAT19 = "CEIL5_2",
  thing_2028 = "candelabra",
}
