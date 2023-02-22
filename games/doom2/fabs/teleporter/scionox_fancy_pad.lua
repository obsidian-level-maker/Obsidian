-- Small but somewhat fancy teleport pad

PREFABS.Teleporter_scionox_fancy_pad =
{
  file   = "teleporter/scionox_fancy_pad.wad",
  map    = "MAP01",

  theme  = "!hell",
  prob   = 50,

  where  = "point",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  sector_8  = { [8]=60, [2]=10, [3]=10, [17]=10, [21]=10 },

  face_open = true,
}

PREFABS.Teleporter_scionox_fancy_pad_2 =
{
  template   = "Teleporter_scionox_fancy_pad",
  map    = "MAP02",
  theme  = "!tech",
}
