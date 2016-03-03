--
-- Big blocky arch
--

DOOM.SKINS.Arch_blocky1 =
{
  file   = "hall/big_arch.wad"
  kind   = "arch"
  where  = "edge"
  group  = "hall_curve"

  long   = 256
  deep   = 64

  prob   = 10
}


DOOM.SKINS.Arch_blocky2 =
{
  -- duplicate the above, and set a new group

  copy = "Arch_blocky1"

  group  = "hall_trim1"
}

