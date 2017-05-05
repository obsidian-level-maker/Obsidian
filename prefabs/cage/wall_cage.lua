--
-- Cage which is flush with the wall
--

PREFABS.Cage_wall =
{
  file   = "cage/wall_cage.wad"
  map    = "MAP01"

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

  -- disable the oscillation (pending a smarter system...)
  sector_8 = 0
}


PREFABS.Cage_wall_hell =
{
  template = "Cage_wall"

  theme = "hell"

   tex_SHAWN2 = "REDWALL"
  flat_FLAT23 = "RROCK03"
}

