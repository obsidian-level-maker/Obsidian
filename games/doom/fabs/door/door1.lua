--
-- A rather plain door
--

PREFABS.Door_plain2 =
{
  file   = "door/door1.wad",
  map    = "MAP02",

  prob   = 150,

  kind   = "arch",
  style  = "doors",

  where  = "edge",
  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }
}

PREFABS.Door_plain3 =
{
  template   = "Door_plain2",
  map    = "MAP02",

  prob   = 150,

  tex_BIGDOOR4 = "BIGDOOR3",
  flat_CEIL5_2 = "FLOOR7_2",

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}

PREFABS.Door_plain4 =
{
  template   = "Door_plain2",
  map    = "MAP02",

  prob   = 150,

  tex_BIGDOOR4 = "BIGDOOR2",
  flat_CEIL5_2 = "FLAT20",

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}

-- MSSP: diagonal doors?

--[[
PREFABS.Door_plain_diag =
{
  file   = "door/door1.wad",
  map    = "MAP03",

  prob   = 100,

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 128,

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}

PREFABS.Door_plain3_diag =
{
  template   = "Door_plain_diag",
  map    = "MAP03",

  tex_BIGDOOR4 = "BIGDOOR3",
  flat_CEIL5_2 = "FLOOR7_2",

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}

PREFABS.Door_plain4_diag =
{
  template   = "Door_plain_diag",
  map    = "MAP03",

  tex_BIGDOOR4 = "BIGDOOR2",
  flat_CEIL5_2 = "FLAT20",

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}

PREFABS.Door_plain2_diag_hell =
{
  template   = "Door_plain_diag",
  map    = "MAP03",
  rank   = 2,
  theme  = "hell",
  prob   = 250,

  flat_TLITE6_6 = "FLAT1",
  tex_BIGDOOR4 = { BIGDOOR7=50, BIGDOOR6=50, BIGDOOR5=50 }

  tex_LITE5 = "FIREBLU1",

  sector_1  = { [0]=85, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5, [17]=20 }

}

PREFABS.Door_plain3_diag_hell =
{
  template   = "Door_plain_diag",
  map    = "MAP03",
  rank   = 2,
  theme  = "hell",
  prob   = 250,

  flat_TLITE6_6 = "FLAT1",
  tex_BIGDOOR4 = { MARBFACE=50, MARBFAC3=50, MARBFAC2=20 }
  flat_CEIL5_2 = "FLOOR7_2",
  tex_LITE5 = "FIREBLU1",
  tex_COMPSPAN = "METAL",
  tex_CEIL5_1 = "CEIL5_2",

  sector_1  = { [0]=85, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5, [17]=20 }

}
]]

PREFABS.Door_plain2_hell =
{
  template = "Door_plain2",

  theme  = "hell",
  prob   = 100,

  flat_TLITE6_6 = "TLITE6_5",
  tex_BIGDOOR4 = { BIGDOOR7=50, BIGDOOR6=50, BIGDOOR5=50 },
  tex_COMPSPAN = "METAL",
  tex_CEIL5_1 = "CEIL5_2",

  sector_1  = { [0]=85, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5, [17]=20 }

}

PREFABS.Door_plain3_hell =
{
  template   = "Door_plain2",
  map    = "MAP02",

  prob   = 100,
  theme  = "hell",

  tex_BIGDOOR4 = { MARBFACE=50, MARBFAC3=50, MARBFAC2=20 },
  flat_CEIL5_2 = "FLOOR7_2",
  tex_COMPSPAN = "METAL",
  tex_CEIL5_1 = "CEIL5_2",
  tex_LITE5 = "FIREBLU1",

  sector_1  = { [0]=85, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5, [17]=20 }

}

PREFABS.Door_plain_tech =
{
  file   = "door/door1.wad",
  map    = "MAP04",

  prob   = 400,
  theme  = "tech",

  where  = "edge",
  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}

--[[
PREFABS.Door_plain_diag_tech =
{
  file   = "door/door1.wad",
  map    = "MAP05",

  prob   = 200,
  theme  = "tech",

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 128,

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }

}
]]
