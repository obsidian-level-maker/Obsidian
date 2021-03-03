-- Door and a box

PREFABS.Joiner_scionox_door_and_box =
{
  file   = "joiner/scionox_door_and_box.wad",
  map    = "MAP01",

  prob   = 75,
  theme  = "tech",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 8,16 , 144,152 },

  tex_BIGDOOR2 = { BIGDOOR1=50, BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
}

PREFABS.Joiner_scionox_door_and_box_2 =
{
  template = "Joiner_scionox_door_and_box",

  flat_CRATOP1 = "CRATOP2",
  tex_CRATE2 = "CRATE1",
}

PREFABS.Joiner_scionox_door_and_box_3 =
{
  template = "Joiner_scionox_door_and_box",
  theme  = "urban",
  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_door_and_box_4 =
{
  template = "Joiner_scionox_door_and_box",
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_CRATOP1 = "CRATOP2",
  tex_CRATE2 = "CRATE1",
}

PREFABS.Joiner_scionox_door_and_box_5 =
{
  template = "Joiner_scionox_door_and_box",
  map    = "MAP02",

  theme  = "!hell",
  style  = "doors",

  y_fit  = { 8,16 , 148,152 },

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
}

PREFABS.Joiner_scionox_door_and_box_6 =
{
  template = "Joiner_scionox_door_and_box",
  map    = "MAP02",

  theme  = "!hell",
  style  = "doors",

  y_fit  = { 8,16 , 148,152 },

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
  flat_CRATOP1 = "CRATOP2",
  tex_CRATE2 = "CRATE1",
}

PREFABS.Joiner_scionox_door_and_box_7 =
{
  template = "Joiner_scionox_door_and_box",
  map    = "MAP03",

  theme  = "tech",
  style  = "doors",

  y_fit  = { 4,8 , 148,156 },

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
  sector_12  = { [0]=30, [8]=8, [12]=15, [13]=15 },
}

PREFABS.Joiner_scionox_door_and_box_8 =
{
  template = "Joiner_scionox_door_and_box",
  map    = "MAP03",

  theme  = "tech",
  style  = "doors",

  y_fit  = { 4,8 , 148,156 },

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
  sector_12  = { [0]=30, [8]=8, [12]=15, [13]=15 },
  flat_CRATOP1 = "CRATOP2",
  tex_CRATE2 = "CRATE1",
}

PREFABS.Joiner_scionox_door_and_box_9 =
{
  template = "Joiner_scionox_door_and_box",
  map    = "MAP03",

  theme  = "urban",
  style  = "doors",

  y_fit  = { 4,8 , 148,156 },

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
  sector_12  = { [0]=30, [8]=8, [12]=15, [13]=15 },
  thing_2028 = "mercury_small",
}

PREFABS.Joiner_scionox_door_and_box_10 =
{
  template = "Joiner_scionox_door_and_box",
  map    = "MAP03",

  theme  = "urban",
  style  = "doors",

  y_fit  = { 4,8 , 148,156 },

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
  sector_12  = { [0]=30, [8]=8, [12]=15, [13]=15 },
  flat_CRATOP1 = "CRATOP2",
  tex_CRATE2 = "CRATE1",
  thing_2028 = "mercury_small",
}
