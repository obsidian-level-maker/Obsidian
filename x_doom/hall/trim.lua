--
-- Hallway with a trim
--

DOOM.SKINS.Hall_Basic_I =
{
  file   = "hall/trim1_i_win.wad"
  shape  = "I"
  group  = "trim"
}

DOOM.SKINS.Hall_Basic_C =
{
  file   = "hall/trim1_c.wad"
  shape  = "C"
  group  = "trim"
}

DOOM.SKINS.Hall_Basic_T =
{
  file   = "hall/trim1_t_lit.wad"
  shape  = "T"
  group  = "trim"
}

DOOM.SKINS.Hall_Basic_P =
{
  file   = "hall/trim1_p.wad"
  shape  = "P"
  group  = "trim"
}

DOOM.SKINS.Hall_Basic_I_Stair =
{
  file   = "hall/trim1_st.wad"
  shape  = "IS"

  group  = "trim"

--[[
  step = "STEP3"
  support = "SUPPORT2"
  support_ox = 24
--]]
}

DOOM.SKINS.Hall_Basic_I_Lift =
{
  file   = "hall/trim1_lf.wad"
  shape  = "IL"
  group  = "trim"
  tags   = 1

--[[
  lift = "SUPPORT3"
  top  = { STEP_F1=50, STEP_F2=50 }

  raise_W1 = 130
  lower_WR = 88  -- 120
  lower_SR = 62  -- 123
--]]
}

