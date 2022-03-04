NUKEM.ENTITIES =
{
  --- players ---
  player1 = { id=1405, r=20, h=56 },
  player2 = { id=1405, r=20, h=56 },
  player3 = { id=1405, r=20, h=56 },
  player4 = { id=1405, r=20, h=56 },

  dm_player = { id=1405 },

  --- pickups ---
  k_yellow   = { id=80 },

  --- scenery ---

  --- buttons ---
  nuke_button   = { id=142, r=32, h=64, pass=true },
  red_button    = { id=162, r=32, h=64, pass=true },
  square_button = { id=164, r=32, h=64, pass=true },
  access_panel  = { id=130, r=32, h=64, pass=true },

  turn_switch   = { id=136, r=32, h=64, pass=true },
  handle_switch = { id=140, r=32, h=64, pass=true },
  light_switch  = { id=712, r=32, h=64, pass=true },
  lever_switch  = { id=862, r=32, h=64, pass=true },

  light  = { id="light", r=1, h=1, pass=true },
  secret = { id="oblige_secret", r=1, h=1, pass=true },
  depot_ref = { id="oblige_depot", r=1, h=1, pass=true },
}

NUKEM.PLAYER_MODEL =
{
  duke =
  {
    stats = { health=0 },
    weapons = { foot=1, pistol=1 }
  }
}