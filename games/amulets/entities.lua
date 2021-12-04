AMULETS.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },

  --- keys ---
  --k_password = { id=5 }, -- "Blue" key
  --k_ckey     = { id=6 }, -- "Yellow" key
  --k_keycard  = { id=13 }, -- "Red" key

  --- PICKUPS ---

  potion = { id=811 },

  --- SCENERY ---
  jaw = { id=59, r=20, h=16, pass=true },
}

AMULETS.GENERIC_REQS =
{
  -- These are used for fulfilling fab pick requirements in prefab.lua
  Generic_Key_One = { kind = "k_one", rkind = "kz_red" },
  Generic_Key_Two = { kind = "k_two", rkind = "kz_yellow" },
  Generic_Key_Three = { kind = "k_three", rkind = "kz_blue" }
}

AMULETS.PLAYER_MODEL =
{
  avatar =
  {
    stats   = { health=0 },
    weapons = { dagger_wood=1 } -- This is very likely not accurate at all
  }
}
