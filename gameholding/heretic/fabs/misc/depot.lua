--
--  Monster depot
--

PREFABS.Depot_raise =
{
  file  = "misc/depot.wad"
  map   = "MAP01"

  prob  = 50
  where = "seeds"

  seed_w = 3
  seed_h = 6

  tag_9 = "?trap_tag"

  tag_1 = "?out_tag1"
  tag_2 = "?out_tag2"
  tag_3 = "?out_tag3"
}


PREFABS.Depot_lower =
{
  template = "Depot_raise"

  map = "MAP02"
}

