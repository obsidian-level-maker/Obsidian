--
-- vent piece : dead-end
--

PREFABS.Hallway_vent_u1 =
{
  file   = "hall/vent_u.wad",
  map    = "MAP01",

  group  = "vent",
  prob   = 50,

  where  = "seeds",
  shape  = "U",
}


PREFABS.Hallway_vent_cage1 =
{
  file   = "hall/vent_u.wad",
  map    = "MAP02",
  theme  = "!hell",

  group  = "vent",
  style  = "cages",
  prob   = 50,

  where  = "seeds",
  shape  = "U",
}

PREFABS.Hallway_vent_cage1_hell =
{
  template   = "Hallway_vent_u1",
  map    = "MAP02",
  theme  = "hell",

  tex_ICKWALL3 = "METAL",
  flat_FLAT20 = "CEIL5_2",

  sector_1  = { [8]=50, [1]=15, [2]=5, [3]=5, [17]=10, [12]=7, [13]=7 }

}

PREFABS.Hallway_vent_u_lonely_ronery_grate =
{
  template = "Hallway_vent_u1",
  map      = "MAP03",
}
