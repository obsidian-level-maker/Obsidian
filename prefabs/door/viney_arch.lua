--
-- Cavey archway with vines
--

UNFINISHED.Arch_viney1 =
{
  file   = "door/viney_arch.wad"
  map    = "MAP02"

  rank = 2
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


UNFINISHED.Arch_viney1_B =
{
  template = "Arch_viney1"

  env      = "any"
  neighbor = "cave"
}


---------- JOINER VERSIONS -----------------------


UNFINISHED.Joiner_viney1_CC =
{
  file   = "door/viney_arch.wad"
  map    = "MAP04"

  rank   = 2
  prob   = 50

  env      = "cave"
  neighbor = "cave"

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit  = "frame"
  y_fit  = "stretch"
}


UNFINISHED.Joiner_viney1_CN =
{
  template = "Joiner_viney1"
  map      = "MAP05"

  env      = "cave"
  neighbor = "!cave"
}


UNFINISHED.Joiner_viney1_NC =
{
  template = "Joiner_viney1"
  map      = "MAP05"

  env      = "!cave"
  neighbor = "cave"

  must_flip = true
}

