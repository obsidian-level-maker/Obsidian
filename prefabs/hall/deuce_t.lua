--
-- 2-seed-wide hallway : T shape piece
--

PREFABS.Hallway_deuce_t1 =
{
  file   = "hall/deuce_t.wad"
  map    = "MAP01"

  group  = "deuce"
  prob   = 50

  where  = "seeds"
  shape  = "T"

  seed_w = 2
  seed_h = 2
}


-- disabled for now
UNFINISHED.Hallway_deuce_t_stair =
{
  template = "Hallway_deuce_t1"

  map    = "MAP03"

  style  = "steepness"
  prob   = 50

  delta_h = 32
}

