-- teleport room with switch activating the teleporter

PREFABS.Teleporter_scionox_pillar_teleport =
{
  file   = "teleporter/scionox_pillar_teleport.wad",
  map    = "MAP01",
  prob   = 40,

  theme  = "!hell",
  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,

  x_fit = "frame",
  y_fit = "top",

  tag_2 = "?out_tag",
  tag_3 = "?in_tag",

  sector_8  = { [8]=50, [1]=10, [2]=10, [3]=10, [17]=10 },
  tex_SPCDOOR2 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
}

PREFABS.Teleporter_scionox_pillar_teleport_2 =
{
  template = "Teleporter_scionox_pillar_teleport",
  theme  = "hell",
  map    = "MAP02",
  tex_WOODMET2 = { WOODMET1=50, WOODMET2=50, WOODMET3=50, WOODMET4=50 },
}
