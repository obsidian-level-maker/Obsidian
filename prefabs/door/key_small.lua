--
-- Keyed doors, small variety
--


----------------------------------------------------
--    BLUE KEYS
----------------------------------------------------

PREFABS.Locked_small_kc_blue =
{
  file   = "door/key_small.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "kc_blue"

  deep   = 32
  over   = 32

  x_fit  = "frame"

  tex_DOORRED  = "DOORBLU"
  line_33 = 32
}


PREFABS.Locked_small_kc_blue_diag =
{
  file   = "door/key_small.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "kc_blue"

  tex_DOORRED  = "DOORBLU"
  line_33 = 32
}


PREFABS.Locked_small_ks_blue =
{
  template = "Locked_small_kc_blue"
  key      = "ks_blue"

  tex_DOORRED = "DOORBLU2"
}


PREFABS.Locked_small_ks_blue_diag =
{
  template = "Locked_small_kc_blue_diag"
  key      = "ks_blue"

  tex_DOORRED  = "DOORBLU2"
}


----------------------------------------------------
--    YELLOW KEYS
----------------------------------------------------

PREFABS.Locked_small_kc_yellow =
{
  file   = "door/key_small.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "kc_yellow"

  deep   = 32
  over   = 32

  x_fit  = "frame"

  tex_DOORRED  = "DOORYEL"
  line_33 = 34
}


PREFABS.Locked_small_kc_yellow_diag =
{
  file   = "door/key_small.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "kc_yellow"

  tex_DOORRED  = "DOORYEL"
  line_33 = 34
}


PREFABS.Locked_small_ks_yellow =
{
  template = "Locked_small_kc_yellow"
  key      = "ks_yellow"

  tex_DOORRED = "DOORYEL2"
}


PREFABS.Locked_small_ks_yellow_diag =
{
  template = "Locked_small_kc_yellow_diag"
  key      = "ks_yellow"

  tex_DOORRED  = "DOORYEL2"
}


----------------------------------------------------
--    RED KEYS
----------------------------------------------------

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


PREFABS.Locked_small_kc_red_diag =
{
  file   = "door/key_small.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "kc_red"

  -- prefab already has DOORRED texture and line special #33
}


PREFABS.Locked_small_ks_red =
{
  template = "Locked_small_kc_red"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"
}


PREFABS.Locked_small_ks_red_diag =
{
  template = "Locked_small_kc_red_diag"
  key      = "ks_red"

  tex_DOORRED = "DOORRED2"
}

