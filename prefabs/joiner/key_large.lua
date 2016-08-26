--
-- Large keyed door
--


PREFABS.Locked_joiner_kc_red =
{
  file   = "joiner/key_large.wad"
  where  = "seeds"
  shape  = "I"

  key    = "kc_red"

  seed_w = 2
  seed_h = 1

  x_fit  = "frame"

  nearby_h = 160

  prob   = 100

  -- prefab already has DOORRED texture and line special #33
}


PREFABS.Locked_joiner_ks_red =
{
  template = "Locked_joiner_kc_red"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"
}


PREFABS.Locked_joiner_kc_blue =
{
  template = "Locked_joiner_kc_red"
  key      = "kc_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Locked_joiner_ks_blue =
{
  template = "Locked_joiner_kc_red"
  key      = "ks_blue"

  tex_DOORRED = "DOORBLU2"
  line_33     = 32
}


PREFABS.Locked_joiner_kc_yellow =
{
  template = "Locked_joiner_kc_red"
  key      = "kc_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}


PREFABS.Locked_joiner_ks_yellow =
{
  template = "Locked_joiner_kc_red"
  key      = "ks_yellow"

  tex_DOORRED = "DOORYEL2"
  line_33     = 34
}

