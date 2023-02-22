---Gtd's vehicle modified to be looking broken---

PREFABS.Decor_road_vehicle_tractor_thing_broken =
{
  file = "decor/dem_decor_road_vehicles_tech_broken.wad",
  map = "MAP01",

  prob = 5000,
  theme = "tech",
  env = "outdoor",

  texture_pack = "armaetus",

  can_be_on_roads = true,

  where = "point",
  size = 160,
  height = 88,

  bound_z1 = 0,
  bound_z2 = 160,

}

PREFABS.Decor_road_vehicle_dump_truck_broken =
{
  template = "Decor_road_vehicle_tractor_thing_broken",
  map = "MAP02",

  height = 96,
}

PREFABS.Decor_road_vehicle_dozer_broken =
{
  template = "Decor_road_vehicle_tractor_thing_broken",
  map = "MAP03",
}

-- urban versions, lower priority

PREFABS.Decor_road_vehicle_tractor_thing_urban_broken =
{
  template = "Decor_road_vehicle_tractor_thing_broken",

  theme = "urban",

  prob = 1000,
}

PREFABS.Decor_road_vehicle_dump_truck_urban_broken =
{
  template = "Decor_road_vehicle_tractor_thing_broken",
  map = "MAP02",

  prob = 1000,
  theme = "urban",

  height = 96,
}

PREFABS.Decor_road_vehicle_dozer_urban_broken =
{
  template = "Decor_road_vehicle_tractor_thing_broken",
  map = "MAP03",

  prob = 1000,
  theme = "urban",
}
