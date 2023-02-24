-- Obvious e1m1 inspired joiner

PREFABS.Joiner_scionox_zigzag_liquid =
{
  file   = "joiner/scionox_zigzag_liquid.wad",
  map    = "MAP01",

  prob   = 250,
  theme  = "!hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",
}
PREFABS.Joiner_scionox_zigzag_liquid_2 =
{
  template = "Joiner_scionox_zigzag_liquid",
  theme  = "hell",
  map    = "MAP02",
}
