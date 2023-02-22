PREFABS.Locked_joiner_round_3key_modern =
{
  file = "joiner/gtd_gate_round_3key.wad",
  map = "MAP01",

  where  = "seeds",
  shape = "I",

  theme  = "!hell",

  key = "k_ALL",

  prob = 200,

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit = { 132,136 },
}

PREFABS.Locked_joiner_round_3key_hell =
{
  template = "Locked_joiner_round_3key_modern",

  theme = "hell",

  tex_EXITDOOR = "FIRELAVA",

  tex_BIGDOOR2 = "MARBFACE",
  tex_BIGDOOR3 = "MARBFAC2",
  tex_BIGDOOR4 = "MARBFAC3",

  tex_DOORRED  = "DOORRED2",
  tex_DOORYEL  = "DOORYEL2",
  tex_DOORBLU  = "DOORBLU2",
}
