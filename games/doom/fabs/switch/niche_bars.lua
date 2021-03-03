--
--  Niche switch, blocked by raising bars
--

PREFABS.Switch_niche_bars =
{
  file   = "switch/niche_bars.wad",

  theme  = "tech",
  prob   = 100, --50,
  key    = "barred",

  where  = "seeds",

  seed_w = 1,
  seed_h = 1,

  tag_1 = "?switch_tag",
  tag_2 = "?door_tag",

  tex_SW1COMM = { SW1COMM=50, SW2COMM=50 },
  tex_METAL1 = { METAL1=50, METAL2=50, BRONZE1=50, BROWN96=50, BROWNGRN=50, BROWNHUG=50, GRAYVINE=50, SHAWN2=50, SILVER1=50,
                 STONE=50, STONE2=50, STONE3=50, TEKGREN2=50 },
  flat_CEIL4_3 = { CEIL4_1=50, CEIL4_2=50, CEIL4_3=50, CEIL5_1=50 },

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 },

}

