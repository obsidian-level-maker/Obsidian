-- quake-inspired floating portal using 3D floors and epic textures

PREFABS.Teleporter_scionox_quakeish_portal =
{
  file   = "teleporter/scionox_quakeish_portal.wad",
  map    = "MAP01",
  prob   = 10,

  theme  = "tech",
  where  = "seeds",
  engine = "zdoom",
  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  tex_CGCANI00 = { CGCANI00=50, COMPWERD=50, SPACEW3=50, COMPCT01=50, COMPCT02=50, COMPCT03=50, CONSOLE6=50, CONSOLE7=50, CONSOLE8=50, NOISE1=50 },

  sound = "Demonic_Teleporter",
}
PREFABS.Teleporter_scionox_quakeish_portal_2 =
{
  template = "Teleporter_scionox_quakeish_portal",

  tex_TEKWALLA = "TEKWALL8",
  tex_PURFAL1 = "BFAL1",
  flat_TEK3 = "TEK1",
}
PREFABS.Teleporter_scionox_quakeish_portal_3 =
{
  template = "Teleporter_scionox_quakeish_portal",

  tex_TEKWALLA = "TEKWALL9",
  tex_PURFAL1 = "NFALL1",
  flat_TEK3 = "TEK2",
}
PREFABS.Teleporter_scionox_quakeish_portal_4 =
{
  template = "Teleporter_scionox_quakeish_portal",

  tex_TEKWALLA = "TEKWALLB",
  tex_PURFAL1 = "WFALL1",
  flat_TEK3 = "TEK4",
}
PREFABS.Teleporter_scionox_quakeish_portal_5 =
{
  template = "Teleporter_scionox_quakeish_portal",

  tex_TEKWALLA = "TEKWALLE",
  tex_PURFAL1 = "LFALL1",
  flat_TEK3 = "TEK7",
}

PREFABS.Teleporter_scionox_quakeish_portal_6 =
{
  template = "Teleporter_scionox_quakeish_portal",
  prob   = 50,
  theme  = "urban",

  tex_CGCANI00 = { BLIT01=50, BLIT02=50, PANBOOK2=50, PANBOOK3=50, PANBOOK=50, PANBLACK=50, PANBLUE=50, PANRED=50, PANEL5=50, SPDUDE7=50, SPDUDE8=50, WOOD4=50, WOODGARG=50 },
  tex_TEKWALLA = "GOTH27",
  tex_PURFAL1 = "MFALL1",
  tex_SHAWN01E = "METL03",
  tex_WARNSTEP = "CRATINY",
  flat_TEK3 = "GRATE8",
  flat_SHINY01 = "GRATE8",
  flat_WARN1 = "CRATOP1",
}

PREFABS.Teleporter_scionox_quakeish_portal_7 =
{
  template = "Teleporter_scionox_quakeish_portal",
  prob   = 40,
  theme  = "hell",

  tex_CGCANI00 = { MARBFAB1=50, MARBFAB2=50, MARBFAB3=50, MARBFAC5=50, MARBFAC6=50, MARBFAC7=50, MARBFAC8=50, MARBFAC9=50, MARBFACA=50, MARBFACB=50, MARBFACF=50, SP_DUDE1=50, SP_DUDE2=50, GLASS1=50, GLASS2=50, GLASS3=50, GLASS4=50, GLASS5=50, GLASS6=50, SKINHEAD=50 },
  tex_TEKWALLA = "RDWAL01",
  tex_PURFAL1 = "MFALL1",
  tex_SHAWN01E = "RDWAL01",
  tex_WARNSTEP = "REDMARB1",
  flat_TEK3 = "FLOOR1_6",
  flat_SHINY01 = "FLOOR1_6",
  flat_WARN1 = "RMARB3",

  thing_86 = "candelabra",
}
PREFABS.Teleporter_scionox_quakeish_portal_8 =
{
  template = "Teleporter_scionox_quakeish_portal",
  prob   = 10,
  theme  = "hell",

  tex_CGCANI00 = { MARBFAB1=50, MARBFAB2=50, MARBFAB3=50, MARBFAC5=50, MARBFAC6=50, MARBFAC7=50, MARBFAC8=50, MARBFAC9=50, MARBFACA=50, MARBFACB=50, MARBFACF=50, SP_DUDE1=50, SP_DUDE2=50, GLASS1=50, GLASS2=50, GLASS3=50, GLASS4=50, GLASS5=50, GLASS6=50, SKINHEAD=50 },
  tex_TEKWALLA = "FIREBLU1",
  tex_PURFAL1 = "FIREBLK1",
  tex_SHAWN01E = "RDWAL01",
  tex_WARNSTEP = "REDMARB1",
  flat_TEK3 = "FIRELAF1",
  flat_SHINY01 = "FLOOR1_6",
  flat_WARN1 = "RMARB3",

  thing_86 = "evil_eye",
}
