--
-- Rocky border prefabs
--

PREFABS.Border_rocky_c =
{
  file   = "border/rocky_c.wad"
  group  = "border_rocky"
  shape  = "C"
  seed_w = 3
  seed_h = 3

  add_sky = 1
}


PREFABS.Border_rocky_t =
{
  file   = "border/rocky_t.wad"
  group  = "border_rocky"
  shape  = "T"
  seed_w = 3
  seed_h = 3

  add_sky = 1
}


PREFABS.Border_rocky_start =
{
  file   = "border/rocky_start.wad"
  group  = "border_rocky"
  shape  = "T"

  purpose = "START"

  seed_w = 3
  seed_h = 3

  add_sky = 1
}


PREFABS.Border_rocky_exit =
{
  file   = "border/rocky_exit.wad"
  group  = "border_rocky"
  shape  = "T"

  purpose = "EXIT"

  seed_w = 3
  seed_h = 3

  add_sky = 1
}


PREFABS.Border_rocky_item =
{
  file   = "border/rocky_item.wad"
  group  = "border_rocky"
  shape  = "T"

  purpose = "ITEM"

  seed_w = 3
  seed_h = 3

  height = 224

  add_sky = 1
}


--
-- Group information
--

GROUPS.border_rocky =
{
  kind = "border"
}

