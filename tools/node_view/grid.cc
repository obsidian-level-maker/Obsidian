//------------------------------------------------------------------------
//  GRID : Draws the map (lines, nodes, etc)
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


#if 0
static void foo_win_close_CB(Fl_Widget *w, void *data)
{
}
#endif


//
// W_Grid Constructor
//
W_Grid::W_Grid(int X, int Y, int W, int H, const char *label) : 
    Fl_Widget(X, Y, W, H, label),
    zoom(DEF_GRID_ZOOM), zoom_mul(1.0),
    mid_x(0), mid_y(0),
    grid_MODE(1), partition_MODE(1), bbox_MODE(1),
    miniseg_MODE(2), shade_MODE(1),
    route_len(0)
{
  visit_route = new char[MAX_ROUTE];
}

//
// W_Grid Destructor
//
W_Grid::~W_Grid()
{
  delete[] visit_route;
}


void W_Grid::SetZoom(int new_zoom)
{
  if (new_zoom < MIN_GRID_ZOOM)
    new_zoom = MIN_GRID_ZOOM;

  if (new_zoom > MAX_GRID_ZOOM)
    new_zoom = MAX_GRID_ZOOM;

  if (zoom == new_zoom)
    return;

  zoom = new_zoom;

  zoom_mul = pow(2.0, (zoom / 2.0 - 9.0));

  guix_win->info->SetZoom(zoom_mul);

  //  fprintf(stderr, "Zoom %d  Mul %1.5f\n", zoom, zoom_mul);

  redraw();
}


void W_Grid::SetPos(double new_x, double new_y)
{
  mid_x = new_x;
  mid_y = new_y;

  redraw();
}

void W_Grid::FitBBox(double lx, double ly, double hx, double hy)
{
  double dx = hx - lx;
  double dy = hy - ly;

  zoom = MAX_GRID_ZOOM;

  for (; zoom > MIN_GRID_ZOOM; zoom--)
  {
    zoom_mul = pow(2.0, (zoom / 2.0 - 9.0));

    if (dx * zoom_mul < w() && dy * zoom_mul < h())
      break;
  }

  zoom_mul = pow(2.0, (zoom / 2.0 - 9.0));

  guix_win->info->SetZoom(zoom_mul);

  SetPos(lx + dx / 2.0, ly + dy / 2.0);

  new_node_or_sub();  // bit hackish (calling it here)
}

void W_Grid::MapToWin(double mx, double my, int *X, int *Y) const
{
  double hx = x() + w() / 2.0;
  double hy = y() + h() / 2.0;

  (*X) = I_ROUND(hx + (mx - mid_x) * zoom_mul);
  (*Y) = I_ROUND(hy - (my - mid_y) * zoom_mul);
}

void W_Grid::WinToMap(int X, int Y, double *mx, double *my) const
{
  double hx = x() + w() / 2.0;
  double hy = y() + h() / 2.0;

  (*mx) = mid_x + (X - hx) / zoom_mul;
  (*my) = mid_y - (Y - hy) / zoom_mul;
}

//------------------------------------------------------------------------

void W_Grid::resize(int X, int Y, int W, int H)
{
  Fl_Widget::resize(X, Y, W, H);
}

void W_Grid::draw()
{
  /// FIXME

  fl_push_clip(x(), y(), w(), h());

  fl_color(FL_BLACK);
  fl_rectf(x(), y(), w(), h());

                                //  3456789012345678901234567890
//static const char *ity_2_to_N3 = "-------------------------233";
  static const char *ity_2_to_0  = "-------------------334455555";
  static const char *ity_2_to_3  = "-------------334455667777777";
  static const char *ity_2_to_6  = "-------33445566778899999----";
  static const char *ity_2_to_9  = "-33445566778899999----------";
  static const char *ity_2_to_12 = "566778899999----------------";
  static const char *ity_2_to_15 = "999999----------------------";

//draw_grid(0.125,   ity_2_to_N3[zoom - 3]);
  draw_grid(1.0,     ity_2_to_0 [zoom - 3]);
  draw_grid(8.0,     ity_2_to_3 [zoom - 3]);
  draw_grid(64.0,    ity_2_to_6 [zoom - 3]);
  draw_grid(512.0,   ity_2_to_9 [zoom - 3]);
  draw_grid(4096.0,  ity_2_to_12[zoom - 3]);
  draw_grid(32768.0, ity_2_to_15[zoom - 3]);

  node_c *root = qk_root_node;

  if (partition_MODE == 1)
    draw_all_partitions();

  draw_node(root, 0, true);

  if (partition_MODE == 2)
    draw_all_partitions();

  fl_pop_clip();
}

