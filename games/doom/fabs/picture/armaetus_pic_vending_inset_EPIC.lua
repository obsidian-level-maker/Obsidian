PREFABS.Pic_inset_vending_machines =
{
  file = "picture/armaetus_pic_vending_inset_EPIC.wad",
  map = "MAP01",

  prob = 15,

  env = "building",
  theme = "!hell",

  texture_pack = "armaetus",

  where  = "seeds",

  height = 128,

  deep = 16,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_OBVNMCH1 =
  {
    OBVNMCH1 = 50,
    OBVNMCH2 = 50,
    OBVNMCH3 = 50,
    OBVNMCH4 = 50,
    OBVNMCH5 = 50,
  },

  tex_OBVNMCH2 =
  {
    OBVNMCH1 = 50,
    OBVNMCH2 = 50,
    OBVNMCH3 = 50,
    OBVNMCH4 = 50,
    OBVNMCH5 = 50,
  },

  x_fit = "frame",
  y_fit = "top"

  --sound = "Vending_Machine_Hum", -- Needs ambient sound thing applied!
}

PREFABS.Pic_inset_vending_machines_w_chair =
{
  template = "Pic_inset_vending_machines",
  map = "MAP02"
}
