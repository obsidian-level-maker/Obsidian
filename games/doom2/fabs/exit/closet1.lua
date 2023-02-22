--
-- Exit closet
--

PREFABS.Exit_closet1 =
{
  file   = "exit/closet1.wad",

  prob   = 100,
  theme  = "!tech",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  sector_1  = { [0]=70, [1]=15 }

}


PREFABS.Exit_closet1_tech =
{
  template = "Exit_closet1",

  theme = "tech",

  tex_STEP3 = "STEP1",

  tex_GRAYVINE = "COMPBLUE",
  tex_SW1VINE  = "SW1BLUE",

  sector_1  = { [0]=70, [1]=15 }

}


------- Exit-to-Secret ---------------------------


PREFABS.Exit_closet1_secret =
{
  template = "Exit_closet1",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,

  tex_GRAYVINE = "SP_HOT1",
  tex_SW1VINE  = "SW1HOT",
}


------- Trappy variation -------------------------


PREFABS.Exit_closet1_trap =
{
  template = "Exit_closet1",
  map      = "MAP02",

  prob   = 30,
  theme  = "!tech",
  style  = "traps",

  seed_w = 1,
  seed_h = 2,

  sector_1  = { [0]=70, [1]=15 }

}


PREFABS.Exit_closet1_trap_tech =
{
  template = "Exit_closet1",
  map      = "MAP02",

  prob   = 30,
  theme  = "tech",
  style  = "traps",

  seed_w = 1,
  seed_h = 2,

  tex_STEP3 = "STEP1",

  tex_GRAYVINE = "COMPBLUE",
  tex_SW1VINE  = "SW1BLUE",

  sector_1  = { [0]=70, [1]=15 }

}

