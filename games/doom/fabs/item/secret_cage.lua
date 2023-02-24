--
--  Secret item masquerading as a cage
--

PREFABS.Item_secret_cage =
{
  file  = "item/secret_cage.wad",
  where = "seeds",

  prob  = 200,
  skip_prob = 50,

  env   = "building",
  theme = "tech",

  key   = "secret",

  seed_w = 2,
  seed_h = 2,
  height = 168,

  deep =  16,
  over = -16,

  x_fit = "frame",
  z_fit = { 136, 160 },

  tex_COMPBLUE = { COMPBLUE=50, METAL1=50, BROWNGRN=50, BROWN144=50, BROWN96=50, ICKWALL1=50, ICKWALL2=50, ICKWALL3=50, GRAY1=50, GRAY5=50,
                   GRAYBIG=50, GRAYTALL=50, TEKWALL6=50, METAL2=50 },
  tex_TEKWALL1 = { TEKWALL1=50, TEKWALL4=50 },
  tex_METAL1 = { COMPBLUE=50, METAL1=50, BROWNGRN=50, BROWN144=50, BROWN96=50, ICKWALL1=50, ICKWALL2=50, ICKWALL3=50, GRAY1=50, GRAY5=50,
                   GRAYBIG=50, GRAYTALL=50, TEKWALL6=50, METAL2=50 },
  flat_CEIL4_3 = { CEIL4_3=50, CEIL4_2=50, CEIL4_1=50, CEIL5_1=50 }

}

PREFABS.Item_secret_cage2 =
{
  template  = "Item_secret_cage",
  theme     = "urban",

  tex_COMPBLUE = { BIGBRIK1=50, BIGBRIK2=50, BRICK5=50, BRICK12=50, BRICK10=50, WOODMET1=50, ASHWALL6=50, ASHWALL7=50, WOOD5=50 },
  tex_METAL1 = { BIGBRIK1=50, BIGBRIK2=50, BRICK5=50, BRICK12=50, BRICK10=50, WOODMET1=50, ASHWALL6=50, ASHWALL7=50, WOOD5=50 },
  tex_TEKWALL1 = { TEKWALL1=50, TEKWALL4=50, METAL5=50 },
  flat_CEIL4_3 = { FLOOR7_1=50, FLOOR6_2=50 }

}


PREFABS.Item_secret_cage3 =
{
  template  = "Item_secret_cage",
  theme     = "hell",

  tex_COMPBLUE = { WOODMET1=50, ASHWALL6=50, ASHWALL7=50, WOOD1=50, WOOD3=50, WOOD5=50, SKIN2=50, SKINFACE=50, SKINCUT=50 },
  tex_METAL1 = { WOODMET1=50, ASHWALL6=50, ASHWALL7=50, WOOD1=50, WOOD3=50, WOOD5=50, SKIN2=50, SKINFACE=50, SKINCUT=50 },
  tex_TEKWALL1 = { TEKWALL1=50, TEKWALL4=50, METAL5=50, WOODMET2=50, SUPPORT3=50 },
  flat_CEIL4_3 = { FLOOR7_1=50, FLOOR6_2=50, FLOOR6_1=50, CEIL5_2=50, BLOOD1=50 }

}
