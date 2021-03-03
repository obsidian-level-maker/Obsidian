--
-- Double archway with a picture
--

PREFABS.Arch_pic1 =
{
  file   = "door/arch_w_pic.wad",
  map    = "MAP01",

  prob   = 400,
  theme  = "tech",

  env      = "building",
  neighbor = "building",

  kind   = "arch",
  where  = "edge",
  seed_w = 3,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,
}


-- versions for Urban theme --

PREFABS.Arch_pic1_satyr =
{
  template = "Arch_pic1",

  prob   = 250,
  theme  = "!tech",

  tex_SILVER2 = "GSTSATYR",
}

PREFABS.Arch_pic1_garg =
{
  template = "Arch_pic1",

  prob   = 250,
  theme  = "!tech",

  tex_SILVER2 = "GSTGARG",
}

PREFABS.Arch_pic1_lion =
{
  template = "Arch_pic1",

  prob   = 250,
  theme  = "!tech",

  tex_SILVER2 = "GSTLION",
}

