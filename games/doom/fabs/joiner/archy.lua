--
-- Arch joiners
--

PREFABS.Joiner_archy1 =
{
  file   = "joiner/archy.wad",
  map    = "MAP01",

  prob  = 140,
  theme = "urban",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  y_fit = "stretch",

  thing_57 =
  {
    red_torch_sm = 50,
    blue_torch_sm = 30,
    green_torch_sm = 20,
  },

}


--
-- NOTE: this is a workaround for an error when steepness == "NONE",
--
PREFABS.Joiner_archy_workaround =
{
  template = "Joiner_archy1",

  prob  = 0.1,
  theme = "any",

 x_fit = "frame",
 y_fit = "stretch",
}



PREFABS.Joiner_archy1_hell =
{
  template   = "Joiner_archy1",
  map    = "MAP01",
  theme  = "hell",

  thing_57 =
  {
    red_torch_sm = 50,
    blue_torch_sm = 50,
    green_torch_sm = 50,
  },

  flat_FLAT1 = "FLOOR6_2",
  tex_STONE2 = "ASHWALL2",

}


PREFABS.Joiner_archy1_wide =
{
  file   = "joiner/archy.wad",
  map    = "MAP02",

  prob  = 400,
  theme = "urban",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = "frame",

  thing_56 =
  {
    red_torch_sm = 30,
    blue_torch_sm = 50,
    green_torch_sm = 30,
  },

}


PREFABS.Joiner_archy1_wide_hell =
{
  template   = "Joiner_archy1_wide",
  map    = "MAP02",

  theme = "hell",

  thing_56 =
  {
    red_torch_sm = 50,
    blue_torch_sm = 50,
    green_torch_sm = 50,
  },

  flat_FLAT1 = "FLOOR6_2",
  tex_STONE2 = "ASHWALL2",

}
