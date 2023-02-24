-- square windows

PREFABS.Cage_wall_windowed_rooms_square =
{
  file   = "cage/gtd_cage_windowed_rooms.wad",
  map   = "MAP01",

  prob  = 1000,
  skip_prob = 66,

  theme  = "tech",

  where  = "seeds",
  shape  = "U",

  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep   =  16,

  x_fit = { 24,72 , 104,152 , 184,232 },
  y_fit = { 36,44 },

  flat_FLAT5_2 = "FLAT20",

  tex_METAL5 = "DOORSTOP",
}

PREFABS.Cage_wall_windowed_rooms_square_gothic =
{
  template = "Cage_wall_windowed_rooms_square",

  theme    = "!tech",

  flat_FLAT5_2 = "FLAT5_2",

  tex_DOOR1 = "WOODMET1",
  tex_METAL5 = "METAL5",
}

-- barred windows

PREFABS.Cage_wall_windowed_rooms_barred =
{
  template = "Cage_wall_windowed_rooms_square",
  map = "MAP02",

  prob = 150,

  x_fit = "frame",

  flat_FLAT5_2 = "FLAT20",

  tex_SUPPORT3 = "SHAWN2",
  tex_METAL5 = "DOORSTOP",
}

PREFABS.Cage_wall_windowed_rooms_barred_gothic =
{
  template = "Cage_wall_windowed_rooms_square",
  map = "MAP02",

  prob = 150,

  theme = "!tech",
  tex_DOOR1 = "WOODMET1",

  x_fit = "frame",

  flat_FLAT5_2 = "FLAT5_2",

  tex_METAL5 = "METAL5",
}

PREFABS.Cage_wall_windowed_rooms_barred_wide =
{
  template = "Cage_wall_windowed_rooms_square",
  map = "MAP03",

  prob = 250,

  x_fit = "frame",

  seed_w = 3,

  flat_FLAT5_2 = "FLAT20",

  tex_SUPPORT3 = "SHAWN2",
  tex_METAL5 = "DOORSTOP",
}

PREFABS.Cage_wall_windowed_rooms_barred_wide_hell =
{
  template = "Cage_wall_windowed_rooms_square",
  map = "MAP03",

  prob = 250,

  theme = "hell",
  tex_DOOR1 = "WOODMET1",

  seed_w = 3,

  x_fit = "frame",

  flat_FLAT5_2 = "FLAT5_2",

  tex_METAL5 = "METAL5",
}

-- open windows with MIDBARS

PREFABS.Cage_wall_windowed_rooms_open =
{
  template = "Cage_wall_windowed_rooms_square",
  map = "MAP04",

  x_fit = {24,232},

  flat_FLAT5_2 = "FLAT5_2",

  tex_METAL5 = "METAL5",
}

PREFABS.Cage_wall_windowed_rooms_open_hell =
{
  template = "Cage_wall_windowed_rooms_square",
  map = "MAP04",

  theme = "hell",

  flat_FLAT5_2 = "FLAT5_2",

  tex_DOOR1 = "WOODMET1",
  tex_METAL5 = "METAL5",

  x_fit = {24,232}
}
