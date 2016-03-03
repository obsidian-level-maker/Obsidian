
NodeView README
===============

Introduction
------------

This is a small tool for browsing CSG QUAKE nodes / segments.
It is only a debugging aid (requiring debugging output from
the main OBLIGE program).


VISUALS
-------

purple   : partition lines
pink     : highlighted subsector
sky blue : minisegs

white    : one-sided line
gray     : normal (walkable) two-sided line


CONTROLS
--------

mouse click : go down one side of the BSP tree,
              highlight the subsector when reached

CTRL+click : instantly highlight the subsector
             (same as t following by clicking all the way down)

u : go Up the BSP tree
t : go back to Top of BSP tree

f : traverse down through front of node
b : traverse down through back of node

p : toggle Partition drawing (below/on-top/none)
b : toggle Bounding-box drawing
m : toggle Minisegs (on/off)
s : toggle Shading mode (dark/no-draw)
g : toggle Grid (on/off)

+/- : zoom in / out

