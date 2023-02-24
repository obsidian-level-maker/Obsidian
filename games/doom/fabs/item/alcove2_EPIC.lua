--
--  Medium techy alcove for keys EPIC
--

PREFABS.Item_alcove_techy_epic =
{
  file   = "item/alcove2_EPIC.wad",
  map    = "MAP01",

  rank   = 2,
  prob   = 200,
  theme  = "tech",
  env    = "!cave",

  replaces = "Item_alcove_techy",

  item_kind = "key",

  texture_pack = "armaetus",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",


  sector_12 =  { [0]=20, [8]=20, [12]=50, [13]=30, [21]=10 },

  tex_COMPTALL = { COMPTALL=40, TEKWALL4=20, TEKWALL8=30, TEKWALL9=30, TEKWALLA=30, TEKWALLB=30, TEKWALLC=30, TEKWALLD=30, TEKWALLE=30 },
  flat_FLOOR46D = { FLOOR46D=50, FLOOR46E=50, FLAT14=50, FLAT15=50, GRATE1=50, GRATE2=50, GRATE7=50, FLOOR4_8=50, FLOOR5_1=50 },
  flat_BLACK0 = { BLACK0=50, RROCK03=50 }

}

PREFABS.Item_alcove_hell_epic =
{
  template = "Item_alcove_techy_epic",
  theme = "hell",
  map   = "MAP02",

  replaces = "Item_alcove_hell",

   tex_FIREBLU1 = { FIREBLU1=10, FIREBLK1=10, LAVBLAK1=10, LAVBLUE1=60, LAVGREN1=60, FIRELAVA=60, LAVWHIT1=10 },
   tex_GOTH32 = { GOTH32=50, HELMET1=50, HELMET2=50, METAL=20, SUPPORT3=20, GOTH41=20, METL02=20, METL03=20 },
   tex_STONE8 = { STONE8=50, STONE9=50 },
   flat_FLAT5_2 = { FLAT5_2=50, FLAT5_1=50, WOODTIL=50, WOODTI2=50 },
   flat_GRATE8 = { GRATE8=50, BMARB3=50, G12=50, GMET02=50, GMET03=50, GMET04=50, GMET05=50 },

   sector_12 = { [0]=20, [17]=60 }

}

PREFABS.Item_alcove_urban_epic =
{
  template = "Item_alcove_techy_epic",
  theme = "urban",
  map = "MAP03",

  replaces = "Item_alcove_urban",

  tex_BRIKS16 = { BRIKS16=50, BRIKS24=50 },
  tex_EVILFAC2 = { EVILFAC2=50, EVILFAC4=50, EVILFAC5=50, EVILFAC6=50, EVILFAC7=20, EVILFAC8=20, EVILFAC9=20, EVILFACA=20 },
  flat_GSTN05 = { GSTN05=50, WOODTIL=50, WOODTI2=50, TILES2=50, TILES3=50 },

   sector_12 = { [0]=40, [8]=15, [17]=25 }

}
