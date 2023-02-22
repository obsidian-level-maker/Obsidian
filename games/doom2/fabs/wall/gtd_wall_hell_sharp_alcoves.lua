-- pencil-shaped wall alcoves of sorts

-- red version

PREFABS.Wall_hell_sharp_alcoves_single_red = --#
{
  file   = "wall/gtd_wall_hell_sharp_alcoves.wad",
  map    = "MAP01",

  prob   = 50,
  skip_prob = 90.75,

  theme  = "hell",
  env = "building",

  where  = "edge",
  deep   = 20,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 32,40 },
}

PREFABS.Wall_hell_sharp_alcoves_double_red = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map      = "MAP02",
}

-- blue version

PREFABS.Wall_hell_sharp_alcoves_blue = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP01",

  tex_FIREMAG1 = "COMPBLUE",
  thing_46 = 44,
}

PREFABS.Wall_hell_sharp_alcoves_double_blue = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP02",

  tex_FIREMAG1 = "COMPBLUE",
  thing_46 = 44,
}

-- green version

PREFABS.Wall_hell_sharp_alcoves_green = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP01",

  tex_FIREMAG1 = "ZIMMER7",
  thing_46 = 45,
}

PREFABS.Wall_hell_sharp_alcoves_double_green = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP02",

  tex_FIREMAG1 = "ZIMMER7",
  thing_46 = 45,
}

-- gold

PREFABS.Wall_hell_sharp_alcoves_gold = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP01",

  tex_FIREMAG1 = "CRACKLE4",
  thing_46 = 35,
}

PREFABS.Wall_hell_sharp_alcoves_double_gold = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP02",

  tex_FIREMAG1 = "CRACKLE4",
  thing_46 = 35,
}

-- EPIC versions start here:

-- white

PREFABS.Wall_hell_sharp_alcoves_white = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP01",

  texture_pack = "armaetus",

  tex_FIREMAG1 = "ICEFALL",
  thing_46 = 86,
}

PREFABS.Wall_hell_sharp_alcoves_double_white = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP02",

  texture_pack = "armaetus",

  tex_FIREMAG1 = "ICEFALL",
  thing_46 = 86,
}

-- black

PREFABS.Wall_hell_sharp_alcoves_black = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP01",

  texture_pack = "armaetus",

  tex_FIREMAG1 = "FIREBLK1",
  thing_46 = 41,
}

PREFABS.Wall_hell_sharp_alcoves_double_black = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP02",

  texture_pack = "armaetus",

  tex_FIREMAG1 = "FIREBLK1",
  thing_46 = 41,
}

-- Yellow version by Demios, needed this version to hide my new secret

PREFABS.Wall_hell_sharp_alcoves_yellow = --#
{
  template = "Wall_hell_sharp_alcoves_single_red",
  map = "MAP01",

  tex_FIREMAG1 = "CRACKLE4",
  thing_46 = 35,
}
