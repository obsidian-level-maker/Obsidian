--
-- Techy square pillar
--

PREFABS.Pillar_tech2_A =
{
  file   = "decor/pillar2.wad"
  map    = "MAP02"

  prob   = 200
  theme  = "tech"
  env    = "building"

  where  = "point"
  size   = 64
  height = 136

  bound_z1 = 0
  bound_z2 = 136

  z_fit  = "top"

  sink_mode = "never"
}


PREFABS.Pillar_tech2_B =
{
  template = "Pillar_tech2_A"

  map = "MAP01"

  prob = 50

  -- sector height must equal 128
  height = { 128,128 }

  bound_z2 = 128
}

