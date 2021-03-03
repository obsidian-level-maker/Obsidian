-- Obvious map24 inspired joiner

PREFABS.Joiner_scionox_minichasm =
{
  file   = "joiner/scionox_minichasm.wad",
  map    = "MAP01",

  prob   = 180,
  theme  = "hell",

  style  = "traps",

  filter = "dexterity",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",
}

PREFABS.Joiner_scionox_minichasm_2 =
{
  template = "Joiner_scionox_minichasm",
  theme  = "!hell",

  tex_TANROCK8 = "GRAYBIG",
  tex_FIREBLU1 = "COMPBLUE",
  flat_FLOOR7_1 = "FLAT5_4",
  flat_FLOOR1_6 = "CEIL4_2",
}
