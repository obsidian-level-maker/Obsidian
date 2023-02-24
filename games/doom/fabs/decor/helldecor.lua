--
-- Hell decoration & other things
--

PREFABS.Hell_crucified_bodies1 =
{
  file   = "decor/helldecor.wad",
  map    = "MAP01",

  theme  = "hell",
  prob   = 5000,

  where  = "point",
  size   = 128,
  height = 160,
}


--The bloody ones
PREFABS.Hell_crucified_bodies2 =
{
  template   = "Hell_crucified_bodies1",
  map    = "MAP01",

 tex_SP_DUDE1 = "SP_DUDE7",
 tex_SP_DUDE2 = "SP_DUDE7", --Totally forgot SP_DUDE8 was used for vines
 flat_FLOOR7_2 = "FLOOR7_1",

}

-- The 64x128 one

PREFABS.Hell_small_bodies1 =
{
  file   = "decor/helldecor.wad",
  map    = "MAP02",

  prob   = 5000,
  theme  = "hell",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,
}

-- Torch decoration with pillars

PREFABS.Hell_torch_pillars =
{
  file   = "decor/helldecor.wad",
  map    = "MAP03",

  prob   = 5000,
  env    = "outdoor",
  theme  = "hell",

  where  = "point",
  size   = 144,
  height = 128,

  bound_z1 = 0,

  tex_MARBLE2 = { MARBLE2=50, MARBLE3=50, MARBGRAY=50 },

  thing_34 =
  {
    red_torch_sm = 50,
    blue_torch_sm = 50,
    green_torch_sm = 50,
  }

}


-- Just some hell themed pillars

PREFABS.Hell_pillar =
{
  file   = "decor/crates1.wad",
  map    = "MAP02",

  prob   = 5000,
  theme  = "hell",
  env    = "!cave",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,

  tex_CRATELIT = { GSTGARG=50, GSTSATYR=50, GSTLION=50 },
  flat_CRATOP1 = "FLOOR7_2",

}

-- Metal one
PREFABS.Hell_pillar2 =
{
  template   = "Hell_pillar",

  tex_CRATELIT = { SW1GARG=50, SW1SATYR=50, SW1LION=50 },
  flat_CRATOP1 = "CEIL5_2",

}

--Large computer decor
PREFABS.Tech_computer_box =
{
  template   = "Hell_crucified_bodies1",
  map    = "MAP04",
  prob   = 5000,
  theme  = "tech",
  env    = "building",

 tex_SP_DUDE1 = "COMPTALL",
 flat_FLOOR7_2 = "CEIL5_1",

}
