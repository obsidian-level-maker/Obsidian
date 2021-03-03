PREFABS.Wall_epic_obaddon_banner =
{
  file   = "wall/gtd_EPIC_wall_banners.wad",
  map    = "MAP01",

  prob   = 35,
  env   = "!building",
  theme = "!hell",

  texture_pack = "armaetus",

  where  = "edge",
  height = 256,
  deep   = 40,

  bound_z1 = 0,
  bound_z2 = 256,

  x_fit = "frame",
  z_fit = "bottom",
}

PREFABS.Wall_epic_obaddon_banner_hell =
{
  template = "Wall_epic_obaddon_banner",

  theme = "hell",

  tex_OBDNBNR1 = "OBDNBNR2",
}

PREFABS.Wall_epic_obaddon_banner_diagonal =
{
  template = "Wall_epic_obaddon_banner",
  map    = "MAP02",

  prob   = 25,

  where  = "diagonal",
}

PREFABS.Wall_epic_obaddon_banner_diagonal_hell =
{
  template = "Wall_epic_obaddon_banner",
  map    = "MAP02",

  theme = "hell",

  prob   = 25,

  where  = "diagonal",

  tex_OBDNBNR1 = "OBDNBNR2",
}
