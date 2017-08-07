--
-- Various crates
--


-- a small crate, 64x64 in size

UNFINISHED.Crate_small_brown =
{
  file   = "decor/crates1.wad"
  map    = "MAP01"

  prob   = 20

  where  = "point"
  size   = 64
}


UNFINISHED.Crate_small_gray =
{
  template = "Crate_small_brown"

   tex_CRATE1  = "CRATE2"
  flat_CRATOP2 = "CRATOP1"
}



-- a tall narrow crate

UNFINISHED.Crate_tall_brown =
{
  file   = "decor/crates1.wad"
  map    = "MAP02"

  prob   = 8

  where  = "point"
  size   = 64
  height = 160
}


-- a medium-size crate (96x96)

UNFINISHED.Crate_medium_gray =
{
  file   = "decor/crates1.wad"
  map    = "MAP03"

  prob   = 8
  env    = "!cave"

  where  = "point"
  size   = 96
}


-- a large, tall, wooden crate

UNFINISHED.Crate_large_wooden =
{
  file   = "decor/crates1.wad"
  map    = "MAP12"

  prob   = 400

  where  = "point"
  size   = 128
  height = 160
}

