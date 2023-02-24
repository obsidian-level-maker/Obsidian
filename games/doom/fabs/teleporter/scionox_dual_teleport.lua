-- teleport with different entrance and exit

PREFABS.Teleporter_scionox_dual_teleport =
{
  file   = "teleporter/scionox_dual_teleport.wad",
  map    = "MAP01",
  prob   = 40,

  theme  = "tech",
  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_3 = "?out_tag",
  tag_4 = "?in_tag",

  sector_8  = { [8]=50, [1]=10, [2]=10, [3]=10, [17]=10 },
}

PREFABS.Teleporter_scionox_dual_teleport_2 =
{
  template = "Teleporter_scionox_dual_teleport",
  theme  = "urban",

  tex_SILVER2 = "PANEL5",
  tex_COMPBLUE = "PANEL4",
  flat_CEIL4_2 = "FLAT5_5",

}

PREFABS.Teleporter_scionox_dual_teleport_3 =
{
  template = "Teleporter_scionox_dual_teleport",
  theme  = "hell",

  map    = "MAP02",
}
