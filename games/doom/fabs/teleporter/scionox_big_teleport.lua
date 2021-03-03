-- 2x2 GATE teleport

PREFABS.Teleporter_scionox_big_teleport =
{
  file   = "teleporter/scionox_big_teleport.wad",
  map    = "MAP01",
  prob   = 50,

  theme  = "tech",
  where  = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep  =  16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  sector_8  = { [8]=50, [1]=10, [2]=10, [3]=10, [17]=10 },
}
PREFABS.Teleporter_scionox_big_teleport_2 =
{
  template = "Teleporter_scionox_big_teleport",
  map    = "MAP02",
  theme  = "!hell",

  tex_LITE5 = { LITE5=50, LITEBLU4=50 },
}
PREFABS.Teleporter_scionox_big_teleport_3 =
{
  template = "Teleporter_scionox_big_teleport",
  map    = "MAP04",
  theme  = "!tech",
}
-- uses 3D floor so zdoom
PREFABS.Teleporter_scionox_big_teleport_4 =
{
  template = "Teleporter_scionox_big_teleport",
  map    = "MAP03",
  engine = "zdoom",
  theme  = "hell",
}
