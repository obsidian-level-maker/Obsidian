PREFABS.Arch_bare =
{
  file = "door/gtd_bare_arch.wad",
  map = "MAP01",

  prob = 200,
  theme = "!hell",

  kind = "arch",
  where = "edge",

  deep = 16,
  over = 16,

  seed_w = 1,

  x_fit = { 60,68 },
  z_fit = "top",

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Arch_bare_columned =
{
  template = "Arch_bare",
  map = "MAP02",

  seed_w = 2,

  x_fit = { 32,96 , 160,224 },
}

PREFABS.Arch_bare_columned_2X =
{
  template = "Arch_bare",
  map = "MAP03",

  seed_w = 3,

  x_fit = { 24,104 , 152,232 , 280,360 }
}

-- hell version

PREFABS.Arch_bare_hell =
{
  template = "Arch_bare",
  map = "MAP01",

  theme = "hell",

  x_fit = { 60,68 },

  tex_EXITDOOR = "FIREMAG1",
}

PREFABS.Arch_bare_columned_hell =
{
  template = "Arch_bare",
  map = "MAP02",

  theme = "hell",

  seed_w = 2,

  x_fit = { 32,96 , 160,224 },

  tex_EXITDOOR = "FIREMAG1",
}

PREFABS.Arch_bare_columned_2X_hell =
{
  template = "Arch_bare",
  map = "MAP03",

  theme = "hell",

  seed_w = 3,

  x_fit = { 24,104 , 152,232 , 280,360 },

  tex_EXITDOOR = "FIREMAG1",
}
