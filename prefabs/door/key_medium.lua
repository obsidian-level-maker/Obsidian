--
-- Keyed doors, medium size
--


PREFABS.Locked_medium_kc_red =
{
  file   = "door/key_medium.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "kc_red"

  seed_w = 2

  deep   = 32
  over   = 32

  x_fit  = "frame"

  rank   = 1

  -- prefab already has DOORRED texture and line special #33
}

PREFABS.Locked_medium_kc_red_diag =
{
  file   = "door/key_medium.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "kc_red"

  seed_w = 2
  seed_h = 2

  rank   = 1

  -- prefab already has DOORRED texture and line special #33
}


PREFABS.Locked_medium_ks_red =
{
  template = "Locked_medium_kc_red"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"

  tex_BIGDOOR1 = "BIGDOOR5"
  flat_FLAT23  = "CEIL5_2"
}

PREFABS.Locked_medium_ks_red_diag =
{
  template = "Locked_medium_kc_red_diag"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"

  tex_BIGDOOR1 = "BIGDOOR5"
  flat_FLAT23  = "CEIL5_2"
}


------------------------------------------


PREFABS.Locked_medium_kc_blue =
{
  template = "Locked_medium_kc_red"
  key      = "kc_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}

PREFABS.Locked_medium_kc_blue_diag =
{
  template = "Locked_medium_kc_red_diag"
  key      = "kc_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Locked_medium_ks_blue =
{
  template = "Locked_medium_ks_red"
  key      = "ks_blue"

  tex_DOORRED = "DOORBLU2"
  line_33     = 32
}

PREFABS.Locked_medium_ks_blue_diag =
{
  template = "Locked_medium_ks_red_diag"
  key      = "ks_blue"

  tex_DOORRED = "DOORBLU2"
  line_33     = 32
}


------------------------------------------


PREFABS.Locked_medium_kc_yellow =
{
  template = "Locked_medium_kc_red"
  key      = "kc_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

PREFABS.Locked_medium_kc_yellow_diag =
{
  template = "Locked_medium_kc_red_diag"
  key      = "kc_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}


PREFABS.Locked_medium_ks_yellow =
{
  template = "Locked_medium_ks_red"
  key      = "ks_yellow"

  tex_DOORRED = "DOORYEL2"
  line_33     = 34
}

PREFABS.Locked_medium_ks_yellow_diag =
{
  template = "Locked_medium_ks_red_diag"
  key      = "ks_yellow"

  tex_DOORRED = "DOORYEL2"
  line_33     = 34
}

