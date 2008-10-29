----------------------------------------------------------------
--  MONSTERS/HEALTH/AMMO
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------


--[[

MONSTER SELECTION
=================

Main usages:
(a) free-range
(b) guarding something [keys]
(c) cages
(d) traps (triggered closets, teleport in)
(e) surprises (behind entry door, closests on back path)

Free range monsters make up the bulk of the level, and are
subject to the palette.  The palette applies to a fair size
of a map, on "small" setting --> 1 palette only, upto 2 on
"regular", between 2-3 on "large" maps.

[Palette probably needs to handle "families", e.g. Baron
and Hellknight, Mummy and Leader]

Trap and Surprise monsters can use any monster (actually
better when different from palette and different from
previous traps/surprises).

Cages and Guarding monsters should have a smaller and
longer-term palette, changing about 4 times less often
than the free-range palette.  MORE PRECISELY: palette
evolves about same rate IN TERMS OF # MONSTERS ADDED.

Evolving a palette: replace some monsters with different
ones.  Especially replace weaker with stronger (we assume
the player will have better weapons).  Probably replace
only 1 monster each time over the course of an EPISODE
(faster and/or more palettes when making SINGLE maps).

--------------------------------------------------------------]]

require 'defs'
require 'util'

