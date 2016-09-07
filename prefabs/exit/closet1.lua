--
-- Exit closet
--

PREFABS.Exit_closet1 =
{
  file   = "exit/closet1.wad"

  prob   = 100
  theme  = "!tech"

  where  = "seeds"
  seed_w = 1
  seed_h = 1

  deep   =  16
  over   = -16

  x_fit  = "frame"
  y_fit  = "top"
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

  prob   = 20

  seed_w = 1
  seed_h = 2
}


PREFABS.Exit_closet1_trap_tech =
{
  template = "Exit_closet1"
  map      = "MAP02"

  prob   = 20
  theme  = "tech"

  seed_w = 1
  seed_h = 2

  tex_STEP3 = "STEP1"

  tex_GRAYVINE = "COMPBLUE"
  tex_SW1VINE  = "SW1BLUE"
}

