--
-- Simple ceiling light
--

PREFABS.Light_basic =
{
  file   = "decor/ceil_light.wad"
  map    = "MAP01"

  kind   = "light"
  where  = "point"

  env    = "building"
  height = 96

  bound_z1 = -32
  bound_z2 = 0

  prob   = 1
}


----------- URBAN THEME ------------------------


PREFABS.Light_urban1 =
{
  template = "Light_basic"
  -- use outie style

  theme  = "urban"
  prob   = 50

  flat_TLITE6_4 = "CEIL1_3"
   tex_METAL    = "WOOD10"
}


PREFABS.Light_urban2 =
{
  template = "Light_basic"
  map    = "MAP02"

  theme  = "urban"
  prob   = 25
}


PREFABS.Light_urban3 =
{
  template = "Light_basic"
  map      = "MAP02"

  theme  = "urban"
  prob   = 50

  flat_TLITE6_1 = "FLAT2"
}


----------- TECH THEME ------------------------


PREFABS.Light_tech1 =
{
  template = "Light_basic"
  map      = "MAP02"

  theme  = "tech"
  prob   = 100

  flat_TLITE6_1 = "TLITE6_5"
}


PREFABS.Light_tech2 =
{
  template = "Light_basic"
  map      = "MAP02"

  theme  = "tech"
  prob   = 50

  flat_TLITE6_1 = "TLITE6_6"
}


PREFABS.Light_tech_red =
{
  template = "Light_basic"
  map      = "MAP02"

  theme  = "tech"
  prob   = 50

  flat_TLITE6_1 = "FLOOR1_7"
}


PREFABS.Light_tech_green =
{
  template = "Light_basic"
  map      = "MAP02"

  theme  = "tech"
  prob   = 50

  flat_TLITE6_1 = "GRNLITE1"
}


PREFABS.Light_tech_blue =
{
  template = "Light_basic"
  -- use outie style

  theme  = "tech"
  prob   = 50

  flat_TLITE6_4 = "FLAT22"
   tex_METAL    = "SHAWN2"
}