void W_Grid::draw_grid(double spacing, int ity)
{
  if (grid_MODE == 0)
    return;

  if (! isdigit(ity))
    return;

  ity = MIN(ity - '0', 9);

  fl_color(fl_rgb_color(0, 0, 255 * ity / 9));

  double mlx = mid_x - w() * 0.5 / zoom_mul;
  double mly = mid_y - h() * 0.5 / zoom_mul;
  double mhx = mid_x + w() * 0.5 / zoom_mul;
  double mhy = mid_y + h() * 0.5 / zoom_mul;

  int gx = GRID_FIND(mid_x, spacing);
  int gy = GRID_FIND(mid_y, spacing);

  int x1 = x();
  int y1 = y();
  int x2 = x() + w();
  int y2 = y() + h();

  int dx, dy;
  int wx, wy;

  for (dx = 0; true; dx++)
  {
    double xx = gx + dx * spacing;

    if (xx > mhx) break;
    if (xx < mlx) continue;

    MapToWin(xx, gy, &wx, &wy);
    fl_yxline(wx, y1, y2);
  }

  for (dx = -1; true; dx--)
  {
    double xx = gx + dx * spacing;

    if (xx < mlx) break;
    if (xx > mhx) continue;

    MapToWin(xx, gy, &wx, &wy);
    fl_yxline(wx, y1, y2);
  }

  for (dy = 0; true; dy++)
  {
    double yy = gy + dy * spacing;

    if (yy > mhy) break;
    if (yy < mly) continue;

    MapToWin(gx, yy, &wy, &wy);
    fl_xyline(x1, wy, x2);
  }

  for (dy = -1; true; dy--)
  {
    double yy = gy + dy * spacing;

    if (yy < mly) break;
    if (yy > mhy) continue;

    MapToWin(gx, yy, &wy, &wy);
    fl_xyline(x1, wy, x2);
  }
}

void W_Grid::draw_partition(const node_c *nd, int ity)
{
  double mlx = mid_x - w() * 0.5 / zoom_mul;
  double mly = mid_y - h() * 0.5 / zoom_mul;
  double mhx = mid_x + w() * 0.5 / zoom_mul;
  double mhy = mid_y + h() * 0.5 / zoom_mul;

  double tlx, tly;
  double thx, thy;

  // intersect the partition line (which extends to infinity) with
  // the sides of the screen (in map coords).  Whether we use the
  // left/right sides to top/bottom depends on the angle of the
  // partition line.

  double ndx = nd->x2 - nd->x1;
  double ndy = nd->y2 - nd->y1;

  if (ABS(ndx) > ABS(ndy))
  {
    tlx = mlx;
    thx = mhx;
    tly = nd->y1 + ndy * (mlx - nd->x1) / ndx;
    thy = nd->y1 + ndy * (mhx - nd->x1) / ndx;

    if (MAX(tly, thy) < mly || MIN(tly, thy) > mhy)
      return;
  }
  else
  {
    tlx = nd->x1 + ndx * (mly - nd->y1) / ndy;
    thx = nd->x1 + ndx * (mhy - nd->y1) / ndy;
    tly = mly;
    thy = mhy;

    if (MAX(tlx, thx) < mlx || MIN(tlx, thx) > mhx)
      return;
  }

  int sx, sy;
  int ex, ey;

  MapToWin(tlx, tly, &sx, &sy);
  MapToWin(thx, thy, &ex, &ey);

  if (partition_MODE < 2)
  {
    // move vertical or horizontal lines by one pixel
    // (to prevent being clobbered by segs)
    if (ABS(ndx) < ABS(ndy))
        sx++, ex++;
    else
        sy++, ey++;
  }

  fl_color(fl_rgb_color(ity*80-70, 0, ity*80-70));
  fl_line(sx, sy, ex, ey);

  // draw arrow heads along it
  float pd_len = sqrt(ndx*ndx + ndy*ndy);
  float pdx =  ndx / pd_len;
  float pdy = -ndy / pd_len;

  for (float u=0.1; u <= 0.91; u += 0.16)
  {
    int ax = int(sx + (ex-sx) * u);
    int ay = int(sy + (ey-sy) * u);

    fl_line(ax, ay, ax + int((-pdy-pdx*1.0)*8), ay + int(( pdx-pdy*1.0)*8) );
    fl_line(ax, ay, ax + int(( pdy-pdx*1.0)*8), ay + int((-pdx-pdy*1.0)*8) );
  }
}

