--
-- Hallway with a trim
--

DOOM.SKINS.Hall_trim1_I =
{
  file   = "hall/trim1_i_win.wad"
  group  = "hall_trim"
  shape  = "I"
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

DOOM.SKINS.Hall_trim1_I_Stair =
{
  file   = "hall/trim1_st.wad"
  group  = "hall_trim"
  shape  = "IS"

  north  = { h=64 }

--[[
  step = "STEP3"
  support = "SUPPORT2"
  support_ox = 24
--]]
}

DOOM.SKINS.Hall_trim1_I_Lift =
{
  file   = "hall/trim1_lf.wad"
  group  = "hall_trim"
  shape  = "IL"
  tags   = 1

--[[
  lift = "SUPPORT3"
  top  = { STEP_F1=50, STEP_F2=50 }

  raise_W1 = 130
  lower_WR = 88  -- 120
  lower_SR = 62  -- 123
--]]
}


--
-- Group for these hallway pieces
--

DOOM.GROUPS.hall_trim =
{
  kind = "hall"
}

