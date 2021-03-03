--
--  Secret item niche
--

-- the hint here is misaligned texture
PREFABS.Item_secret_niche1 =
{
  file  = "item/secret_niche.wad",
  map   = "MAP01",

  theme = "tech",
  prob  = 25,
  key   = "secret",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  tex_TEKWALL4 = { TEKWALL4=50, METAL2=50, COMPBLUE=50, COMPSPAN=50, BRONZE1=50, METAL1=50, SHAWN2=50, SPACEW4=50, STARG1=50, STARGR1=50, STONE2=50, STONE3=50, STONE4=50 }
}

PREFABS.Item_secret_niche1_urban =
{
  template  = "Item_secret_niche1",
  map      = "MAP01",

  theme = "urban",

  tex_TEKWALL4 = { BROWNHUG=50, BIGBRIK1=50, BIGBRIK2=50, BLAKWAL2=50, BRICK4=50, BRICK5=50, CEMENT9=50, METAL1=50, METAL2=50, MODWALL1=50, MODWALL3=50, STONE2=50, STONE3=50 }
}

PREFABS.Item_secret_niche1_hell =
{
  template  = "Item_secret_niche1",
  map      = "MAP01",

  theme = "hell",

  tex_TEKWALL4 = { BROWNHUG=50, ASHWALL2=50, ASHWALL4=50, ASHWALL7=50, FIREBLU1=50, GRAYVINE=50, GSTONE1=50, GSTVINE1=50, GSTVINE2=50, SP_HOT1=50, METAL=50, SKIN2=50, SKINFACE=50, STONE6=50 }
}


-- this one uses a hint object (usually)
PREFABS.Item_secret_niche2 =
{
  file  = "item/secret_niche.wad",
  map      = "MAP02",
  theme = "tech",

  prob = 100,

  thing_34 =
  {
    nothing = 50,
    pool_blood_1 = 30,
    pool_blood_2 = 30,
    pool_brains = 8,
    gibbed_player = 10,
    dead_player = 10,
    barrel = 20,
  },

  tex_TEKWALL4 = { TEKWALL4=50, METAL2=50, COMPBLUE=50, COMPSPAN=50, BRONZE1=50, METAL1=50, SHAWN2=50, SPACEW4=50, STARG1=50, STARGR1=50, STONE2=50, STONE3=50, STONE4=50 },

  -- prevent monsters stuck in a barrel
  solid_ents = true,
}

PREFABS.Item_secret_niche2_urban =
{
  template  = "Item_secret_niche2",

  map      = "MAP02",
  theme = "urban",

  thing_34 =
  {
    nothing = 50,
    pool_blood_1 = 30,
    pool_blood_2 = 30,
    pool_brains = 10,
    gibbed_player = 10,
    dead_player = 10,
    barrel = 15,
    candle = 15,
  },

  tex_TEKWALL4 = { BROWNHUG=50, BIGBRIK1=50, BIGBRIK2=50, BLAKWAL2=50, BRICK4=50, BRICK5=50, CEMENT9=50, METAL1=50, METAL2=50, MODWALL1=50, MODWALL3=50, STONE2=50, STONE3=50 }
}

PREFABS.Item_secret_niche2_hell =
{
  template  = "Item_secret_niche2",

  map      = "MAP02",
  theme = "hell",

  thing_34 =
  {
    nothing = 50,
    pool_blood_1 = 30,
    pool_blood_2 = 30,
    pool_brains = 10,
    gibbed_player = 10,
    dead_player = 10,
    barrel = 5,
    candle = 25,
  },

  tex_TEKWALL4 = { BROWNHUG=50, ASHWALL2=50, ASHWALL4=50, ASHWALL7=50, FIREBLU1=50, GRAYVINE=50, GSTONE1=50, GSTVINE1=50, GSTVINE2=50, SP_HOT1=50, METAL=50, SKIN2=50, SKINFACE=50, STONE6=50 }
}
