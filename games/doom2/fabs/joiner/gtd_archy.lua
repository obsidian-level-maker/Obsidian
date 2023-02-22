PREFABS.Joiner_gtd_archy1 =
{
  file   = "joiner/gtd_archy.wad",
  map    = "MAP01",

  prob  = 140,
  theme = "urban",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = {96,192 , 320,416},
  y_fit = "stretch",

  thing_2028 =
  {
    [2028] = 50,
    [85] = 50,
    [86] = 50
  }
}

PREFABS.Joiner_gtd_archy2 =
{
  template = "Joiner_gtd_archy1",
  map = "MAP02",

}

PREFABS.Joiner_gtd_archy1_hell =
{
  template = "Joiner_gtd_archy1",

  theme = "hell",

  thing_2028 =
  {
    red_torch_sm = 50,
    blue_torch_sm = 30,
    green_torch_sm = 20
  }
}

PREFABS.Joiner_gtd_archy2_hell =
{
  template = "Joiner_gtd_archy1",
  map = "MAP02",

  theme = "hell",

  thing_2028 =
  {
    red_torch_sm = 50,
    blue_torch_sm = 30,
    green_torch_sm = 20
  }
}
