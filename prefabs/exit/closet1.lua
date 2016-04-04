--
-- Exit closet
--

PREFABS.Exit_Closet1 =
{
  file   = "exit/closet1.wad"
  where  = "seeds"

  seed_w = 1
  seed_h = 1

  x_fit = "frame"
  y_fit = "top"

  theme = "!tech"
}


PREFABS.Exit_Closet1_tech =
{
  template = "Exit_Closet1"

  tex_STEP3 = "STEP1"

  tex_GRAYVINE = "COMPBLUE"
  tex_SW1VINE  = "SW1BLUE"

  theme = "tech"
}

