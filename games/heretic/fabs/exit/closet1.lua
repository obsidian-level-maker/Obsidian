--
-- Exit closet
--

PREFABS.Exit_closet1 =
{
  file   = "exit/closet1.wad"
  map    = "MAP01"

  prob   = 100

  where  = "seeds"
  seed_w = 1
  seed_h = 1

  deep   =  16
  over   = -16

  x_fit  = "frame"
  y_fit  = "top"
}


----------------------------------------------------------------------

PREFABS.Exit_closet1_secret =
{
  template = "Exit_closet1"

  kind = "secret_exit"

  -- replace normal exit special with "exit to secret" special
  line_11 = 51

  -- retexture to a red color
  tex_METL2 = "REDWALL"
  flat_FLAT502 = "FLOOR09"
  flat_FLOOR30 = "FLOOR09"
}

