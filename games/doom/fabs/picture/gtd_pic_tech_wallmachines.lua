PREFABS.Pic_techy_vats =
{
  file   = "picture/gtd_pic_tech_wallmachines.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "!hell",

  env = "!cave",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  tex_COMPBLUE =
  {
    COMPBLUE = 50,
    REDWALL = 50,
  },

  sound = "Machine_Air",
}

PREFABS.Pic_pipagery =
{
  template = "Pic_techy_vats",
  map    = "MAP02",

  sound = "Machine_Air",

  z_fit = {96,104},
}

PREFABS.Pic_computer_pull_rack_thingies =
{
  file   = "picture/gtd_pic_tech_wallmachines.wad",
  map    = "MAP03",

  prob   = 25,
  theme = "tech",
  env = "building",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Pic_computer_charging_grid_thingies =
{
  template = "Pic_computer_pull_rack_thingies",
  map      = "MAP04",

  theme  = "!hell",

  seed_w = 3,
}

PREFABS.Pic_conveyor_with_boxes =
{
  template = "Pic_computer_pull_rack_thingies",
  map      = "MAP05",

  theme = "!hell",

  seed_w = 3,
}

PREFABS.Pic_pipagery_2 =
{
  template = "Pic_techy_vats",
  map    = "MAP06",

  sound = "Machine_Air",

  z_fit = {96,104},
}

PREFABS.Pic_pipagery_3 =
{
  template = "Pic_techy_vats",
  map = "MAP07",

  sound = "Machine_Air",

  x_fit = { 176,208 },
  z_fit = { 104,112 },
}