void W_Grid::draw_bbox(const bbox_t *bbox, int ity)
{
  double mlx = mid_x - w() * 0.5 / zoom_mul;
  double mly = mid_y - h() * 0.5 / zoom_mul;
  double mhx = mid_x + w() * 0.5 / zoom_mul;
  double mhy = mid_y + h() * 0.5 / zoom_mul;

  // check if bounding box is off screen

  if (bbox->maxx < mlx || bbox->minx > mhx ||
      bbox->maxy < mly || bbox->miny > mhy)
  {
      return;
  }

  int sx, sy;
  int ex, ey;

  MapToWin(bbox->minx, bbox->maxy, &sx, &sy);
  MapToWin(bbox->maxx, bbox->miny, &ex, &ey);

  if (partition_MODE < 2)
  {
    // make one pixel bigger (to prevent being clobbered by segs)
    sx--; sy--; ex++; ey++;
  }

  fl_color(fl_rgb_color(ity*50, 0, 0));

  fl_line(sx, sy, sx, ey);
  fl_line(sx, sy, ex, sy);
  fl_line(sx, ey, ex, ey);
  fl_line(ex, sy, ex, ey);
}

void W_Grid::draw_all_partitions()
{
  node_c * nodes[4];
  bbox_t * bboxs[4];

  nodes[0] = nodes[1] = nodes[2] = NULL;
  nodes[3] = qk_root_node;

  bboxs[0] = bboxs[1] = bboxs[2] = bboxs[3] = NULL;

  for (int rt_idx = 0; rt_idx < route_len; rt_idx++)
  {
    node_c *cur = nodes[3];

    child_c *next_ch = (visit_route[rt_idx] == RT_LEFT) ? &cur->back : &cur->front;

    nodes[0] = nodes[1];  bboxs[0] = bboxs[1];
    nodes[1] = nodes[2];  bboxs[1] = bboxs[2];
    nodes[2] = nodes[3];  bboxs[2] = bboxs[3];

    nodes[3] = next_ch->node;
    bboxs[3] = &next_ch->bounds;

    // quit if we reach a subsector
    if (! nodes[3])
      break;
  }

  // (Note: only displaying two of them)
  for (int n_idx = 2; n_idx <= 3; n_idx++)
  {
    if (bbox_MODE == 1)
      if (bboxs[n_idx])
        draw_bbox(bboxs[n_idx], n_idx + 1);

    if (nodes[n_idx])
      draw_partition(nodes[n_idx], n_idx + 1);
  }
}

void W_Grid::draw_node(const node_c *nd, int pos, bool on_route)
{
  if (! on_route)
  {
    draw_child(&nd->back, pos, false);
    draw_child(&nd->front, pos, false);
  }
  else if (pos >= route_len)
  {
    draw_child(&nd->back, pos, true);
    draw_child(&nd->front, pos, true);
  }
  else if (visit_route[pos] == RT_LEFT)
  {
    // get drawing order correct, draw shaded side FIRST.
    draw_child(&nd->front, pos, false);
    draw_child(&nd->back, pos, true);
  }
  else  // RT_RIGHT
  {
    draw_child(&nd->back, pos, false);
    draw_child(&nd->front, pos, true);
  }
}

void W_Grid::draw_child(const child_c *ch, int pos, bool on_route)
{
  // OPTIMISATION: check the bounding box

  if (ch->node)
  {
    draw_node(ch->node, pos + 1, on_route);
  }
  else  /* Subsector */
  {
    draw_leaf(ch->leaf, pos + 1, on_route);
  }
}

