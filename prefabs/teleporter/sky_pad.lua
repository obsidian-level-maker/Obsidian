--
-- Outdoor teleporter platform
--

PREFABS.Teleporter_sky_pad =
{
  file   = "teleporter/sky_pad.wad"
  map    = "MAP01"

  rank   = 2
  prob   = 50
  theme  = "!tech"

  env    = "outdoor"
  open_to_sky = 1

  where  = "seeds"
  seed_w = 2
  seed_h = 2

  x_fit  = { 40,48, 208,216 }

  tag_1 = "?out_tag"
  tag_2 = "?in_tag"
}


PREFABS.Teleporter_sky_pad_tech =
{
  template = "Teleporter_sky_pad"

  theme = "tech"

  -- replace blue torches with bollard lamps
  thing_55 = "lamp"
}

