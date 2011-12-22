//------------------------------------------------------------------------
//  INFO : Information Panel
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


#define INFO_BG_COLOR  fl_rgb_color(96)


//
// W_Info Constructor
//
W_Info::W_Info(int X, int Y, int W, int H, const char *label) : 
    Fl_Group(X, Y, W, H, label),
    num_segs(0)
{
  end();  // cancel begin() in Fl_Group constructor

  box(FL_FLAT_BOX);

//  color(INFO_BG_COLOR, INFO_BG_COLOR);


  X += 6;
  Y += 6;

  W -= 12;
  H -= 12;

  // ---- top section ----
  
  map_name = new Fl_Output(X+88, Y, W-88, 22, "Map Name:");
  map_name->align(FL_ALIGN_LEFT);
  add(map_name);

  Y += map_name->h() + 4;

  node_type = new Fl_Output(X+88, Y, W-88, 22, "Node Type:");
  node_type->align(FL_ALIGN_LEFT);
  add(node_type);

  Y += node_type->h() + 4;

  
  // ---- middle section ----
 
  Y += 16;

  ns_index = new Fl_Output(X+74, Y, 96, 22, "Node #    ");
  ns_index->align(FL_ALIGN_LEFT);
  add(ns_index);

  Y += ns_index->h() + 4;


  // bounding box
  
  bb_label = new Fl_Box(FL_NO_BOX, X, Y, W, 22, "Bounding Box:");
  bb_label->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  add(bb_label);
  
  Y += bb_label->h() + 4;

  bb_x1 = new Fl_Output(X+32,   Y, 64, 22, "x1");
  bb_x2 = new Fl_Output(X+W-64, Y, 64, 22, "x2");

  bb_x1->align(FL_ALIGN_LEFT);
  bb_x2->align(FL_ALIGN_LEFT);

  add(bb_x1);
  add(bb_x2);

  Y += bb_x1->h() + 4;

  bb_y1 = new Fl_Output(X+32,   Y, 64, 22, "y1");
  bb_y2 = new Fl_Output(X+W-64, Y, 64, 22, "y2");

  bb_y1->align(FL_ALIGN_LEFT);
  bb_y2->align(FL_ALIGN_LEFT);

  add(bb_y1);
  add(bb_y2);

  Y += bb_y2->h() + 4;


  // partition line

  int save_Y = Y;

  pt_label = new Fl_Box(FL_NO_BOX, X, Y, W, 22, "Partition:");
  pt_label->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  add(pt_label);
  
  Y += pt_label->h() + 4;

  pt_x  = new Fl_Output(X+32,   Y, 64, 22, "x");
  pt_dx = new Fl_Output(X+W-64, Y, 64, 22, "dx");

  pt_x ->align(FL_ALIGN_LEFT);
  pt_dx->align(FL_ALIGN_LEFT);

  add(pt_x);
  add(pt_dx);

  Y += pt_x->h() + 4;

  pt_y  = new Fl_Output(X+32,   Y, 64, 22, "y");
  pt_dy = new Fl_Output(X+W-64, Y, 64, 22, "dy");

  pt_y ->align(FL_ALIGN_LEFT);
  pt_dy->align(FL_ALIGN_LEFT);

  add(pt_y);
  add(pt_dy);

  Y += pt_dy->h() + 4;


  // seg list

  Y = save_Y;
  
  seg_label = new Fl_Box(FL_NO_BOX, X, Y, W, 22, "Seg List:");
  seg_label->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  add(seg_label);

  Y += seg_label->h() + 4;

  seg_list = new Fl_Multiline_Output(X+10, Y, W-10, 96);
  add(seg_list);

  // keep 'em hidden
  seg_label->hide();
  seg_list->hide();

  Y += seg_list->h() + 4;


#if 1
  // resize control:
  Fl_Box *resize_control = new Fl_Box(FL_NO_BOX, x(), Y, w(), 4, NULL);

  add(resize_control);
  resizable(resize_control);
#endif 
  
  // ---- bottom section ----

  Y = y() + H - 22;

  mouse_x = new Fl_Output(X+28,   Y, 72, 22, "x");
  mouse_y = new Fl_Output(X+W-72, Y, 72, 22, "y");

  mouse_x->align(FL_ALIGN_LEFT);
  mouse_y->align(FL_ALIGN_LEFT);

  add(mouse_x);
  add(mouse_y);

  Y -= mouse_x->h() + 4;

  m_label = new Fl_Box(FL_NO_BOX, X, Y, W, 22, "Mouse Coords:");
  m_label->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  add(m_label);
  
  Y -= m_label->h() + 4;

  grid_size = new Fl_Output(X+50, Y, 80, 22, "Scale:");
  grid_size->align(FL_ALIGN_LEFT);
  add(grid_size);

  Y -= grid_size->h() + 4;

}

