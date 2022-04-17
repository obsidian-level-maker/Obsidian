--One of the cpu chip is defective, shoot it to open the core! V1,
PREFABS.Item_secret_techmachine1V1_closet =
{
  file  = "item/dem_secret_closets_tech.wad",
  map   = "MAP09",
  engine = "zdoom",

  theme = "tech",
  env = "!nature",

  prob  = 15,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  can_flip = true,

  texture_pack = "armaetus",

}

--One of the cpu chip is defective, shoot it to open the core! V2,
PREFABS.Item_secret_techmachine1V2_closet =
{
  template = "Item_secret_techmachine1V1_closet",
  map   = "MAP10",
}
