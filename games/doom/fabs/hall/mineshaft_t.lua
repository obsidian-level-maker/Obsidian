PREFABS.Hallway_mineshaft_t1 =
{
  file   = "hall/mineshaft_t.wad",
  map    = "MAP01",

  group  = "mineshaft",
  prob   = 50,

  where  = "seeds",
  shape  = "T",

  mon_height = 96,
}

PREFABS.Hallway_mineshaft_t2 =
{
  template = "Hallway_mineshaft_t1",
  map = "MAP02",

}

--- Radium jutting out ---

PREFABS.Hallway_mineshaft_t3 =
{
  template = "Hallway_mineshaft_t1",
  map = "MAP03",

  style = "traps",

  texture_pack = "armaetus",
}
