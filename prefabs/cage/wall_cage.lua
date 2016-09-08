--
-- Wall Cage
--

PREFABS.Cage_Wall =
{
  file   = "cage/wall_cage.wad"

  prob  = 100
  theme = "!hell"

  where  = "seeds"
  shape  = "U"

  seed_w = 1
  seed_h = 1

  deep   =  16
  over   = -16

  x_fit = "stretch"
  y_fit = "top"

  bound_z1 = 0
}


PREFABS.Cage_Wall_hell =
{
  template = "Cage_Wall"

  theme = "hell"

   tex_SHAWN2 = "REDWALL"
  flat_FLAT23 = "RROCK03"
}

