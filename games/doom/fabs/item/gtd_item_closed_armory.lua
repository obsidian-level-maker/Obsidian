--
-- Yes, I am aware I am a bad person.
--

PREFABS.Item_sealed_armory_room_regular =
{
  file   = "item/gtd_item_closed_armory.wad",
  map    = "MAP02",

  prob   = 25,

  theme  = "!hell",
  env    = "!cave",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_sealed_armory_room_keyed =
{
  template = "Item_sealed_armory_room_regular",
  map      = "MAP01",

  item_kind = "key",

  rank   = 2,
  prob   = 100,

  sound = "Toilet_Running",
}
