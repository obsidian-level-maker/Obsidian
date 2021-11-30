-- square windows

PREFABS.Cage_windowed_rooms_square =
{
  file   = "cage/cage_windowed_rooms.wad",
  map   = "MAP01",

  prob  = 1000,
  skip_prob = 66,

  where  = "seeds",
  shape  = "U",

  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep   =  16,

  x_fit = { 24,72 , 104,152 , 184,232 },
  y_fit = { 36,44 },
}

-- barred windows

PREFABS.Cage_windowed_rooms_barred =
{
  template = "Cage_windowed_rooms_square",
  map = "MAP02",

  prob = 150,

  x_fit = "frame",
}

PREFABS.Cage_windowed_rooms_barred_wide =
{
  template = "Cage_windowed_rooms_square",
  map = "MAP03",

  prob = 250,

  x_fit = "frame",

  seed_w = 3,
}

-- open windows with MIDBARS

PREFABS.Cage_windowed_rooms_open =
{
  template = "Cage_windowed_rooms_square",
  map = "MAP04",

  x_fit = {24,232},
}
