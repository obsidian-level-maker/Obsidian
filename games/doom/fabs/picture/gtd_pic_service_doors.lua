PREFABS.Pic_service_gate_1 =
{
  file = "picture/gtd_pic_service_doors.wad",
  map = "MAP01",

  prob = 15,
  theme = "!hell",

  env = "outdoor",

  where = "seeds",
  height = 128,

  texture_pack = "armaetus",

  deep = 16,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  tex_BIGDOORF =
  {
    BIGDOORC = 1,
    BIGDOORD = 1,
    DOORHI = 1,
    BIGDOORF = 1,
    URBAN6 = 1,
    URBAN8 = 1,
  },
}

PREFABS.Pic_service_gate_2 =
{
  template = "Pic_service_gate_1",
  map = "MAP02",

  x_fit = { 124,132 },
}
