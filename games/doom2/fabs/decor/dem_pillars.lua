--
-- A huge pillar with a secret inside of it
--

PREFABS.Dem_Pillars_tech3 =
{
  file   = "decor/dem_pillars.wad",
  map    = "MAP01",

  prob   = 3000,
  theme  = "tech",
  env    = "building",

  where  = "point",
  size   = 200,
  height = 192,

  bound_z1 = 0,
  bound_z2 = 192,

  z_fit  = { 80,112 },

  sink_mode = "never_liquids",

  style = "secrets",

  thing_2013 =
  {
   green_armor = 5,
   backpack = 2,
   allmap = 2,
   berserk = 2,
   cell_pack = 5,
   soul = 1,
  }

}

PREFABS.Dem_Pillars_tech2 =
{
  template  = "Dem_Pillars_tech3",
  theme  = "tech",
  prob   = 800,
  tex_SILVER2 = { TEKWALL1=50, TEKWALL4=50, TEKLITE=50 }
}

PREFABS.Dem_Pillars_hell1 =
{
  template  = "Dem_Pillars_tech3",
  theme  = "hell",
  prob   = 800,
  tex_SILVER2 = "FIREBLU1",
  tex_COMPSPAN = "METAL",
  flat_CEIL5_1 = "CEIL5_2",
}

PREFABS.Dem_Pillars_hell2 =
{
  template  = "Dem_Pillars_tech3",
  theme  = "hell",
  tex_SILVER2 = { SLOPPY1=50, SP_FACE2=50 },
  tex_COMPSPAN = "SP_HOT1",
  flat_CEIL5_1 = "FLAT5_3",
}

PREFABS.Dem_Pillars_urban1 =
{
  template  = "Dem_Pillars_tech3",
  theme  = "urban",
  prob   = 800,
  tex_SILVER2 = "MODWALL1",
  tex_COMPSPAN = "BRICK4",
  flat_CEIL5_1 = "CEIL3_2",
}
