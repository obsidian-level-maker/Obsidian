--
-- Hallway with a trim
--

DOOM.SKINS.Hall_trim1_I =
{
  file   = "hall/trim1_i_win.wad"
  group  = "hall_trim"
  shape  = "I"
}


DOOM.SKINS.Hall_trim1_I_Lit3 =
{
  file   = "hall/trim1_i_lit3.wad"
  group  = "hall_trim"
  shape  = "I"

  seed_w = 1
  seed_h = 3
}


DOOM.SKINS.Hall_trim1_C =
{
  file   = "hall/trim1_c.wad"
  group  = "hall_trim"
  shape  = "C"
}


DOOM.SKINS.Hall_trim1_T =
{
  file   = "hall/trim1_t_lit.wad"
  group  = "hall_trim"
  shape  = "T"
}


DOOM.SKINS.Hall_trim1_P =
{
  file   = "hall/trim1_p.wad"
  group  = "hall_trim"
  shape  = "P"
}


DOOM.SKINS.Hall_trim1_Arch =
{
  file   = "hall/trim1_arch.wad"
  kind   = "arch"
  group  = "hall_trim"
  where  = "edge"

  long   = 192
  deep   = 48
  x_fit  = "frame"
}


DOOM.SKINS.Hall_trim1_Stair16 =
{
  file   = "hall/trim1_s16.wad"
  group  = "hall_trim"
  shape  = "stair16"

  north  = { h=16 }
}


DOOM.SKINS.Hall_trim1_Stair32 =
{
  file   = "hall/trim1_s32.wad"
  group  = "hall_trim"
  shape  = "stair32"

  north  = { h=32 }
}


DOOM.SKINS.Hall_trim1_Stair64 =
{
  file   = "hall/trim1_s64.wad"
  group  = "hall_trim"
  shape  = "stair64"

  north  = { h=64 }
}


DOOM.SKINS.Hall_trim1_Lift =
{
  file   = "hall/trim1_lf.wad"
  group  = "hall_trim"
  shape  = "lift"
  z_fit  = "top"
}


--
-- Group for these hallway pieces
--

DOOM.GROUPS.hall_trim =
{
  kind = "hall"

  theme = { tech=1, other=0 }
}