//
// W_Info Destructor
//
W_Info::~W_Info()
{
}

int W_Info::handle(int event)
{
  return Fl_Group::handle(event);
}


//------------------------------------------------------------------------

void W_Info::SetMap(const char *name)
{
  char *upper = UtilStrUpper(name);

  map_name->value(upper);

  UtilFree(upper);
}

void W_Info::SetNodes(const char *type)
{
  node_type->value(type);
}

void W_Info::SetZoom(float zoom_mul)
{
  char buffer[60];

///  if (0.99 < zoom_mul && zoom_mul < 1.01)
///  {
///    grid_size->value("1:1");
///    return;
///  }

  if (zoom_mul < 0.99)
  {
    sprintf(buffer, "/ %1.3f", 1.0/zoom_mul);
  }
  else // zoom_mul > 1
  {
    sprintf(buffer, "x %1.3f", zoom_mul);
  }

  grid_size->value(buffer);
}


void W_Info::SetNodeIndex(const char *name)
{
  ns_index->label("Node #    ");
  ns_index->value(name);

  seg_label->hide();
  seg_list->hide();

  pt_label->show();
  pt_x ->show();
  pt_y ->show();
  pt_dx->show();
  pt_dy->show();

  redraw();
}

void W_Info::SetSubsectorIndex(int index)
{
  char buffer[60];

  sprintf(buffer, "%d", index);
  
  ns_index->label("Subsec #");
  ns_index->value(buffer);

  pt_label->hide();
  pt_x ->hide();
  pt_y ->hide();
  pt_dx->hide();
  pt_dy->hide();

  seg_label->show();
  seg_list->show();

  redraw();
}

void W_Info::SetCurBBox(const bbox_t *bbox)
{
  if (! bbox)
  {
    bb_x1->value("");
    bb_y1->value("");
    bb_x2->value("");
    bb_y2->value("");

    return;
  }

  char buffer[60]; 

  sprintf(buffer, "%1.0f", bbox->minx);  bb_x1->value(buffer);
  sprintf(buffer, "%1.0f", bbox->miny);  bb_y1->value(buffer);
  sprintf(buffer, "%1.0f", bbox->maxx);  bb_x2->value(buffer);
  sprintf(buffer, "%1.0f", bbox->maxy);  bb_y2->value(buffer);
}

void W_Info::SetPartition(const node_c *part)
{
  if (! part)
  {
    pt_x ->value("");
    pt_y ->value("");
    pt_dx->value("");
    pt_dy->value("");

    return;
  }

  char buffer[60]; 

  sprintf(buffer, "%1.1f", part->x1);  pt_x ->value(buffer);
  sprintf(buffer, "%1.1f", part->y1);  pt_y ->value(buffer);
  sprintf(buffer, "%1.1f", part->x2 - part->x1);  pt_dx->value(buffer);
  sprintf(buffer, "%1.1f", part->y2 - part->y1);  pt_dy->value(buffer);
}

void W_Info::SetMouse(double mx, double my)
{
  if (mx < -32767.0 || mx > 32767.0 ||
      my < -32767.0 || my > 32767.0)
  {
    mouse_x->value("off map");
    mouse_y->value("off map");

    return;
  }

  char x_buffer[60];
  char y_buffer[60];

  sprintf(x_buffer, "%1.1f", mx);
  sprintf(y_buffer, "%1.1f", my);

  mouse_x->value(x_buffer);
  mouse_y->value(y_buffer);
}

void W_Info::BeginSegList()
{
  num_segs = 0;
}

void W_Info::AddSeg(const side_c *seg)
{
  if (num_segs < SEG_LIST_MAX)
  {
    seg_indices[num_segs++] = (int)seg; //!!!! seg->index;
  }
}

void W_Info::EndSegList()
{
  char buffer[SEG_LIST_MAX * 32];
  char *line = buffer;

  buffer[0] = 0;

  for (int n = 0; n < num_segs; n++)
  {
    char num_buf[60];

    sprintf(num_buf, "%d", seg_indices[n]);

    int line_len = strlen(line);
    int num_len  = strlen(num_buf);
    
    // fits on the line?
    if (line_len + 1 + num_len <= 19)
    {
      if (*line != 0)
        strcat(buffer, " ");
    }
    else
    {
      strcat(buffer, "\n");

      line = buffer + strlen(buffer);
    }

    strcat(buffer, num_buf);
  }

  seg_list->value(buffer);
}

