---a roulette where you can get one item outta 6,

PREFABS.Item_dem_gamble_closet1 =
{
  file  = "item/dem_item_gamble.wad",
  map   = "MAP01",

  engine = "zdoom",

  prob  = 80,

  filter = "gamble",

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  thing_2007 =
  {
    bullet_box = 5,
    saw = 2,
  },

  thing_2008 =
  {
    shell_box = 5,
    radsuit = 2,
  },

  thing_2010 =
  {
    rocket_box = 5,
    green_armor = 1,
  },

  thing_2015 =
  {
    backpack = 1,
    stimpack = 5,
  },

  thing_2014 =
  {
    cell_pack = 2,
    medikit = 5,
  },

  thing_2011  =
  {
    invis = 5,
    allmap = 2,
  }
}

---Choose one of 3, the others will get crushed

PREFABS.Item_dem_gamble_closet2 =
{
  template = "Item_dem_gamble_closet1",
  map = "MAP02",

  theme = "!tech",

  thing_2007 =
  {
   berserk = 1,
   invis = 5,
   allmap = 2,
   goggles = 5,
  },

  thing_2008 =
  {
   bullet_box = 5,
   shell_box = 5,
   rocket_box = 2,
   cell_pack = 1,
  },

  thing_2010 =
  {
   green_armor = 2,
   backpack = 1,
   stimpack = 5,
   medikit = 5,
  }
}

PREFABS.Item_dem_gamble_closet2_tech =
{
  template = "Item_dem_gamble_closet1",
  map = "MAP03",

  theme = "tech",

  thing_2007 =
  {
   berserk = 1,
   invis = 5,
   allmap = 2,
   goggles = 5,
  },

  thing_2008 =
  {
   bullet_box = 5,
   shell_box = 5,
   rocket_box = 2,
   cell_pack = 1,
  },

  thing_2010 =
  {
   green_armor = 2,
   backpack = 1,
   stimpack = 5,
   medikit = 5,
  }
}
