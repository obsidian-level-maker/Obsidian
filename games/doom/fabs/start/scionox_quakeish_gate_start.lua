-- quake-inspired gate start

PREFABS.Start_scionox_quakeish_gate_start =
{
  file = "start/scionox_quakeish_gate_start.wad",
  map = "MAP01",

  prob = 250,

  theme = "hell",

  where = "seeds",

  texture_pack = "armaetus",

  seed_w = 3,
  seed_h = 1,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",

  tex_EVILFAC2 = { EVILFAC2=50, EVILFAC4=50, EVILFAC5=50,
  EVILFAC6=50, EVILFAC7=50, EVILFAC8=50, EVILFAC9=50, EVILFACA=50 },
}

PREFABS.Start_scionox_quakeish_gate_start_2 =
{
  template = "Start_scionox_quakeish_gate_start",
  tex_BODIESC = "BODIESB",
  flat_BODIESF2 = "BODIESFL",
}
