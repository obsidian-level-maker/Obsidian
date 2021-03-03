--
-- 2-seed-wide hallway : straight piece
--

PREFABS.Hallway_deuce_i1 =
{
  file   = "hall/deuce_i.wad",
  map    = "MAP01",
  theme  = "!tech",

  group  = "deuce",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  sound = "Outdoors_Street",
}

PREFABS.Hallway_deuce_i1_tech =
{
  template  = "Hallway_deuce_i1",
  map    = "MAP01",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}

PREFABS.Hallway_deuce_i1_rise =
{
  template = "Hallway_deuce_i1",
  map = "MAP02",

  prob = 15,

  style = "steepness",

  delta_h = 32,

  can_flip = true,
}

PREFABS.Hallway_deuce_i_rise_tech =
{
  template = "Hallway_deuce_i1",
  map = "MAP02",
  theme = "tech",

  prob = 15,

  style = "steepness",

  delta_h = 32,

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",

  can_flip = true,
}

PREFABS.Hallway_deuce_i_windowed =
{
  template = "Hallway_deuce_i1",
  map = "MAP03",

  prob = 17,

  tex_DOORTRAK = "SUPPORT3",
  tex_METAL5 = "METAL",

  can_flip = true,

  sound = "Outdoors_Street",
}

PREFABS.Hallway_deuce_i_windowed_tech =
{
  template  = "Hallway_deuce_i1",
  map    = "MAP03",
  theme  = "tech",

  prob = 17,

  tex_METAL = "SHAWN2",
  tex_DOORTRAK = "DOORSTOP",
  tex_METAL5 = "GRAY7",
  flat_CEIL5_2 = "FLAT23",

  can_flip = true,

  sound = "Outdoors_Street",
}

PREFABS.Hallway_deuce_i_side_cage =
{
  template = "Hallway_deuce_i1",
  map = "MAP04",

  prob = 17,

  tex_DOORTRAK = "SUPPORT3",
  tex_METAL5 = "METAL",

  can_flip = true,
}

PREFABS.Hallway_deuce_i_side_cage_tech =
{
  template  = "Hallway_deuce_i1",
  map    = "MAP04",
  theme  = "tech",

  prob = 17,

  tex_METAL = "SHAWN2",
  tex_DOORTRAK = "DOORSTOP",
  tex_GSTLION = "COMPWERD",
  flat_CEIL5_2 = "FLAT23",

  tex_STEP3 = "STEP4",
  flat_CEIL1_3 = "FLAT17",

  can_flip = true,
}

PREFABS.Hallway_deuce_i_stout =
{
  template = "Hallway_deuce_i1",
  map = "MAP05",

  prob = 17,

  can_flip = true,
}

PREFABS.Hallway_deuce_i_stout_tech =
{
  template = "Hallway_deuce_i1",
  map = "MAP05",
  theme  = "tech",

  prob = 17,

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",

  tex_CRACKLE2 = "COMPWERD",
  tex_SUPPORT3 = "DOORSTOP",

  can_flip = true,
}

PREFABS.Hallway_deuce_i_light_box =
{
  template = "Hallway_deuce_i1",
  map = "MAP06",

  prob = 35,
}

PREFABS.Hallway_deuce_i_light_box_tech =
{
  template = "Hallway_deuce_i1",
  map = "MAP06",
  theme  = "tech",

  prob = 35,

  tex_METAL = "SHAWN2",
  flat_CEIL1_3 = "FLAT17",
  flat_CEIL5_2 = "FLAT23",
}

--

PREFABS.Hallway_deuce_i_fake_door_and_window =
{
  template = "Hallway_deuce_i1",
  map = "MAP07",
  theme = "urban",

  prob = 50,

  tex_DOOR3 =
  {
    DOOR1=1,
    DOOR3=1,
    SPCDOOR3=1,
  },

  can_flip = true,
}

--

PREFABS.Hallway_deuce_i_fake_door_tech =
{
  template = "Hallway_deuce_i1",
  map = "MAP08",
  theme = "tech",

  prob = 75,

  tex_DOOR3 =
  {
    DOOR1=1,
    DOOR3=1,
    SPCDOOR3=1,
  },
  tex_METAL = "SHAWN2",
  flat_CEIL1_3 = "FLAT17",
  flat_CEIL5_2 = "FLAT23",

  can_flip = true,
}

PREFABS.Hallway_deuce_i_fake_door_urban =
{
  template = "Hallway_deuce_i1",
  map = "MAP08",
  theme = "urban",

  prob = 50,

  tex_DOOR3 =
  {
    DOOR1=1,
    DOOR3=1,
    SPCDOOR3=1,
  },

  can_flip = true,
}

--

PREFABS.Hallway_deuce_i_shutter_tech =
{
  template = "Hallway_deuce_i1",
  map = "MAP09",
  theme = "tech",

  prob = 75,

  tex_STEP4 =
  {
    STEP4=2,
    STEP1=1,
    STEP2=1,
    STEP5=1,
  },
  tex_METAL = "SHAWN2",
  flat_CEIL1_3 = "FLAT17",
  flat_CEIL5_2 = "FLAT23",

  can_flip = true,
}

PREFABS.Hallway_deuce_i_shutter_urban =
{
  template = "Hallway_deuce_i1",
  map = "MAP09",
  theme = "urban",

  prob = 50,

  tex_STEP4 =
  {
    STEP4=2,
    STEP1=1,
    STEP2=1,
    STEP5=1,
  },

  can_flip = true,
}