void W_Grid::draw_leaf(const leaf_c *lf, int pos, bool on_route)
{
  for (unsigned int i = 0 ; i < lf->sides.size() ; i++)
  {
    side_c * sd = lf->sides[i];

    if (on_route && pos == route_len)
      fl_color(fl_color_cube(4,5,4));
    else if (! set_seg_color(sd, on_route))
      continue;

    draw_line(sd->x1, sd->y1, sd->x2, sd->y2);
  }
}

bool W_Grid::set_seg_color(side_c *sd, bool on)
{
  if (shade_MODE == 0 && !on)
    return false;
  
  if (shade_MODE == 2)
    on = true;

  int ity = on ? 255 : 144;

  if (sd->miniseg)
  {
    if (miniseg_MODE < 2)
      return false;

     fl_color(0, ity*144/255, ity*192/255);
     return true;
  }

#if 0
  if (! seg->linedef->left || ! seg->linedef->right)  // 1-sided line
  {
    fl_color(on ? FL_WHITE : fl_rgb_color(128));
    return true;
  }

  sector_c *front = seg->linedef->right->sector;
  sector_c *back  = seg->linedef->left->sector;

  int floor_min = MIN(front->floor_h, back->floor_h);
  int floor_max = MAX(front->floor_h, back->floor_h);

  int ceil_min = MIN(front->ceil_h, back->ceil_h);
//  int ceil_max = MAX(front->ceil_h, back->ceil_h);

  if (ceil_min <= floor_max)  // closed door ?
  {
    fl_color(fl_rgb_color(ity, ity/2, 0));
    return true;
  }
  if (ceil_min - floor_max < 56)  // narrow vertical gap ?
  {
    fl_color(fl_rgb_color(0, ity, ity));
    return true;
  }
  if (seg->linedef->flags & 1)  // marked impassable ?
  {
    fl_color(fl_rgb_color(ity, ity, 0));
    return true;
  }
  if (floor_max - floor_min > 24)  // unclimbable dropoff ?
  {
    fl_color(fl_rgb_color(0, ity, 0));
    return true;
  }

  if (miniseg_MODE < 1)
    return false;
#endif

  fl_color(fl_rgb_color(on ? 176 : 96));  // everything else
  return true;
}

void W_Grid::draw_line(double x1, double y1, double x2, double y2)
{
  double mlx = mid_x - w() * 0.5 / zoom_mul;
  double mly = mid_y - h() * 0.5 / zoom_mul;
  double mhx = mid_x + w() * 0.5 / zoom_mul;
  double mhy = mid_y + h() * 0.5 / zoom_mul;

  // Based on Cohen-Sutherland clipping algorithm

  int out1 = MAP_OUTCODE(x1, y1, mlx, mly, mhx, mhy);
  int out2 = MAP_OUTCODE(x2, y2, mlx, mly, mhx, mhy);

/// PrintDebug("LINE (%1.3f,%1.3f) --> (%1.3f,%1.3f)\n", x1, y1, x2, y2);
/// PrintDebug("RECT (%1.3f,%1.3f) --> (%1.3f,%1.3f)\n", mlx, mly, mhx, mhy);
/// PrintDebug("  out1 = %d  out2 = %d\n", out1, out2);

  while ((out1 & out2) == 0 && (out1 | out2) != 0)
  {
/// PrintDebug("> LINE (%1.3f,%1.3f) --> (%1.3f,%1.3f)\n", x1, y1, x2, y2);
/// PrintDebug(">   out1 = %d  out2 = %d\n", out1, out2);

    // may be partially inside box, find an outside point
    int outside = (out1 ? out1 : out2);

    SYS_ZERO_CHECK(outside);

    double dx = x2 - x1;
    double dy = y2 - y1;

    if (fabs(dx) < 0.1 && fabs(dy) < 0.1)
      break;

    double tmp_x, tmp_y;

    // clip to each side
    if (outside & O_BOTTOM)
    {
      tmp_x = x1 + dx * (mly - y1) / dy;
      tmp_y = mly;
    }
    else if (outside & O_TOP)
    {
      tmp_x = x1 + dx * (mhy - y1) / dy;
      tmp_y = mhy;
    }
    else if (outside & O_LEFT)
    {
      tmp_y = y1 + dy * (mlx - x1) / dx;
      tmp_x = mlx;
    }
    else  /* outside & O_RIGHT */
    {
      SYS_ASSERT(outside & O_RIGHT);

      tmp_y = y1 + dy * (mhx - x1) / dx;
      tmp_x = mhx;
    }

/// PrintDebug(">   outside = %d  temp = (%1.3f, %1.3f)\n", tmp_x, tmp_y);
    SYS_ASSERT(out1 != out2);

    if (outside == out1)
    {
      x1 = tmp_x;
      y1 = tmp_y;

      out1 = MAP_OUTCODE(x1, y1, mlx, mly, mhx, mhy);
    }
    else
    {
      SYS_ASSERT(outside == out2);

      x2 = tmp_x;
      y2 = tmp_y;

      out2 = MAP_OUTCODE(x1, y1, mlx, mly, mhx, mhy);
    }
  }

  if (out1 & out2)
    return;

  int sx, sy;
  int ex, ey;

  MapToWin(x1, y1, &sx, &sy);
  MapToWin(x2, y2, &ex, &ey);

  fl_line(sx, sy, ex, ey);
}

