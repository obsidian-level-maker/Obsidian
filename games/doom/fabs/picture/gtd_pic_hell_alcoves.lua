PREFABS.Pic_hell_alcove_tomb =
{
  file   = "picture/gtd_pic_hell_alcoves.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "hell",

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
}

PREFABS.Pic_hell_alcove_furnace =
{
  template = "Pic_hell_alcove_tomb",
  map      = "MAP02",

  -- FIRELAV2 is a static texture and not animated, I fixed it for you.
  -- Also, FIREBLU1 is sometimes used here to mix it up.
  tex_FIRELAV2 = { FIRELAVA=50, FIREBLU1=50 },

  -- These vary the bodies seen inside the prefab
   thing_78 = {
   gutted_torso4 = 50,
   gutted_torso3 = 50,
   gutted_torso2 = 50,
   gutted_torso1 = 50,
   },

   thing_76 = {
   gutted_torso4 = 50,
   gutted_torso3 = 50,
   gutted_torso2 = 50,
   gutted_torso1 = 50,
   },

   thing_59 = {
   hang_arm_pair = 50,
   hang_arm_gone = 50,
   hang_twitching = 50,
   gutted_victim1 = 50,
   gutted_victim2 = 50,
   },

   thing_73 = {
   hang_arm_pair = 50,
   hang_arm_gone = 50,
   hang_twitching = 50,
   gutted_victim1 = 50,
   gutted_victim2 = 50,
   },
}

PREFABS.Pic_hell_alcove_window =
{
  template = "Pic_hell_alcove_tomb",
  map      = "MAP03",

  env = "!cave",
}

PREFABS.Pic_hell_alcove_tomb_2x =
{
  template = "Pic_hell_alcove_tomb",
  map      = "MAP04",
}

PREFABS.Pic_hell_alcove_blood_canal =
{
  template = "Pic_hell_alcove_tomb",
  map      = "MAP05",
}

PREFABS.Pic_hell_alcove_tomb_4x =
{
  template = "Pic_hell_alcove_tomb",
  map      = "MAP06",

  engine   = "zdoom",
}
