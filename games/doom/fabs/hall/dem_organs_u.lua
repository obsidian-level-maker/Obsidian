--
-- organs piece : dead ends
--

PREFABS.Hallway_organs_u1 =
{
  file   = "hall/dem_organs_u.wad",
  map    = "MAP01",
  theme  = "hell",

  group  = "organs",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  engine = "zdoom",

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

PREFABS.Hallway_organs_u2 =
{
  template = "Hallway_organs_u1",
  map    = "MAP02",
}

PREFABS.Hallway_organs_u3 =
{
  template = "Hallway_organs_u1",
  map    = "MAP03",

  style  = "cages",
}

PREFABS.Hallway_organs_u4 =
{
  template = "Hallway_organs_u1",
  map    = "MAP04",
}

PREFABS.Hallway_organs_u5 =
{
  template = "Hallway_organs_u1",
  map    = "MAP05",

  style  = "cages",
}

PREFABS.Hallway_organs_u6 =
{
  template = "Hallway_organs_u1",
  map    = "MAP06",
}
