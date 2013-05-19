--
-- Pillars
--

DOOM.SKINS.Room_pillar1 =
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

  props_45 = { light=176, _factor=0.6 }
}

