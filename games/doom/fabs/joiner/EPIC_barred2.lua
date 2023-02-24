PREFABS.Joiner_EPIC_remote_door_tech =
{
  file   = "joiner/barred2.wad",
  where  = "seeds",
  shape  = "I",
  map    = "MAP01",

  theme = "tech",

  texture_pack = "armaetus",

  key    = "barred",

  prob   = 40 * 7,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",

  flat_FLAT1 =
  {
    FLAT1 = 50,
    FLOOR0_1 = 50,
    FLAT19 = 50,
  },

  tex_SILVER3 =
  {
    BIGDOORA = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORL = 50,
  },

  tex_FLAT23 =
  {
    CEIL5_1 = 50,
    CEIL5_2 = 50,
  },
}

PREFABS.Joiner_EPIC_remote_door_urban =
{
  template = "Joiner_EPIC_remote_door_tech",

  theme = "urban",

  flat_FLAT1 = { FLAT5_1=50, FLAT5_2=50 },

  tex_SILVER3 =
  {
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOOR0 = 50,
    BIGDOORA = 50,
    BIGDOORB = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORE = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
    BIGDOORL = 50,
  },
}

PREFABS.Joiner_EPIC_remote_door_hell =
{
  template = "Joiner_EPIC_remote_door_tech",

  theme = "hell",

  flat_FLAT1 = { FLAT10=50, RROCK09=50, RROCK16=50 },

  tex_SILVER3 =
  {
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOOR0 = 50,
    BIGDOORA = 50,
    BIGDOORB = 50,
    BIGDOORE = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
  },
}

PREFABS.Joiner_EPIC_remote_sw_metal_tech =
{
  template = "Joiner_EPIC_remote_door_tech",
  key = "sw_metal",

  prob = 15 * 7,

  theme = "tech",

  x_fit = "frame",
  y_fit = "stretch",

  tex_SILVER3 =
  {
    BIGDOORA = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORL = 50,
  },

  flat_FLAT23 = "CEIL5_2",
}

PREFABS.Joiner_EPIC_remote_sw_metal_urban =
{
  template = "Joiner_EPIC_remote_door_tech",
  key = "sw_metal",

  prob = 15 * 7,

  theme = "urban",

  x_fit = "frame",
  y_fit = "stretch",

  tex_SILVER3 =
  {
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOOR0 = 50,
    BIGDOORA = 50,
    BIGDOORB = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORE = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
    BIGDOORL = 50,
  },

  flat_FLAT23 = "CEIL5_2",
}

PREFABS.Joiner_EPIC_remote_sw_metal_hell =
{
  template = "Joiner_EPIC_remote_door_tech",
  key = "sw_metal",

  prob = 15 * 7,

  theme = "hell",

  x_fit = "frame",
  y_fit = "stretch",

  tex_SILVER3 =
  {
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOOR0 = 50,
    BIGDOORA = 50,
    BIGDOORB = 50,
    BIGDOORE = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
  },

  flat_FLAT23 = "CEIL5_2",
}
