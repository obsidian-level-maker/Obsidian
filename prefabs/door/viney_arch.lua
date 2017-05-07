--
-- Cavey archway with vines
--

PREFABS.Arch_viney1 =
{
  file   = "door/viney_arch.wad"
  map    = "MAP02"

  rank = 1
  prob = 400

  env      = "cave"
  neighbor = "any"

  kind   = "arch"
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


PREFABS.Door_viney1 =
{
  template = "Arch_viney1"

  rank  = 2
  kind  = "door"
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

  force_flip = false
}


PREFABS.Joiner_viney1_B =
{
  template = "Joiner_viney1"
  map      = "MAP05"

  env      = "cave"
  neighbor = "any"

  force_flip = true
}


PREFABS.Joiner_viney1_CC =
{
  template = "Joiner_viney1"
  map      = "MAP06"

  env      = "cave"
  neighbor = "cave"

  rank   = 4
}

