--
-- Big junction : corner for curvey hallway
--

DOOM.SKINS.Junc_curve_C =
{
  file   = "junction/curve_c.wad"
  shape  = "C"
  group  = "hall_curve"

  prob   = 100

  seed_w = 3
  seed_h = 3

  south = "#.#"
  west  = "#.#"
}


DOOM.SKINS.Junc_curve_stair1 =
{
  file   = "junction/curve_stair1.wad"
  shape  = "C"
  group  = "hall_curve"

  prob   = 200

  seed_w = 3
  seed_h = 3

  south = "#.#"
  west  = "#w#"

  edges =
  {
    w = { f_h=80 }
  }

  props_45 = { light=176, factor=0.5  }
}


DOOM.SKINS.Junc_curve_stair2 =
{
  file   = "junction/curve_stair2.wad"
  shape  = "C"
  group  = "hall_curve"

  prob   = 200

  seed_w = 3
  seed_h = 3

  south = "#.#"
  west  = "#w#"

  edges =
  {
    w = { f_h=-80 }
  }

  props_45 = { light=176, factor=0.5 }
}


--
-- Big junction : weird snakey T-shape
--

DOOM.SKINS.Junc_curve_snake_T =
{
  file   = "junction/curve_snake.wad"
  shape  = "T"
  group  = "hall_curve"

  prob   = 50

  seed_w = 3
  seed_h = 3

  south = "#.#"
  east  = "#e#"
  west  = "#w#"

  edges =
  {
    e = { f_h=-32 }
    w = { f_h= 48 }
  }
}

