--
-- Curvey hallway
--

DOOM.SKINS.Hall_curve_I =
{
  file   = "hall/curve_i.wad"
  group  = "hall_curve"
  shape  = "I"
}

DOOM.SKINS.Hall_curve_I_skylight =
{
  file   = "hall/curve_i_sky2.wad"
  group  = "hall_curve"
  shape  = "I"

  seed_w = 1
  seed_h = 3
}

DOOM.SKINS.Hall_curve_C =
{
  file   = "hall/curve_c.wad"
  group  = "hall_curve"
  shape  = "C"
}

DOOM.SKINS.Hall_curve_T =
{
  file   = "hall/curve_t.wad"
  group  = "hall_curve"
  shape  = "T"
}

DOOM.SKINS.Hall_curve_P =
{
  file   = "hall/curve_p.wad"
  group  = "hall_curve"
  shape  = "P"
}

DOOM.SKINS.Hall_curve_Stair_S =
{
  file   = "hall/curve_ss.wad"
  group  = "hall_curve"
  shape  = "stair32"

  north  = { h=32 }
}

DOOM.SKINS.Hall_curve_Stair_M =
{
  file   = "hall/curve_sm.wad"
  group  = "hall_curve"
  shape  = "stair64"

  north  = { h=64 }
}

DOOM.SKINS.Hall_curve_Stair_L =
{
  file   = "hall/curve_sl.wad"
  group  = "hall_curve"
  shape  = "stair96"

  north  = { h=96 }
}

DOOM.SKINS.Hall_curve_Lift =
{
  file   = "hall/curve_lf.wad"
  group  = "hall_curve"
  shape  = "lift"
  z_fit  = "top"
}

--
-- Group information
--

DOOM.GROUPS.hall_curve =
{
  kind = "hall"

  theme = { tech=0, other=1 }
}

