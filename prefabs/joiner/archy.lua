--
-- Arch joiners
--

PREFABS.Joiner_archy1 =
{
  file   = "joiner/archy.wad"
  map    = "MAP01"

  prob  = 140
  theme = "!tech"

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  y_fit = "stretch"
}


PREFABS.Joiner_archy1_wide =
{
  file   = "joiner/archy.wad"
  map    = "MAP02"

  prob  = 400
  theme = "!tech"

  where  = "seeds"
  shape  = "I"

  seed_w = 3
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit = "frame"
}


--
-- NOTE: this is a workaround for an error when steepness == "NONE"
--
PREFABS.Joiner_archy_workaround =
{
  template = "Joiner_archy1"

  prob  = 0.1
  theme = "any"

  x_fit = "frame"
  y_fit = "stretch"
}

