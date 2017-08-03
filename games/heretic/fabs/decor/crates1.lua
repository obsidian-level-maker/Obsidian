--
-- Various crates
--


-- a small crate, 64x64 in size

PREFABS.Crate_small_brown =
{
  file   = "decor/crates1.wad"
  map    = "MAP01"

  theme  = "!hell"
  prob   = 20

  where  = "point"
  size   = 64
}


PREFABS.Crate_small_gray =
{
  template = "Crate_small_brown"

   tex_CRATE1  = "CRATE2"
  flat_CRATOP2 = "CRATOP1"
}


-- ones for Urban and Hell themes

PREFABS.Crate_small_woodmet =
{
  file   = "decor/crates1.wad"
  map    = "MAP11"

  theme  = "!tech"
  prob   = 20

  where  = "point"
  size   = 64
}

PREFABS.Crate_small_wood3 =
{
  template = "Crate_small_woodmet"

  map    = "MAP10"
}


-- a tall narrow crate

PREFABS.Crate_tall_brown =
{
  file   = "decor/crates1.wad"
  map    = "MAP02"

  prob   = 8
  theme  = "!hell"

  where  = "point"
  size   = 64
  height = 160
}


-- a medium-size crate (96x96)

PREFABS.Crate_medium_gray =
{
  file   = "decor/crates1.wad"
  map    = "MAP03"

  prob   = 8
  theme  = "!hell"
  env    = "!cave"

  where  = "point"
  size   = 96
}


-- a group of three and a half crates

PREFABS.Crate_group_medium =
{
  file   = "decor/crates1.wad"
  map    = "MAP04"

  theme  = "!hell"
  env    = "!cave"
  prob   = 300

  where  = "point"
  size   = 128
  height = 160
}


-- a large, tall, wooden crate

PREFABS.Crate_large_wooden =
{
  file   = "decor/crates1.wad"
  map    = "MAP12"

  theme  = "!tech"
  prob   = 400

  where  = "point"
  size   = 128
  height = 160
}

