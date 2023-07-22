
PREFABS.Cage_armaetus_scenic_outdoors1 =
{
  file   = "cage/armaetus_cage_scenic_outdoors.wad",
  map = "MAP01",

  theme = "hell",

  prob  = 250,

  liquid = true,

  where  = "seeds",
  shape  = "U",
  env = "building",

  height = 128,

  seed_w = 2,
  seed_h = 2,

  x_fit = "stretch",
  y_fit = "top",

  tex_SP_ROCK1 = {
    SP_ROCK1=50, ROCKRED1=50, ROCK5=50,
    ZIMMER1=50, ZIMMER2=50,
    ZIMMER3=50, ZIMMER4=50, ZIMMER5=50,
    ZIMMER7=50, ZIMMER8=50
    },
}

PREFABS.Cage_armaetus_scenic_outdoors2 =
{
  template = "Cage_armaetus_scenic_outdoors1",
  map = "MAP02",
}

PREFABS.Cage_armaetus_scenic_outdoors3 =
{
  template = "Cage_armaetus_scenic_outdoors1",
  map = "MAP03",
}
