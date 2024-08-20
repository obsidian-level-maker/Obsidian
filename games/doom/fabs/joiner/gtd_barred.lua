PREFABS.Joiner_gtd_barred1 =
{
  file   = "joiner/gtd_barred.wad",
  map    = "MAP01",
  where  = "seeds",
  shape  = "I",

  key    = "barred",

  prob   = 50,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = {28,52 , 88,96 , 124,132, 160,168, 204,228},
  y_fit  = {24,32 , 128,136},

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_gtd_barred2 =
{
  template = "Joiner_gtd_barred1",
  map = "MAP02",

  x_fit = {32,40 , 62,72 , 124,132 , 184,192 , 216,224}
}
