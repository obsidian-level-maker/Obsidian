//------------------------------------------------------------------------
//  LEVEL : Level structure read/write functions.
//------------------------------------------------------------------------
//
//  GL-Node Viewer (C) 2004-2007 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

// this includes everything we need
#include "defs.h"

#define DEBUG_LOAD      0
#define DEBUG_BSP       0

#include <map>
#include <string>


side_c::side_c() : miniseg(false)
{

}


side_c::~side_c()
{
}



leaf_c::leaf_c() : sides()
{
}

leaf_c::~leaf_c()
{
}


void leaf_c::CalcMid()
{
  mid_x = 0;
  mid_y = 0;

  if (sides.empty())
    return;

  for (unsigned int i = 0 ; i < sides.size() ; i++)
  {
    side_c *cur = sides[i];

    mid_x += (cur->x1 + cur->x2) / 2.0;
    mid_y += (cur->y1 + cur->y2) / 2.0;
  }

  mid_x /= (double)sides.size();
  mid_y /= (double)sides.size();
}


child_c::child_c() : node(NULL), leaf(NULL)
{
}

child_c::~child_c()
{
}


node_c::node_c() : name(NULL), front(), back()
{
}

node_c::~node_c()
{
}


void node_c::CalcMids()
{
  if (front.leaf == qk_solid_leaf)
    ;
  else if (front.leaf)
    front.leaf->CalcMid();
  else if (front.node)
    front.node->CalcMids();

  if (back.leaf == qk_solid_leaf)
    ;
  else if (back.leaf)
    back.leaf->CalcMid();
  else
    back.node->CalcMids();
}


node_c * qk_root_node;
leaf_c * qk_solid_leaf;

static std::map< std::string, node_c* >  node_map;

static bool found_beginning;


//------------------------------------------------------------------------


static bool parse_partition(FILE *fp, char *line)
{
  // this merely create the node -- the info comes later

  char node_name[40];

  double x1, y1, x2, y2;

  if (sscanf(line, "partition %s (%lf %lf) (%lf %lf)", node_name, &x1, &y1, &x2, &y2) != 5)
    FatalError("failed to parse: %s\n", line);

  std::string node2(node_name);

  if (node_map.find(node2) == node_map.end())
    ; // OK
  else
    FatalError("Node already exists in: %s\n", line);
  
  node_c *nd = new node_c;

  nd->name = strdup(node_name);

  nd->x1 = x1;
  nd->y1 = y1;
  nd->x2 = x2;
  nd->y2 = y2;

  node_map[node2] = nd;

  return true;  // OK
}


static void parse_child(child_c & child, char *info, char *node_name)
{
  if (strcmp(info, "SOLID") == 0)
  {
    child.leaf = qk_solid_leaf;
    child.node = NULL;
    return;
  }

  if (strcmp(info, "LEAF") == 0)
  {
    // we only need to verify that the child is a leaf
    // (since a side_group will already have been parsed giving the
    //  leaf to the current partition)
///    if (! child.leaf)
///      FatalError("child should be leaf @ %s\n", node_name);
    return;
  }

  if (info[0] == 'N' && info[1] == ':')  // ain't I a stickler?
  {
    info += 2;

    std::string node2(info);

    if (node_map.find(node2) == node_map.end())
    {
      fprintf(stderr, "WARNING: Unknown node for child: %s\n", info);
      return;
    }

    child.node = node_map[node2];
    child.leaf = NULL;
    return;
  }

  FatalError("Unknown syntax for child: %s\n", info);
}


static bool parse_part_info(FILE *fp, char *line)
{
  char node_name[40];
  char front_info[40];
  char back_info[40];

  if (sscanf(line, "part_info %s = %s / %s", node_name, front_info, back_info) != 3)
    FatalError("failed to parse: %s\n", line);

  if (node_map.find(node_name) == node_map.end())
    FatalError("Unknown node in: %s\n", line);

  node_c *nd = node_map[node_name];

  parse_child(nd->front, front_info, node_name);
  parse_child(nd->back,  back_info,  node_name);

  return true;
}


