// Modified box types from the FLTK defaults to account for custom border colors/gradients. -Dasho

#include <FL/Fl.H>
#include <FL/fl_draw.H>
#include "main.h"

// CUSTOM GLEAM BOXES ---------------------------------------------------------------------------------------

void cgleam_gleam_color(Fl_Color c) {
  Fl::set_box_color(c);
}

void cgleam_shade_rect_top_bottom(int x, int y, int w, int h, Fl_Color fg1, Fl_Color fg2, float th) {
  // calculate background size w/o borders
  x += 2; y += 2; w -= 4; h -= 4;
  // draw the shiny background using maximum limits
  int h_top    = ((h/2) < (20) ? (h/2) : (20)); // min(h/2, 20);
  int h_bottom = ((h/6) < (15) ? (h/6) : (15)); // min(h/6, 15);
  int h_flat = h - h_top - h_bottom;
  float step_size_top = h_top > 1 ? (0.999f/float(h_top)) : 1;
  float step_size_bottom = h_bottom > 1 ? (0.999f/float(h_bottom)) : 1;
  // draw the gradient at the top of the widget
  float k = 1;
  for (int i = 0; i < h_top; i++, k -= step_size_top) {
    cgleam_gleam_color(fl_color_average(fl_color_average(fg1, fg2, th), fg1, k));
    fl_xyline(x, y+i, x+w-1);
  }

  // draw a "flat" rectangle in the middle area of the box
  cgleam_gleam_color(fg1);
  fl_rectf(x, y + h_top, w, h_flat);

  // draw the gradient at the bottom of the widget
  k = 1;
  for (int i = 0; i < h_bottom; i++, k -= step_size_bottom) {
    cgleam_gleam_color(fl_color_average(fg1, fl_color_average(fg1, fg2, th), k));
    fl_xyline(x, y+h_top+h_flat+i, x+w-1);
  }
}

// See shade_rect_top_bottom()
void cgleam_shade_rect_top_bottom_up(int x, int y, int w, int h, Fl_Color bc, float th) {
  cgleam_shade_rect_top_bottom(x, y, w, h, bc, CONTRAST_COLOR, th);
}

// See shade_rect_top_bottom()
void cgleam_shade_rect_top_bottom_down(int x, int y, int w, int h, Fl_Color bc, float th) {
  cgleam_shade_rect_top_bottom(x, y, w, h, bc, FL_BLACK, th);
}

// Draw box borders. Color arguments:
// - fg1: outer border line (left, right, top, bottom)
// - fg2: inner border line (left, right)
// - lc : inner border line (top, bottom)

void cgleam_frame_rect(int x, int y, int w, int h, Fl_Color fg1, Fl_Color fg2, Fl_Color lc) {
  // outer border line:
  cgleam_gleam_color(fg1);
  fl_xyline(x+1,   y,     x+w-2);   // top
  fl_yxline(x+w-1, y+1,   y+h-2);   // right
  fl_xyline(x+1,   y+h-1, x+w-2);   // bottom
  fl_yxline(x,     y+1,   y+h-2);   // left

  // inner border line (left, right):
  cgleam_gleam_color(fg2);
  fl_yxline(x+1,   y+2,   y+h-3);   // left
  fl_yxline(x+w-2, y+2,   y+h-3);   // right

  // inner border line (top, bottom):
  cgleam_gleam_color(lc);
  fl_xyline(x+2,   y+1,   x+w-3);   // top
  fl_xyline(x+2,   y+h-2, x+w-3);   // bottom
}

// Draw box borders with different colors (up/down effect).

void cgleam_frame_rect_up(int x, int y, int w, int h, Fl_Color bc, Fl_Color lc, float th1, float th2) {
  cgleam_frame_rect(x, y, w, h, bc, lc, lc);
}

void cgleam_frame_rect_down(int x, int y, int w, int h, Fl_Color bc, Fl_Color lc, float th1, float th2) {
  cgleam_frame_rect(x,y,w,h,fl_color_average(bc, FL_WHITE, th1), fl_color_average(FL_BLACK, bc, th2), lc);
}

// Draw the different box types. These are the actual box drawing functions.

void cgleam_up_box(int x, int y, int w, int h, Fl_Color c) {
  cgleam_shade_rect_top_bottom_up(x, y, w, h, c, .15f);
  cgleam_frame_rect_up(x, y, w, h, CONTRAST_COLOR, fl_lighter(CONTRAST_COLOR), .15f, .05f);
}

void cgleam_thin_up_box(int x, int y, int w, int h, Fl_Color c) {
  cgleam_shade_rect_top_bottom_up(x, y, w, h, c, .25f);
  cgleam_frame_rect_up(x, y, w, h, CONTRAST_COLOR, fl_lighter(CONTRAST_COLOR), .25f, .15f);
}

void cgleam_down_box(int x, int y, int w, int h, Fl_Color c) {
  cgleam_shade_rect_top_bottom_down(x, y, w, h, c, .65f);
  cgleam_frame_rect_down(x, y, w, h, c, fl_color_average(c, FL_BLACK, .05f), .05f, .95f);
}
