--
-- Pictures
--

---- TECH ----

PREFABS.Pic_computer1 =
{
  file   = "wall/pic_128x48.wad"
  where  = "edge"
  long   = 192
  deep   = 16

  x_fit  = "frame"
  y_fit  = "top"
  z_fit  = "top"

  bound_z1 = 0
  bound_z2 = 112

  theme = "tech"
  prob  = 30

  tex_COMPSTA1 = { COMPSTA1=50, COMPSTA2=50 }

--[[
  pic   = { COMPSTA1=50, COMPSTA2=50 }
  pic_w = 128
  pic_h = 48

  light = 48
  effect = { [0]=90, [1]=5 }  -- sometimes blink
  fx_delta = -47
--]]
}

