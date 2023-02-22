--
-- Another outdoor lamp
--

PREFABS.Decor_mogwaltz_blob_lamp_candalebra =
{
  file   = "decor/mogwaltz_blob_lamp.wad",
  map    = "MAP01",

  prob   = 1000, --originally 5000 (against vanilla), 700 (mog's setting)

  theme  = "!tech",
  env    = "outdoor",
  game   = "doom2",

  where  = "point",
  size   = 80,
}

PREFABS.Decor_mogwaltz_blob_lamp_quad_candles =
{
  template = "Decor_mogwaltz_blob_lamp_candalebra",
  map    = "MAP02",
}

PREFABS.Decor_mogwaltz_blob_lamp_tri_candles =
{
  template = "Decor_mogwaltz_blob_lamp_candalebra",
  map    = "MAP03",
}

PREFABS.Decor_mogwaltz_blob_lamp_tri_candles_centerpost =
{
  template = "Decor_mogwaltz_blob_lamp_candalebra",
  map    = "MAP04",
}

PREFABS.Decor_mogwaltz_blob_lamp_triforce =
{
  template = "Decor_mogwaltz_blob_lamp_candalebra",
  map    = "MAP05",
}

PREFABS.Decor_mogwaltz_blob_lamp_layercake =
{
  template = "Decor_mogwaltz_blob_lamp_candalebra",
  map    = "MAP06",
}
