--
-- Another outdoor lamp
--

PREFABS.Decor_blob_lamp =
{
  file   = "decor/blob_lamp.wad",
  map    = "MAP01",

  prob   = 5000,
  skip_prob = 75,

  theme  = "tech",
  env    = "outdoor",
  game   = "doom2",

  where  = "point",
  size   = 80,
}

PREFABS.Decor_blob_lamp_gothic = -- this version is balanced against Mogwaltz's new blob lamp variations
{
  template = "Decor_blob_lamp",
  map    = "MAP01",

  theme  = "!tech",
}
