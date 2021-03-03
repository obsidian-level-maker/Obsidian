PREFABS.Joiner_secret_secret_shootable_eye =
{
  file   = "joiner/mogwaltz_secret_eye.wad",
  map    = "MAP01",

  prob   = 37,

  key    = "secret",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 64,96 },

  -- prevent monsters stuck in a barrel
  solid_ents = true,
}

--[[PREFABS.Joiner_secret_secret_shootable_eye_pick_one =
{
  template = "Joiner_secret_secret_shootable_eye",
  map = "MAP02",

  prob = 18,
}

PREFABS.Joiner_secret_secret_shootable_eye_pick_one_b =
{
  template = "Joiner_secret_secret_shootable_eye",
  map = "MAP03",

  prob = 18,
}]]

PREFABS.Joiner_secret_secret_shootable_eye_nodickmove =
{
  template = "Joiner_secret_secret_shootable_eye",
  map = "MAP04",

  prob = 18,

  y_fit = { 128,140 },
}

PREFABS.Joiner_secret_secret_shootable_eye_nodickmove_b =
{
  template = "Joiner_secret_secret_shootable_eye",
  map = "MAP05",

  prob = 18,

  y_fit = { 128,140 },
}
