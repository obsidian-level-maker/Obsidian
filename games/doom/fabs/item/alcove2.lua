--
--  Medium techy alcove for keys
--

PREFABS.Item_alcove_techy =
{
  file   = "item/alcove2.wad",

  rank = 2,
  prob   = 200,
  theme  = "tech",
  env    = "!cave",

  item_kind = "key",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",


  sector_12 =  { [0]=20, [8]=20, [12]=50, [13]=30, [21]=10 },

  tex_COMPTALL = { COMPTALL=80, TEKWALL4=30 },
  flat_FLOOR0_2 = { FLOOR0_2=50, FLOOR0_1=50, FLAT5=50 },
  flat_CEIL4_3 = { CEIL4_3=50, CEIL4_2=50, CEIL4_1=50, CEIL5_2=50, FLAT4=50, CEIL3_5=50, CEIL3_1=50, CEIL3_2=50, CEIL3_3=50, FLOOR7_1=50, SLIME14=50, SLIME15=50 }

}

PREFABS.Item_alcove_hell =
{
  template = "Item_alcove_techy",
  theme = "hell",

  prob = 100, -- hell alcoves had a default prob of 200, total 400,

  tex_METAL2 = "SUPPORT3",
  tex_SHAWN2 = "MARBLE1",
  tex_COMPTALL = "SP_FACE1",
  tex_STEP1 = "WOOD1",
  flat_CEIL5_1 = "CEIL5_2",
  flat_FLOOR0_2 = { FLAT5_1=50, FLAT5_2=50 },
  flat_TLITE6_5 = "TLITE6_6",
  flat_CEIL4_3 = { DEM1_5=50, RROCK12=50, MFLR8_2=50, RROCK05=50, FLOOR7_1=50, FLOOR7_2=50, FLOOR6_2=50, FLOOR6_1=50, FLAT5_7=50, FLAT5_8=50 },
  flat_FLAT23 = "FLOOR7_2",

  sector_12 = 0,

}

PREFABS.Item_alcove_hell2 =
{
  template = "Item_alcove_techy",
  theme = "hell",

  prob = 100,

  tex_METAL2 = "SUPPORT3",
  tex_SHAWN2 = "MARBLE1",
  tex_COMPTALL = "FIREBLU1",
  tex_STEP1 = "WOOD1",
  flat_CEIL5_1 = "CEIL5_2",
  flat_FLOOR0_2 = { FLAT5_1=50, FLAT5_2=50 },
  flat_TLITE6_5 = "TLITE6_6",
  flat_CEIL4_3 = { FLOOR6_1=50, FLOOR6_2=50, FLAT5_2=50, GRNROCK=50, RROCK12=50, RROCK13=50, RROCK15=50, SLIME13=50, SLIME09=50, MFLR8_2=50, RROCK01=50, RROCK02=50 },
  flat_FLAT23 = "FLOOR7_2",

  sector_12 = { [0]=20, [17]=60 }

}

PREFABS.Item_alcove_urban =
{
  template = "Item_alcove_techy",
  theme = "urban",

  tex_SHAWN2 = { ASHWALL3=50, ASHWALL4=50 },
  tex_COMPTALL = "TEKWALL4",
  tex_STEP1 = "STEP2",
  flat_FLOOR0_2 = { FLOOR5_3=50, FLOOR5_4=50, FLAT5=50 },
  flat_TLITE6_5 = "TLITE6_6",
  flat_CEIL4_3 = { CEIL3_5=50, MFLR8_4=50, RROCK14=50, FLAT5_4=50 },
  flat_FLAT23 = "RROCK03",

  sector_12 = 0,

}
