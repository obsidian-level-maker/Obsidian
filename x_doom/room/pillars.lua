--
-- Big tech pillar
--

DOOM.SKINS.Room_pillar_big =
{
  file   = "room/pillar1.wad"

  prob   = 100

  seed_w = 3
  seed_h = 3

  north  = "..."
  east   = "..."
  south  = "..."
  west   = "..."

  theme  = "tech"
}


--
-- Urban wood + four pillars + height diff
--

DOOM.SKINS.Room_pillar2 =
{
  file   = "room/pillar2.wad"
  kind   = "UNFINISHED"

  prob   = 10

  seed_w = 3
  seed_h = 3

  edges  =
  {
    b = { f_h=32 }
  }

  north  = "bbb"
  south  = "bbb"

  east   = "b.b"
  west   = "b.b"

  theme  = "urban"

  props_45 = { light=176, factor=0.6 }
}


--
-- Four large pillars and a sky hole
--

DOOM.SKINS.Room_pillar3 =
{
  file   = "room/pillar3.wad"

  prob   = 30

  seed_w = 3
  seed_h = 3

  north  = "..."
  south  = "..."
  east   = "..."
  west   = "..."

  theme  = "!tech"

  props_45 = { light=176, factor=0.6 }
}


--
-- Four pillars around a U-shape ledge
--

DOOM.SKINS.Room_pillar4 =
{
  file = "room/pillar4.wad"

  prob = 2000

  seed_w = 3
  seed_h = 3

  edges =
  {
    b = { f_h=48 }
  }
 
  north  = "bbb"
  south  = "b.b"

  east   = "bbb"
  west   = "bbb"
}

