--
-- Simple trap
--

PREFABS.Trap_simple1 =
{
  file   = "misc/trap1.wad",
  map    = "MAP01",

  nolimit_compat = true,

  prob   = 50,
  kind   = "trap",
  where  = "seeds",
  shape  = "U",

  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = { 40,88 },
  y_fit = "stretch",

  bound_z1 = 0,
  bound_z2 = 160,

  tag_1 = "?trap_tag",
}

