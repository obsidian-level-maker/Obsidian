--
-- Big junction : corner for curvey hallway
--

DOOM.SKINS.Junc_curve_C =
{
  file   = "junction/curve_c.wad"
  shape  = "C"
  group  = "hall_curve"

  seed_w = 3
  seed_h = 3
  prob   = 100
}


DOOM.SKINS.Junc_curve_stair1 =
{
  file   = "junction/curve_stair1.wad"
  shape  = "C"
  group  = "hall_curve"

  seed_w = 3
  seed_h = 3
  prob   = 200

  west = { f_h=80 }

  props_45 = { light=176, _factor=0.5  }
}


DOOM.SKINS.Junc_curve_stair2 =
{
  file   = "junction/curve_stair2.wad"
  shape  = "C"
  group  = "hall_curve"

  seed_w = 3
  seed_h = 3
  prob   = 200

  west = { f_h=-80 }

  props_45 = { light=176, _factor=0.5 }
}


--
-- Big junction : weird snakey T-shape
--

DOOM.SKINS.Junc_curve_snake_T =
{
  file   = "junction/curve_snake.wad"
  shape  = "T"
  group  = "hall_curve"
  seed_w = 3
  seed_h = 3
  prob   = 40

  east = { f_h=-32 }
  west = { f_h= 48 }
}

