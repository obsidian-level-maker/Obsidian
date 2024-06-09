#ifndef OBSIDIAN_UI_BOXES_H_
#define OBSIDIAN_UI_BOXES_H_
// Headers for custom FLTK box drawing routines so that Theme colors are honored
// - Dasho

#include <FL/Enumerations.H>

void coxy_up_box(int x, int y, int w, int h, Fl_Color bg);
void coxy_down_box(int x, int y, int w, int h, Fl_Color bg);

void cgleam_gleam_color(Fl_Color c);
void cgleam_shade_rect_top_bottom(int x, int y, int w, int h, Fl_Color fg1, Fl_Color fg2, float th);
void cgleam_shade_rect_top_bottom_up(int x, int y, int w, int h, Fl_Color bc, float th);
void cgleam_shade_rect_top_bottom_down(int x, int y, int w, int h, Fl_Color bc, float th);
void cgleam_frame_rect(int x, int y, int w, int h, Fl_Color fg1, Fl_Color fg2, Fl_Color lc);
void cgleam_frame_rect_up(int x, int y, int w, int h, Fl_Color bc, Fl_Color lc, float th1, float th2);
void cgleam_frame_rect_down(int x, int y, int w, int h, Fl_Color bc, Fl_Color lc, float th1, float th2);
void cgleam_up_box(int x, int y, int w, int h, Fl_Color c);
void cgleam_thin_up_box(int x, int y, int w, int h, Fl_Color c);
void cgleam_down_box(int x, int y, int w, int h, Fl_Color c);

void cgtk_up_frame(int x, int y, int w, int h, Fl_Color c);
void cgtk_up_box(int x, int y, int w, int h, Fl_Color c);
void cgtk_down_frame(int x, int y, int w, int h, Fl_Color c);
void cgtk_down_box(int x, int y, int w, int h, Fl_Color c);
void cgtk_thin_up_frame(int x, int y, int w, int h, Fl_Color c);
void cgtk_thin_up_box(int x, int y, int w, int h, Fl_Color c);

Fl_Color cplastic_shade_color(uchar gc, Fl_Color bc);
void     cplastic_frame_rect(int x, int y, int w, int h, const char *c, Fl_Color bc);
void     cplastic_shade_rect(int x, int y, int w, int h, const char *c, Fl_Color bc);
void     cplastic_up_frame(int x, int y, int w, int h, Fl_Color c);
void     cplastic_narrow_thin_box(int x, int y, int w, int h, Fl_Color c);
void     cplastic_thin_up_box(int x, int y, int w, int h, Fl_Color c);
void     cplastic_up_box(int x, int y, int w, int h, Fl_Color c);
void     cplastic_down_frame(int x, int y, int w, int h, Fl_Color c);
void     cplastic_down_box(int x, int y, int w, int h, Fl_Color c);

void cshadow_frame(int x, int y, int w, int h, Fl_Color c);
void cshadow_box(int x, int y, int w, int h, Fl_Color c);

void crectbound(int x, int y, int w, int h, Fl_Color bgcolor);

void cframe(int x, int y, int w, int h);
void cframe2(int x, int y, int w, int h);
void cframe3(const char *s, int x, int y, int w, int h);
void cthin_up_frame(int x, int y, int w, int h, Fl_Color);
void cthin_up_box(int x, int y, int w, int h, Fl_Color c);
void cup_frame(int x, int y, int w, int h, Fl_Color);
void cup_box(int x, int y, int w, int h, Fl_Color c);
void cdown_frame(int x, int y, int w, int h, Fl_Color);
void cdown_box(int x, int y, int w, int h, Fl_Color c);
void cengraved_frame(int x, int y, int w, int h, Fl_Color);
void cengraved_box(int x, int y, int w, int h, Fl_Color c);
void cembossed_frame(int x, int y, int w, int h, Fl_Color);
void cembossed_box(int x, int y, int w, int h, Fl_Color c);

#endif
