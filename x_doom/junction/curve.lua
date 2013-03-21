--
-- Big junction : corner for curvey hallway
--

DOOM.SKINS.Junc_curve_C =
{
  file   = "junction/curve_c.wad"
  shape  = "C"
  group  = "hall_curve"
  prob   = 100
}

DOOM.SKINS.Junc_curve_stair1 =
{
  file   = "junction/curve_stair1.wad"
  shape  = "C"
  group  = "hall_curve"
  prob   = 200

  west = { h=80 }
}

DOOM.SKINS.Junc_curve_stair2 =
{
  file   = "junction/curve_stair2.wad"
  shape  = "C"
  group  = "hall_curve"
  prob   = 9999

  west = { h=-80 }
}


--
-- Big junction : weird snakey T-shape
--

DOOM.SKINS.Junc_curve_snake_T =
{
  file   = "junction/curve_snake.wad"
  shape  = "T"
  group  = "hall_curve"
  prob   = 999

  east = { h=-32 }
  west = { h= 48 }
}

