--
-- Exit closet (no door, flickering light)
--

PREFABS.Exit_closet2 =
{
  file   = "exit/closet2.wad"

  prob   = 150

  where  = "seeds"
  seed_w = 2
  seed_h = 1

  deep   =  16
  over   = -16

  x_fit  = "frame"
  y_fit  = "top"
}


------- Exit-to-Secret ---------------------------


PREFABS.Exit_closet2_secret =
{
  template = "Exit_closet2"

  kind = "secret_exit"

  -- replace normal exit special with "exit to secret" special
  line_11 = 51

  tex_SW1PIPE = "SW1SKIN"
  offset_32   = 0
}

