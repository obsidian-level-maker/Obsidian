--
-- Joiner
--

PREFABS.Joiner_plain2 =
{
  file   = "joiner/plain2.wad",
  where  = "seeds",
  shape  = "I",

  prob   = 15, --50,

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",
}

PREFABS.Joiner_plain2_stretchy =
{
  template = "Joiner_plain2",
  prob = 70,

  x_fit = { 32,96 }
}
