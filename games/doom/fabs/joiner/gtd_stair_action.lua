PREFABS.Joiner_unfolding_stairs =
{
  file   = "joiner/gtd_stair_action.wad",
  map    = "MAP01",

  prob   = 150,

  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  delta_h = 64,
  nearby_h = 128,

  x_fit = {60 , 68},
  y_fit = "frame",

  can_flip = true,
}

PREFABS.Joiner_unfolding_stairs_switchlocked =
{
  template = "Joiner_unfolding_stairs",
  map    = "MAP02",

  key    = "barred",

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}
