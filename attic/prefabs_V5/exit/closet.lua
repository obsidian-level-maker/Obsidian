--
-- Exit closets
--

DOOM.SKINS.Exit_Closet_tech =
{
  file   = "exit/closet1.wad"
  where  = "closet"
  x_fit  = "frame"
  y_fit  = "top"

--[[ FIXME
  door  = "EXITDOOR"
  track = "DOORTRAK"
  key   = "EXITDOOR"
  key_ox = 112

  inner = { STARGR2=30, STARBR2=30, STARTAN2=30,
            METAL4=15,  PIPE2=15,  SLADWALL=15,
            TEKWALL4=50 }

  ceil  = { TLITE6_5=40, TLITE6_6=20, GRNLITE1=20,
            CEIL4_3=10, SLIME15=10 }

  floor2 = { FLAT4=20, FLOOR0_1=20, FLOOR0_3=20, FLOOR1_1=20 }

  use_sign = 1
  exit = "EXITSIGN"
  exitside = "COMPSPAN"

  switch  = "SW1COMM"
  sw_side = "SHAWN2"

  special = 11
  tag = 0

  item1 = { stimpack=50, medikit=20, soul=1, none=30 }
  item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
}


DOOM.SKINS.Exit_Closet_hell =
{
  file   = "exit/closet1.wad"
  kind   = "UNFINISHED"
  where  = "closet"

--[[ FIXME
  door  = "EXITDOOR"
  track = "DOORTRAK"
  key   = "SUPPORT3"
  key_ox = 24

  inner = { MARBGRAY=40, SP_HOT1=20, REDWALL=10,
            SKINMET1=10, SLOPPY2=10 }

  ceil = { FLAT5_6=20, LAVA1=5, FLAT10=10, FLOOR6_1=10 }

  floor2  = { SLIME09=10, FLOOR7_2=20, FLAT5_2=10, FLAT5_8=10 }

  use_sign = 1
  exit = "EXITSIGN"
  exitside = "COMPSPAN"

  switch  = { SW1LION=10, SW1SATYR=30, SW1GARG=20 }
  sw_side = "METAL"
  sw_oy   = 56

  special = 11
  tag = 0

  item1 = { stimpack=50, medikit=20, soul=1, none=30 }
  item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
}

