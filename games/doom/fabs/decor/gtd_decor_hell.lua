PREFABS.Decor_triple_bone_thing =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP01",

  prob   = 5000,
  theme  = "!tech",

  where  = "point",
  size   = 64,
  height = 168,

  bound_z1 = 0,
  bound_z2 = 168,

  z_fit  = "top",
}

PREFABS.Decor_blood_drip_pool =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP02",

  prob   = 5000,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  thing_76 =
  { gutted_victim1 = 50,
    gutted_victim2 = 50,
    gutted_torso1  = 50,
    gutted_torso2  = 50,
    gutted_torso3  = 50,
    gutted_torso4  = 50,
    hang_arm_pair  = 50,
    hang_leg_gone = 50,
    hang_twitching = 50,
  },

  z_fit  = "top",
}

PREFABS.Decor_cage_n_corpses =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP03",

  prob   = 5000,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 176,

  bound_z1 = 0,
  bound_z2 = 176,

  thing_25 =
  {
   impaled_human = 50,
   impaled_twitch = 50,
  },
  z_fit  = { 112+8,112+16 }
}

PREFABS.Decor_hell_gazebo =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP04",

  prob   = 5000,
  theme  = "hell",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = top,

  sink_mode = "never",
}

PREFABS.Decor_blood_filling_casket =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP05",

  prob   = 5000,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 168,

  bound_z1 = 0,
  bound_z2 = 168,

  z_fit  = { 40+16,40+32 }
}

PREFABS.Decor_vaulted_pillar =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP06",

  prob   = 5000,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = { 16+16,16+32 }
}

PREFABS.Decor_pentagram_pedestal =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP07",

  prob   = 5000,
  theme  = "!tech",

  where  = "point",
  size   = 64,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Decor_pool_of_guts =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP08",

  prob   = 5000,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 80,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Decor_candle_altar =
{
  file   = "decor/gtd_decor_hell.wad",
  map    = "MAP09",

  prob   = 5000,
  theme  = "hell",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,
}