void W_Grid::draw_path()
{
#if 0
  int p;

  // first, render the lines
  fl_color(fl_color_cube(0,7,4));

  for (p = 0; p < path->point_num - 1; p++)
  {
    int x1, y1, x2, y2;

    path->GetPoint(p,   &x1, &y1);
    path->GetPoint(p+1, &x2, &y2);

    draw_line(x1, y1, x2, y2);
  }

  // second, render the points themselves
  fl_color(FL_YELLOW);

  for (p = 0; p < path->point_num; p++)
  {
    int mx, my;
    int wx, wy;

    path->GetPoint(p, &mx, &my);

    MapToWin(mx, my, &wx, &wy);

    fl_rect(wx-1, wy-1, 3, 3);
  }
#endif
}

void W_Grid::scroll(int dx, int dy)
{
  dx = dx * w() / 10;
  dy = dy * h() / 10;

  double mdx = dx / zoom_mul;
  double mdy = dy / zoom_mul;

  mid_x += mdx;
  mid_y += mdy;

// fprintf(stderr, "Scroll pix (%d,%d) map (%1.1f, %1.1f) mid (%1.1f, %1.1f)\n", dx, dy, mdx, mdy, mid_x, mid_y);

  redraw();
}

//------------------------------------------------------------------------

int W_Grid::handle(int event)
{
  switch (event)
  {
    case FL_FOCUS:
      return 1;

    case FL_KEYDOWN:
    case FL_SHORTCUT:
    {
      int result = handle_key(Fl::event_key());
      handle_mouse(Fl::event_x(), Fl::event_y());
      return result;
    }

    case FL_ENTER:
    case FL_LEAVE:
      return 1;

    case FL_MOVE:
      handle_mouse(Fl::event_x(), Fl::event_y());
      return 1;

    case FL_PUSH:
      if (Fl::focus() != this)
      {
        Fl::focus(this);
        handle(FL_FOCUS);
        return 1;
      }

      if (Fl::event_state() & FL_CTRL)
      {
        // select new subsector
        route_len = 0;
        while (descend_by_mouse(Fl::event_x(), Fl::event_y()));
        { /* nothing */ }
      }
      else
      {
        descend_by_mouse(Fl::event_x(), Fl::event_y());
      }
      redraw();
      return 1;

    case FL_MOUSEWHEEL:
      if (Fl::event_dy() < 0)
        SetZoom(zoom + 1);
      else if (Fl::event_dy() > 0)
        SetZoom(zoom - 1);

      handle_mouse(Fl::event_x(), Fl::event_y());
      return 1;

    case FL_DRAG:
    case FL_RELEASE:
      // these are currently ignored.
      return 1;

    default:
      break;
  }

  return 0;  // unused
}

