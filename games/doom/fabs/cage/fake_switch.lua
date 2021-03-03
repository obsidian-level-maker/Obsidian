--
-- Trap looking like a normal switch
--

PREFABS.Cage_fake_switch =
{
  file   = "cage/fake_switch.wad",

  prob   = 25,
  style  = "traps",

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  y_fit  = "top",

  bound_z1 = 0,

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=3, [13]=3 }

}

