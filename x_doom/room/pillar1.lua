--
-- Big tech pillar
--

DOOM.SKINS.Room_pillar_big =
{
  file   = "room/pillar1.wad"

  seed_w = 3
  seed_h = 3

  north  = "..."
  east   = "..."
  south  = "..."
  west   = "..."

  prob   = 100

  theme  = "tech"
}


--
-- Urban wood + four pillars + height diff
--

DOOM.SKINS.Room_pillar2 =
{
  file   = "room/pillar2.wad"
  kind   = "UNFINISHED"

  seed_w = 3
  seed_h = 3

  edges  =
  {
    a = { f_h=32 }
  }

  north  = "aaa"
  south  = "aaa"
  east   = "a.a"
  west   = "a.a"

  prob   = 10

  theme  = "urban"

  props_45 = { light=176, factor=0.6 }
}


--
-- Four pillars and a sky hole
--

DOOM.SKINS.Room_pillar3 =
{
  file   = "room/pillar3.wad"

  prob   = 9999

  seed_w = 3
  seed_h = 3

  north  = "..."
  south  = "..."
  east   = "..."
  west   = "..."

  theme  = "!tech"

  props_45 = { light=176, factor=0.6 }
}

