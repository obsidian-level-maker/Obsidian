--Based on gtd_pic_tech_controlroom

PREFABS.Item_control_room_sideways_double_secret =
{
  file   = "item/scionox_secrets_tech2.wad",
  map = "MAP08",
  
  prob   = 25,
  
  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  theme = "tech",

  env = "building",

  sector_1  = { [0]=70, [1]=20, [2]=5, [3]=5, [8]=10 },

  sound = "Computer_Station",
}

PREFABS.Item_control_room_sideways_single_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP09",
  
  seed_w = 2,
  seed_h = 2,

  sector_1  = { [0]=70, [1]=20, [2]=5, [3]=5, [8]=10 },

  sound = "Computer_Station",
}

PREFABS.Item_control_room_infested_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP10",
  
  seed_h = 2,
  
  sector_1 = 1,

  sound = "Computer_Station",
}

--Based on gtd_pic_tech_wallmachines
PREFABS.Item_pipagery_2_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map    = "MAP01",
  
  theme = "!hell",

  env = "!nature",
  
  sector_1 = 1,

  sound = "Machine_Air",
  
  z_fit = {98,104},
}

PREFABS.Item_pipagery_3_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP02",
  
  theme = "!hell",

  env = "!nature",
  
  sector_1 = 1,

  sound = "Machine_Air",

  x_fit = { 176,208 },
  z_fit = { 104,112 },
}

--Based on gtd_pic_tech_wallmachines_EPIC

PREFABS.Item_gtd_shaw_comp_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP03",
  theme = "tech",
  
  env = "!nature",
  
  sector_1 = 1,

  texture_pack = "armaetus",
  
  seed_w = 2,
  seed_h = 2,
}

PREFABS.Item_gtd_green_liquid_tank_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP04",
  theme = "tech",
  
  env = "!nature",
  
  sector_1 = 1,

  texture_pack = "armaetus",
  
  prob = 10,
  
  seed_w = 2,
}

PREFABS.Item_gtd_smelter_and_she_was_real_nice_this_is_not_creepy_at_all_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP05",
  theme = "tech",
  
  env = "!nature",
  
  sector_1 = 1,

  texture_pack = "armaetus",
  
  prob = 10,
  
  seed_w = 2,
}

PREFABS.Item_gtd_tech_heater_thing_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP06",
  theme = "tech",
  
  env = "!nature",
  
  sector_1 = 1,

  texture_pack = "armaetus",
  
  prob = 10,
  
  seed_w = 2,
}

PREFABS.Item_triple_glass_tube_i_dont_even_secret =
{
  template = "Item_control_room_sideways_double_secret",
  map = "MAP07",
  theme = "tech",
  
  jump_crouch = true,

  env = "!nature",
  
  sector_1 = 1,

  texture_pack = "armaetus",
  
  seed_w = 2,
  seed_h = 2,
}
