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

#ifndef __NODEVIEW_INFO_H__
#define __NODEVIEW_INFO_H__

#define SEG_LIST_MAX  16

class W_Info : public Fl_Group
{
public:
  W_Info(int X, int Y, int W, int H, const char *label = 0);
  ~W_Info();

private:
  Fl_Output *map_name;
  Fl_Output *node_type;
  Fl_Output *grid_size;

  Fl_Output *ns_index;

  Fl_Box    *pt_label;
  Fl_Output *pt_x;
  Fl_Output *pt_y;
  Fl_Output *pt_dx;
  Fl_Output *pt_dy;

  Fl_Box    *seg_label;
  Fl_Multiline_Output *seg_list;

  Fl_Box    *bb_label;
  Fl_Output *bb_x1;
  Fl_Output *bb_y1;
  Fl_Output *bb_x2;
  Fl_Output *bb_y2;

  Fl_Box    *m_label;
  Fl_Output *mouse_x;
  Fl_Output *mouse_y;

private:
  int seg_indices[SEG_LIST_MAX];
  int num_segs;

public:
  int handle(int event);
  // FLTK virtual method for handling input events.

public:
  void SetMap(const char *name);
  void SetNodes(const char *type);
  void SetZoom(float zoom_mul);

  void SetNodeIndex(const char *name);
  void SetSubsectorIndex(int index);
  void SetCurBBox(const bbox_t *bbox);
  void SetPartition(const node_c *part);

  void SetMouse(double mx, double my);

  void BeginSegList();
  void EndSegList();
  void AddSeg(const side_c *seg);
};

#endif /* __NODEVIEW_INFO_H__ */
