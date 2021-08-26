-- TO-DO: Needs redesigning such that monsters are not left stuck inside the bunker.
-- Switches also need to be redesigned such that it's impossible to fail triggering all lines.

--[[PREFABS.Cage_secret_trap_shootable_eye =
{
  file   = "cage/mogwaltz_trap_eye.wad",
  map    = "MAP01",

  prob   = 18,

  style  = "traps",

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = { 64,96 },

  -- prevent monsters stuck in a barrel
  solid_ents = true,
}

PREFABS.Cage_secret_trap_shootable_eye_pair =
{
  template = "Cage_secret_trap_shootable_eye",
  map = "MAP02",

  prob = 18,
}]]
