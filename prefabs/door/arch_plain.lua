--
-- Archway
--

PREFABS.Arch_plain =
{
  file   = "door/arch_plain.wad"
  map    = "MAP01"

  kind   = "arch"
  where  = "edge"

  deep   = 16
  over   = 16

  x_fit  = { 0,8, 56,72, 120,128 }

  bound_z1 = 0
  bound_z2 = 128

  prob = 100
}


PREFABS.Arch_plain_diag =
{
  file   = "door/arch_plain.wad"
  map    = "MAP02"

  kind   = "arch"
  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 128

  prob = 100
}


PREFABS.Arch_plain2 =
{
  file   = "door/arch_plain.wad"
  map    = "MAP03"

  kind   = "arch"
  where  = "edge"

  seed_w = 3

  deep   = 16
  over   = 16

  x_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

  theme  = "tech"
  prob   = 400
}


PREFABS.Arch_plain2_satyr =
{
  template = "Arch_plain2"

  theme  = "urban"
  rank   = 1
  prob   = 250

  tex_SILVER2 = "GSTSATYR"
}

PREFABS.Arch_plain2_garg =
{
  template = "Arch_plain2"

  theme  = "urban"
  rank   = 1
  prob   = 250

  tex_SILVER2 = "GSTGARG"
}

PREFABS.Arch_plain2_lion =
{
  template = "Arch_plain2"

  theme  = "urban"
  rank   = 1
  prob   = 250

  tex_SILVER2 = "GSTLION"
}

