--
-- Cavey archway with vines
--

PREFABS.Arch_viney1 =
{
  file   = "door/viney_arch.wad"
  map    = "MAP02"

  rank = 3
  prob = 50

  env      = "cave"
  neighbor = "any"

  where  = "edge"
  seed_w = 2

  deep   = 16
  over   = 16

  x_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 132
}


PREFABS.Arch_viney1_B =
{
  template = "Arch_viney1"

  env      = "any"
  neighbor = "cave"
}


---------- JOINER VERSIONS -----------------------


PREFABS.Joiner_viney1 =
{
  file   = "door/viney_arch.wad"
  map    = "MAP05"

  rank   = 3
  prob   = 50

  env      = "!cave"
  neighbor = "cave"

  kind   = "joiner"
  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit  = "frame"
  y_fit  = { 32,144 }
}


PREFABS.Joiner_viney1_B =
{
  template = "Joiner_viney1"
  map      = "MAP05"

  env      = "cave"
  neighbor = "any"

  must_flip = true
}


-- TODO : cave-to-cave version
UNFINISHED.Joiner_viney1_CC =
{
  template = "Joiner_viney1"
  map      = "MAP04"

  env      = "cave"
  neighbor = "cave"
}

