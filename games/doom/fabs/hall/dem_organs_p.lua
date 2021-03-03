--
-- organs piece : 4 ways + junction
--

PREFABS.Hallway_organs_p1 =
{
  file   = "hall/dem_organs_p.wad",
  map    = "MAP01",
  theme  = "hell",

  group  = "organs",
  prob   = 50,

  where  = "seeds",
  shape  = "P",
  seed_w = 2,
  seed_h = 2,

  engine = "zdoom",
  can_flip = true,

tex_FIREBLU1 = {
    SP_FACE1=50, FIREBLU1=50, FIREBLU2=50, BFALL1=50, BODIESB=50, SKSPINE1=50,
},

line_425 =
{
  [425]=50,
  [426]=50,
  [427]=50,
  [428]=50,
}

}

PREFABS.Hallway_organs_p2 =
{
  template = "Hallway_organs_p1",
  map    = "MAP02",
}

PREFABS.Hallway_organs_p3 =
{
  template = "Hallway_organs_p1",
  map    = "MAP03",
}

PREFABS.Hallway_organs_p4 =
{
  template = "Hallway_organs_p1",
  map    = "MAP04",
}

PREFABS.Hallway_organs_p5 =
{
  template = "Hallway_organs_p1",
  map    = "MAP05",

  style  = "cages",
}
