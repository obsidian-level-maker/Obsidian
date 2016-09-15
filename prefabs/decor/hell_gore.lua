--
-- Hellish gore (outdoor stuff)
--

PREFABS.Decor_hellgore1 =
{
  file   = "decor/hell_gore.wad"
  map    = "MAP01"

  prob   = 10*99
  theme  = "hell"
  env    = "outdoor"

  where  = "point"
  size   = 100
  height = 128  -- FIXME 192

  bound_z1 = 0
  bound_z2 = 192
}


PREFABS.Decor_hellgore2 =
{
  file   = "decor/hell_gore.wad"
  map    = "MAP02"

  prob   = 40
  theme  = "hell"
  env    = "outdoor"

  where  = "point"
  size   = 100
  height = 96

  bound_z1 = 0
}


PREFABS.Decor_hellgore3 =
{
  file   = "decor/hell_gore.wad"
  map    = "MAP03"

  prob   = 40
  theme  = "hell"
  env    = "outdoor"

  where  = "point"
  size   = 100
  height = 96

  bound_z1 = 0

  thing_34 =
  {
    skull_pole  = 20
    skull_kebab = 40
    skull_cairn = 10
    impaled_twitch = 30
  }
}


PREFABS.Decor_hellgore4 =
{
  file   = "decor/hell_gore.wad"
  map    = "MAP04"

  prob   = 80
  theme  = "hell"
  env    = "outdoor"

  where  = "point"
  size   = 100
  height = { 152, 256 }

  bound_z1 = 0
  bound_z2 = 152

  z_fit  = "bottom"

  thing_34 =
  {
    hang_twitching = 30
    hang_arm_pair  = 20
    hang_leg_gone  = 10
  }
}


PREFABS.Decor_hellgore5 =
{
  file   = "decor/hell_gore.wad"
  map    = "MAP05"

  prob   = 80
  theme  = "hell"
  env    = "outdoor"

  where  = "point"
  size   = 100
  height = { 128, 256 }

  bound_z1 = 0
  bound_z2 = 128

  z_fit  = "top"

  thing_34 =
  {
    gutted_victim2 = 40
    gutted_victim1 = 20
    gutted_torso3  = 10
  }
}