static bool parse_root(FILE *fp, char *line)
{
  char node_name[40];

  if (sscanf(line, "root = %s", node_name) != 1)
    FatalError("failed to parse: %s\n", line);

  std::string node2(node_name);

  if (node_map.find(node2) == node_map.end())
    FatalError("Unknown node in: %s\n", line);

  qk_root_node = node_map[node2];

  return false;  // ALL DONE
}


static bool parse_a_side(FILE *fp, char *line, leaf_c *leaf)
{
  char side_name[40];

  double x1, y1, x2, y2;

  char region_name[40];

  if (sscanf(line, " side %s : (%lf %lf) (%lf %lf) in %s", side_name,
             &x1, &y1, &x2, &y2, region_name) != 6)
  {
    FatalError("failed to parse side: %s\n", line);
  }

  side_c *side = new side_c;

  side->x1 = x1;
  side->y1 = y1;
  side->x2 = x2;
  side->y2 = y2;

  if (region_name[0] == '(')  // (nil)
    side->miniseg = true;

  leaf->sides.push_back(side);

  return true;
}


static bool parse_side_group(FILE *fp, char *line)
{
  char node_name[40];
  int side;
  int num_sides;

  if (sscanf(line, "side_group @ %s : %d = %d", node_name, &side, &num_sides) != 3)
    FatalError("failed to parse: %s\n", line);

  if (node_map.find(node_name) == node_map.end())
  {
    fprintf(stderr, "WARNING: Unknown node in: %s\n", line);

    // skip side information
    for (int i = 0 ; i < num_sides ; i++)
    {
      char buffer[1024];
      fgets(buffer, sizeof(buffer), fp);
    }

    return true;
  }


  node_c *nd = node_map[node_name];

  child_c *child = side ? &nd->back : &nd->front;

  leaf_c *leaf = new leaf_c;

  child->leaf = leaf;
  child->node = NULL;

  for (int i = 0 ; i < num_sides ; i++)
  {
    char buffer[1024];

    if (! fgets(buffer, sizeof(buffer), fp))
    {
      fprintf(stderr, "fgets failed\n");
      return false;
    }

    if (! parse_a_side(fp, buffer, leaf))
      return false;
  }

  return true;
}


static bool process_line(FILE *fp)
{
  // returns TRUE if OK, FALSE if all done

  char buffer[1024];

  if (! fgets(buffer, sizeof(buffer), fp))
  {
    fprintf(stderr, "fgets failed\n");
    return false;
  }

  if (buffer[0] == '#')
    return true;

  if (! found_beginning)
  {
    if (strncmp(buffer, "begin_node_stuff", 16) != 0)
      return true;

    found_beginning = true;
    return true;
  }

  if (strncmp(buffer, "partition", 9) == 0)
    return parse_partition(fp, buffer);
  
  if (strncmp(buffer, "part_info", 9) == 0)
    return parse_part_info(fp, buffer);
  
  if (strncmp(buffer, "side_group", 10) == 0)
    return parse_side_group(fp, buffer);
  
  if (strncmp(buffer, "root", 4) == 0)
    return parse_root(fp, buffer);

  FatalError("Unknown keyword in data: %s\n", buffer);
  return false;
}


void LoadLevel(const char *filename)
{
  qk_solid_leaf = new leaf_c;

  FILE * fp = fopen(filename, "r");
  if (! fp)
    FatalError("unknown file: %s\n", filename);

  while (process_line(fp))
  { }

  fclose(fp);

  if (! found_beginning)
    FatalError("No node info found\n");

  if (! qk_root_node)
    FatalError("No root node\n");

  // calcMid on all leafs
  qk_root_node->CalcMids();
}


void FreeLevel(void)
{
}

//
// LevelGetBounds
//
void LevelGetBounds(double *lx, double *ly, double *hx, double *hy)
{
#if 0
  node_c *root = qk_root_node;

  *lx = MIN(root->back.bounds.minx, root->front.bounds.minx);
  *ly = MIN(root->back.bounds.miny, root->front.bounds.miny);
  *hx = MAX(root->back.bounds.maxx, root->front.bounds.maxx);
  *hy = MAX(root->back.bounds.maxy, root->front.bounds.maxy);
#else
  *lx = 0;
  *ly = 0;
  *hx = 4000;
  *hy = 4000;
#endif
}

