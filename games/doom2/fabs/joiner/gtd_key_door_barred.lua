PREFABS.Locked_gtd_door_barred_red_EPIC =
{
  file = "joiner/gtd_key_door_barred.wad",
  map = "MAP01",
  theme = "!hell",

  prob = 250,

  where = "seeds",
  shape = "I",

  texture_pack = "armaetus",

  key = "k_red",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = { 96,104 , 152,160 },
  y_fit = { 76,84 },

  tex_BIGDOORC = 
  {
    BIGDOORC = 10,
    BIGDOORD = 10
  },
  tex_LITEBLU3 = "RDLITE01"
}

PREFABS.Locked_gtd_door_barred_blue_EPIC =
{
  template = "Locked_gtd_door_barred_red_EPIC",

  key = "k_blue",

  tex_DOORRED = "DOORBLU",
  tex_LITEBLU3 = "LITEBLU3",

  line_33 = 32
}

PREFABS.Locked_gtd_door_barred_yellow_EPIC =
{
  template = "Locked_gtd_door_barred_red_EPIC",

  key = "k_yellow",

  tex_DOORRED = "DOORYEL",
  tex_LITEBLU3 = "WARNSTEP",

  line_33 = 34
}
