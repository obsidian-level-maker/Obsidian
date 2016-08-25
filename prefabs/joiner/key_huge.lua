--
-- Huge keyed door
--


PREFABS.Locked_huge_kc_red =
{
  file   = "joiner/key_huge.wad"
  where  = "seeds"

  key    = "kc_red"

  seed_w = 3
  seed_h = 2

  x_fit  = "frame"

  nearby_h = 160

  prob   = 100

  -- prefab already has DOORRED texture and line special #33
}


PREFABS.Locked_huge_ks_red =
{
  template = "Locked_huge_kc_red"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"
}


PREFABS.Locked_huge_kc_blue =
{
  template = "Locked_huge_kc_red"
  key      = "kc_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Locked_huge_ks_blue =
{
  template = "Locked_huge_kc_red"
  key      = "ks_blue"

  tex_DOORRED = "DOORBLU2"
  line_33     = 32
}


PREFABS.Locked_huge_kc_yellow =
{
  template = "Locked_huge_kc_red"
  key      = "kc_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}


PREFABS.Locked_huge_ks_yellow =
{
  template = "Locked_huge_kc_red"
  key      = "ks_yellow"

  tex_DOORRED = "DOORYEL2"
  line_33     = 34
}

