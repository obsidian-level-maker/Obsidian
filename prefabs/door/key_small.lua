--
-- Keyed doors, small variety
--


PREFABS.Locked_small_kc_red =
{
  file   = "door/key_small.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "kc_red"

  deep   = 32
  over   = 32

  x_fit  = "frame"

  -- prefab already has DOORRED texture and line special #33
}


PREFABS.Locked_small_ks_red =
{
  template = "Locked_small_kc_red"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"
}


PREFABS.Locked_small_kc_blue =
{
  template = "Locked_small_kc_red"
  key      = "kc_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Locked_small_ks_blue =
{
  template = "Locked_small_kc_red"
  key      = "ks_blue"

  tex_DOORRED = "DOORBLU2"
  line_33     = 32
}


PREFABS.Locked_small_kc_yellow =
{
  template = "Locked_small_kc_red"
  key      = "kc_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}


PREFABS.Locked_small_ks_yellow =
{
  template = "Locked_small_kc_red"
  key      = "ks_yellow"

  tex_DOORRED = "DOORYEL2"
  line_33     = 34
}

