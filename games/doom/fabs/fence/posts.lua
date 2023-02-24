--
-- Various fence posts
--

PREFABS.Post_metal =
{
  file = "fence/posts.wad",
  map = "MAP01",
  kind = "post",

  prob = 50,

  where = "point",
  size = 48,

  bound_z1 = 0,
}

PREFABS.Post_tech_1 =
{
  template = "Post_metal",
  map = "MAP03",
}

PREFABS.Post_tech_simple =
{
  template = "Post_metal",
  map = "MAP03",

  thing_86 = 2028,
}

PREFABS.Post_tech_2 =
{
  template = "Post_metal",
  map = "MAP04",
}

--

PREFABS.Post_gothic_blue =
{
  template = "Post_metal",
  map = "MAP03",

  thing_86 = 55,
}

PREFABS.Post_gothic_green =
{
  template = "Post_metal",
  map = "MAP03",

  thing_86 = 56,
}

PREFABS.Post_gothic_red =
{
  template = "Post_metal",
  map = "MAP03",

  thing_86 = 57,
}

--

PREFABS.Post_gothic_blue_2 =
{
  template = "Post_metal",
  map = "MAP04",

  thing_85 = 44,
}

PREFABS.Post_gothic_green_2 =
{
  template = "Post_metal",
  map = "MAP04",

  thing_85 = 45,
}

PREFABS.Post_gothic_red_2 =
{
  template = "Post_metal",
  map = "MAP04",

  thing_85 = 46,
}
