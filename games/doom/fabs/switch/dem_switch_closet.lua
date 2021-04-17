--
-- A closet with a pump and a main power switch
--
-- Scionox needed a quiet place to work on his machines for Hell's mass 2021---

PREFABS.Switch_Dem_closet1 =
{
  file   = "switch/dem_switch_closet.wad",
  map    = "MAP01",

  prob   = 50,
  engine = "zdoom",
  theme  = "tech",
  env = "!outdoor",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  tag_1 = "?switch_tag",


  x_fit  = "frame",
  y_fit = "top",


  texture_pack = "armaetus",

  bound_z1 = 0,
  bound_z2 = 128,

  sound = "Electric_Sparks",

}

PREFABS.Switch_Dem_closet1_ambush =
{
  template  = "Switch_Dem_closet1",
  map    = "MAP02",


  style  = "cages",
}

