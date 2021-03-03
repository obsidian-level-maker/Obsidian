--
-- Yes, I am aware I am a bad person.
--

PREFABS.Item_closet_toilet_room =
{
  file   = "item/gtd_item_closet_toilet.wad",
  map    = "MAP01",

  engine = "!zdoom",

  rank   = 2,
  prob   = 100,
  theme  = "!hell",
  env    = "!cave",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep =  16,
  over = -16,

  item_kind = "key",

  x_fit = "frame",
  y_fit = "top",

  sound = "Bathroom_Fan",
}

PREFABS.Item_closet_toilet_room_filthy =
{
  template   = "Item_closet_toilet_room",
  map = "MAP02",
  prob = 80,
}
