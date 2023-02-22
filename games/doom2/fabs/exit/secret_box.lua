--
--  Secret closet for a secret exit
--

PREFABS.Exit_secret_box1 =
{
  file  = "exit/secret_box.wad",

  prob  = 100,

  -- the kind means "an exit to a secret level",
  -- the key  means "a closet which is hidden in the room",
  kind  = "secret_exit",
  key   = "secret",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  thing_34 =
  {
    dead_player = 10,
    gibbed_player = 10,
    dead_shooter = 10,
    dead_imp = 10,
    dead_demon = 10,
    dead_caco = 10,
  }
}

