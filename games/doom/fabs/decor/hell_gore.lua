--
-- Hellish gore (outdoor stuff)
--

-- a cross
PREFABS.Decor_hellgore1 =
{
  file   = "decor/hell_gore.wad",
  map    = "MAP01",

  prob   = 5000,
  theme  = "hell",
  env    = "outdoor",

  where  = "point",
  size   = 100,
  height = 192,

  bound_z1 = 0,
  bound_z2 = 192,

  face_open = true,
}


-- Inverted cross
PREFABS.Decor_hellgore1_inverted =
{
  file   = "decor/hellgore.wad",
  map    = "MAP01",

  prob   = 5000,
  theme  = "hell",
  env    = "outdoor",

  where  = "point",
  size   = 100,
  height = 192,

  bound_z1 = 0,
  bound_z2 = 192,

  face_open = true,
}

-- Hack to place normal decorations
PREFABS.Decor_hellgore6 =
{
  file   = "decor/hellgore.wad",
  map    = "MAP06",

  prob   = 5000,
  theme  = "hell",

  where  = "point",
  size   = 64,
  height = 64, --guess

  bound_z1 = 0,

  solid_ents = true,

  thing_34 =
  {
    impaled_human = 50,
    impaled_twitch = 30,
    skull_kebab = 20,
    skull_pole = 15,
    skull_cairn = 10,
  }
}
