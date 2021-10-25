--
-- Arch joiners
--

-- Limit to games with medieval/fantasy elements, as it looks a bit odd in modern/future settings
PREFABS.Joiner_archy1 =
{
  file   = "joiner/archy.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, nukem=0, quake=0, strife=1 },

  prob  = 140,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = "stretch",
}


PREFABS.Joiner_archy1_wide =
{
  file   = "joiner/archy.wad",
  map    = "MAP02",
  game   = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, nukem=0, quake=0, strife=1 },

  prob  = 400,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = "frame",
}

