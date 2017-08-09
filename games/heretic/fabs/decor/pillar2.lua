--
-- Square pillars
--

PREFABS.Pillar_square_A =
{
  file   = "decor/pillar2.wad"
  map    = "MAP01"

  rank   = 2
  prob   = 50
  skip_prob = 80

  where  = "point"
  env    = "building"

  size   = 64
  height = 80

  bound_z1 = 0
  bound_z2 = 80

  z_fit  = "stretch"
}


PREFABS.Pillar_square_B =
{
  template = "Pillar_square_A"
  map      = "MAP02"
}

