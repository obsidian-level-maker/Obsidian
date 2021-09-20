--
-- Wall niche w/ torches, Heretic only for now but additional games may have appropriate things for this - Dasho
--

PREFABS.Pic_wall_torch1 =
{
  file   = "picture/wall_torch.wad",
  map    = "MAP01",

  prob  = 100,
  skip_prob = 35,
  env   = "building",
  game  = "heretic",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  height = 128,
  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",
}


PREFABS.Pic_wall_torch2 =
{
  template = "Pic_wall_torch1",
  map      = "MAP02",

  prob  = 70,
}


PREFABS.Pic_wall_torch3 =
{
  template = "Pic_wall_torch1",
  map      = "MAP03",

  prob  = 40,
}