int W_Grid::handle_key(int key)
{
  if (key == 0)
    return 0;

  switch (key)
  {
    case '+': case '=':
      SetZoom(zoom + 1);
      return 1;

    case '-': case '_':
      SetZoom(zoom - 1);
      return 1;

    case FL_Left:
      scroll(-1, 0);
      return 1;

    case FL_Right:
      scroll(+1, 0);
      return 1;

    case FL_Up:
      scroll(0, +1);
      return 1;

    case FL_Down:
      scroll(0, -1);
      return 1;

    case 'g': case 'G':
      grid_MODE = (grid_MODE + 1) % 2;
      redraw();
      return 1;

    case 'p': case 'P':
      partition_MODE = (partition_MODE + 1) % 3;
      redraw();
      return 1;

    case 'x': case 'X':
      bbox_MODE = (bbox_MODE + 1) % 2;
      redraw();
      return 1;

    case 'm': case 'M':
      miniseg_MODE = (miniseg_MODE + 2) % 3;
      redraw();
      return 1;

    case 's': case 'S':
      shade_MODE = (shade_MODE + 1) % 2;
      redraw();
      return 1;

    case 'f': case 'F':
      descend_tree(RT_RIGHT);
      redraw();
      return 1;

    case 'b': case 'B':
      descend_tree(RT_LEFT);
      redraw();
      return 1;

    case 'u': case 'U':
      if (route_len > 0)
      {
        route_len--;
        new_node_or_sub();
        redraw();
      }
      return 1;

    case 't': case 'T':
      route_len = 0;
      new_node_or_sub();
      redraw();
      return 1;

//  case 'x':
//    DialogShowAndGetChoice(ALERT_TXT, 0, "Please foo the joo.");
//    return 1;

    default:
      break;
  }

  return 0;  // unused
}

bool W_Grid::descend_by_mouse(int wx, int wy)
{
  node_c *cur_nd;
  leaf_c *cur_lf;
  bbox_t *cur_bbox;
  
  lowest_node(&cur_nd, &cur_lf, &cur_bbox);

  if (cur_lf)
    return false;

  double mx, my;
  WinToMap(wx, wy, &mx, &my);

  // transpose coords to the origin, check side
  double ox = mx - cur_nd->x1;
  double oy = my - cur_nd->y1;

  double cur_ndx = cur_nd->x2 - cur_nd->x1;
  double cur_ndy = cur_nd->y2 - cur_nd->y1;

  if (oy * cur_ndx < ox * cur_ndy)
    return descend_tree(RT_RIGHT);
  else
    return descend_tree(RT_LEFT);
}

bool W_Grid::descend_tree(char side)
{
  // safety check (should never happen under normal circumstances)
  if (route_len >= MAX_ROUTE)
    return false;

  node_c *cur_nd;
  leaf_c *cur_lf;
  bbox_t *cur_bbox;

  lowest_node(&cur_nd, &cur_lf, &cur_bbox);

  if (cur_lf)
    return false;

  visit_route[route_len++] = side;

  new_node_or_sub();

  return true;
}

void W_Grid::lowest_node(node_c **nd, leaf_c **sub, bbox_t **bbox)
{
  *bbox = NULL;

  node_c *cur = qk_root_node;
  node_c *next;

  for (int rt_idx = 0; rt_idx < route_len; rt_idx++)
  {
    child_c *child = (visit_route[rt_idx] == RT_LEFT) ? &cur->back : &cur->front;

    next  = child->node;
    *bbox = &child->bounds;

    // reached a subsector ?
    if (! next)
    {
      *nd = cur;
      *sub = child->leaf;

      SYS_NULL_CHECK(*sub);
      return;
    }

    cur = next;
  }

  *nd  = cur;
  *sub = NULL;
}

void W_Grid::handle_mouse(int wx, int wy)
{
  if (! guix_win)
    return;

  double mx, my;

  WinToMap(wx, wy, &mx, &my);

  guix_win->info->SetMouse(mx, my);
}

void W_Grid::new_node_or_sub(void)
{
  node_c *cur_nd;
  leaf_c *cur_lf;
  bbox_t *cur_bbox;
  
  lowest_node(&cur_nd, &cur_lf, &cur_bbox);

  if (cur_lf)
  {
    guix_win->info->BeginSegList();
    
///    for (seg_c *seg = cur_lf->seg_list; seg; seg = seg->next)
///     guix_win->info->AddSeg(seg);
    
    guix_win->info->EndSegList();

    guix_win->info->SetSubsectorIndex(0);
    guix_win->info->SetPartition(NULL);
  }
  else
  {
    guix_win->info->SetNodeIndex(cur_nd->name);
    guix_win->info->SetPartition(cur_nd);
  }

  guix_win->info->SetCurBBox(cur_bbox); // NULL is OK
}

