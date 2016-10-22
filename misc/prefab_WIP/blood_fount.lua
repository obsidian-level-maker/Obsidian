--
-- Bloodfountain jutting from wall
--

UNFINISHED.Pic_bloodfountain =
{
  file   = "wall/bloodfountain.wad"
  where  = "edge"
  long   = 192
  deep   = 48 -- depth of the wall plus the part of the prefab that extends
  --over   = 16 -- i thought i could use this to define how far the prefab extends from the wall but thats not how it seems to work

  x_fit  = "frame"
  z_fit  = {112,176} -- only scale the upper part of the wall so the prefab always remains the same size

  bound_z1 = 0 -- place at the floor
  --bound_z2 = 160

  theme = "hell"
  prob  = 50
  
  tex_GSTSATYR = { GSTGARG=20, GSTLION=20, GSTSATYR=20, MARBFAC4=20}--, GSTFONT1=20} --this is the mouth that spews blood, for some reason it gets replaced by water
}

