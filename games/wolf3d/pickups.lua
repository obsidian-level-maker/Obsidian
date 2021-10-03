------------------------------------------------------------------------
--  WOLF3D PICKUP ITEMS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

WOLF.PICKUPS =
{
  -- NOTE: no "gibs" here, they are fairly insignificant

  first_aid =
  {
    prob=30,
    give={ {health=25} },
  },

  good_food =
  {
    prob=20,
    give={ {health=10} },
  },

  dog_food =
  {
    prob=5,
    give={ {health=4} },
  },

  clip =
  {
    prob=20,
    give={ {ammo="bullet",count=8} },
  },
}


--------------------------------------------------

WOLF.NICE_ITEMS =
{

}

