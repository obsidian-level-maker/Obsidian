PREFABS.Decor_in_wall_vending_machines =
{
  file   = "wall/armaetus_EPIC_wallvending.wad",
  map    = "MAP01",

  prob   = 10,
  theme  = "!hell",
  env = "!outdoor",
  group  = "wall_vending", -- Needs group in themes.lua files

  texture_pack = "armaetus",

  on_liquids = "never",

  where  = "edge",

  deep   = 64,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 256,

  tex_OBVNMCH1 =
  {
    OBVNMCH1 = 50,
    OBVNMCH2 = 50,
    OBVNMCH3 = 50,
    OBVNMCH4 = 50,
    OBVNMCH5 = 50,
  },

  z_fit = "top",

  --sound = "Vending_Machine_Hum", -- Needs ambient sound thing applied!

}