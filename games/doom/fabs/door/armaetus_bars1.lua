--
-- Archway with bars
--

PREFABS.Decor_Armaetus_bars_EPIC =
{
  file = "door/armaetus_bars1.wad",
  map = "MAP01",
  theme = "!tech",

  texture_pack = "armaetus",

  seed_w = 1,

  prob = 25,

  where = "edge",
  key = "barred",

  deep = 16,
  over = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Decor_Armaetus_bars_EPIC_tech =
{
  template = "Decor_Armaetus_bars_EPIC",
  theme = "tech",

  tex_GOTH50 = "DOORHI",
  tex_GOTH41 = "SHAWN2"
}

--

PREFABS.Decor_Armaetus_bars_EPIC_wide =
{
  template = "Decor_Armaetus_bars_EPIC",
  map = "MAP03",
  theme = "!tech",

  prob = 25,

  seed_w = 2,

  x_fit = "frame",
}

PREFABS.Decor_Armaetus_bars_EPIC_wide_tech =
{
  template = "Decor_Armaetus_bars_EPIC",
  map = "MAP04",
  theme = "tech",

  prob = 75,

  seed_w = 2,

  x_fit = "frame",
}

--

PREFABS.Decor_gtd_Armaetus_bars_EPIC_stretchy =
{
  template = "Decor_Armaetus_bars_EPIC",
  map = "MAP03",
  theme = "!tech",

  prob = 25,

  seed_w = 2,

  x_fit = { 72,120 , 136,184 }
}

PREFABS.Decor_gtd_Armaetus_bars_EPIC_stretchy_tech =
{
  template = "Decor_Armaetus_bars_EPIC",
  map = "MAP04",
  theme = "tech",

  prob = 75,

  seed_w = 2,

  x_fit = { 72,120 , 136,184 }
}
