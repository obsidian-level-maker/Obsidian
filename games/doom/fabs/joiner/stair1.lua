--
-- Joiner with stairs
--

PREFABS.Joiner_stair1 =
{
  file   = "joiner/stair1.wad",

  prob   = 60,
  theme  = "!tech",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "stretch",

  delta_h  = 48,
  nearby_h = 160,
  can_flip = true,
}

PREFABS.Joiner_stair2 =
{
  template   = "Joiner_stair1",
  theme      = "!tech",

  tex_ICKWALL3 = { WOOD1=50, WOOD3=50, WOOD5=50, WOODVERT=50, WOOD12=50 },
  flat_FLAT1 = { FLAT5_1=50, FLAT5_2=50 },
 }


PREFABS.Joiner_stair3 =
{
  template   = "Joiner_stair1",
  theme      = "tech",
  env        = "indoor",

  tex_ICKWALL3 = { SHAWN2=100, SUPPORT2=20 },
  flat_FLAT1 = { FLAT23=100, FLAT20=15 },
 }

PREFABS.Joiner_stair4 =
{
  template   = "Joiner_stair1",
  theme      = "tech",
  env        = "indoor",

  tex_ICKWALL3 = { TEKWALL1=50, TEKWALL4=50 },
  flat_FLAT1 = "CEIL5_1",
 }

PREFABS.Joiner_stair5 =
{
  template   = "Joiner_stair1",
  theme      = "tech",
  env        = "indoor",

  tex_ICKWALL3 = "COMPBLUE",
  flat_FLAT1 = { FLAT14=50, CEIL4_1=50, CEIL4_2=50 },
 }

PREFABS.Joiner_stair6 =
{
  template   = "Joiner_stair1",
  theme      = "tech",
  env        = "indoor",

  tex_ICKWALL3 = "COMPSPAN",
  flat_FLAT1 = "CEIL5_1",
 }

PREFABS.Joiner_stair7 =
{
  template   = "Joiner_stair1",
  theme      = "hell",

  tex_ICKWALL3 = { SKIN2=100, SKINFACE=50 },
  flat_FLAT1 = "SFLR6_4",
 }

PREFABS.Joiner_stair8 =
{
  template   = "Joiner_stair1",
  theme      = "!tech",

  tex_ICKWALL3 = { METAL=50, SUPPORT3=50 },
  flat_FLAT1 = "CEIL5_2",
 }

PREFABS.Joiner_stair9 =
{
  template   = "Joiner_stair1",
  theme      = "hell",

  tex_ICKWALL3 = "ASHWALL2",
  flat_FLAT1 = "FLOOR6_2",
 }

PREFABS.Joiner_stair10 =
{
  template   = "Joiner_stair1",
  theme      = "hell",

  tex_ICKWALL3 = { ASHWALL3=50, ASHWALL4=50, BROWNHUG=10 },
  flat_FLAT1 = "FLAT10",
 }

PREFABS.Joiner_stair11 =
{
  template   = "Joiner_stair1",
  theme      = "urban",

  tex_ICKWALL3 = { BLAKWAL1=50, BLAKWAL2=50 },
  flat_FLAT1 = "CEIL5_1",
 }
