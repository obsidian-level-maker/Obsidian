--
-- Exit closet
--

PREFABS.Exit_closet1 =
{
  file   = "exit/closet1.wad"
  where  = "seeds"

  seed_w = 1
  seed_h = 1

  x_fit = "frame"
  y_fit = "top"

  theme = "!tech"

  prob  = 100
}


PREFABS.Exit_closet1_tech =
{
  template = "Exit_closet1"

  tex_STEP3 = "STEP1"

  tex_GRAYVINE = "COMPBLUE"
  tex_SW1VINE  = "SW1BLUE"

  theme = "tech"
}


------- Trappy variation -------------------------

PREFABS.Exit_closet1_trap =
{
  template = "Exit_closet1"
  map      = "MAP02"

  seed_w = 1
  seed_h = 2

  prob   = 20
}


PREFABS.Exit_closet1_trap_tech =
{
  template = "Exit_closet1"
  map      = "MAP02"

  seed_w = 1
  seed_h = 2

  tex_STEP3 = "STEP1"

  tex_GRAYVINE = "COMPBLUE"
  tex_SW1VINE  = "SW1BLUE"

  theme  = "tech"

  prob   = 20
}

