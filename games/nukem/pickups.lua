NUKEM.PICKUPS =
{
 -- Health --
  cola = 
  {
    id = 51,
    add_prob = 20,
    cluster = { 1,2 },
    give = { {health=10} }
  },

-- Ammo --

  clip = 
  {
    id = 40,
    add_prob = 30,
    cluster = { 2, 5 },
    give = { {ammo="bullet",count=12} }
  },

  shells =
  {
    id = 49,
    add_prob = 20,
    cluster = { 1,2 },
    give = { {ammo="shell",count=10} }
  },

-- Armor --


}

NUKEM.NICE_ITEMS =
{

  first_aid = 
  {
    id= 53,
    add_prob = 5,
    big_item = true,
    give = { {health=100} }
  }

}

