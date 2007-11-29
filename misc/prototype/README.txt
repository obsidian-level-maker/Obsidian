
Here is a dump of the Oblige 1 codebase.

Oblige 1 was the prototype map generator that I worked on.
I decided that the algorithms here did not work, so I started
a rewrite which I nick-named "Oblige NG" (Next Generation)
and that new code became the OBLIGE 0.80 public release.

This code here is very crude compared to current versions.
It is limited to blocks of 64x64 size,  Buildings don't have
outside walls.  There are no monsters or items or scenery.

Some points of interest:
  - output for numerous games: Doom, Wolf3d, Quake1, Cube.
  - GUI which shows the generated map.
  - A* path finder.

Command line usage:

  ./oblige [-g] [-r 1234] [-s 64] -o output.wad

     -g : show the GUI
     -r : set the random seed
     -s : size of map (in blocks)
     -o : specify the output filename
 
