--
-- basic stair, 64 units high
--

-- Fixed by Chris, allows most monsters (except Demons/Spectres) to traverse
-- without piling on top or bottom of staircase edges. Silly Doom port!

-- For AJ, see comments below.

-- OBSERVATIONS BY CHRIS, JUNE 28TH, 2017:
-- Somehow it has to do with the stair width between steps, the longer steps used
-- on many of the other prefabs seem to be at least 24 units apart, like the prefab
-- with the short steps and light/torch and curved sets of stairs (curve1.lua) as they
-- (Demons/Spectres) don't have problems traversing up and down them.

-- Might have to alter the actual prefab so it is longer and has 8 unit steps instead
-- of 16.

PREFABS.Stair_64 =
{
  file   = "stairs/stair.wad",

  map   = "MAP01",
  prob  = 0,
  prob_skew = 3,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,

  x_fit  = "stretch",

  bound_z1 = 0,

  delta_h = 64,
}