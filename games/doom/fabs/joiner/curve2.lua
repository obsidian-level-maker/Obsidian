--
-- L-shape plain Joiner
--

PREFABS.Joiner_curve2 =
{
  file   = "joiner/curve2.wad",
  theme  = "!tech",

  prob   = 1200,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  tex_STONE2 = "SUPPORT3",
  flat_CEIL3_5 = { FLAT5_1=50, FLAT5_2=50, FLAT5_5=50, FLAT1_1=50, FLAT1_2=50, FLAT8=50, FLAT5=50,
                   FLOOR6_2=50, FLOOR7_2=50, FLAT10=50, CEIL5_2=50 },

}

PREFABS.Joiner_curve2_tech =
{
  file   = "joiner/curve2.wad",
  theme  = "tech",

  prob   = 1200,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  tex_STONE2 = "SUPPORT2",
  flat_CEIL3_5 = { CEIL3_5=50, FLAT5_4=50, FLAT23=50, FLOOR4_8=50, FLOOR5_1=50, FLAT1=50, FLAT3=50,
                 FLAT4=50, FLAT19=50, FLOOR0_1=50, FLOOR0_2=50, FLOOR0_3=50, FLOOR0_5=50, FLOOR0_7=50,
                 FLOOR1_6=50, FLOOR3_3=50, FLOOR4_1=50, FLOOR4_6=50, FLAT14=50, FLOOR7_1=50 },

}

--One with light
PREFABS.Joiner_curve2_tech_light =
{
  template   = "Joiner_curve2_tech",
  map        = "MAP03",

  sector_1  = { [0]=50, [1]=10, [2]=5, [3]=5, [8]=15, [12]=5, [13]=5 },

}
