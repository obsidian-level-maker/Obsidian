//
// Definition of the Wayland Screen interface
// for the Fast Light Tool Kit (FLTK).
//
// Copyright 2010-2023 by Bill Spitzak and others.
//
// This library is free software. Distribution and use rights are outlined in
// the file "COPYING" which should have been included with this file.  If this
// file is missing or damaged, see the license at:
//
//     https://www.fltk.org/COPYING.php
//
// Please see the following page on how to report bugs and issues:
//
//     https://www.fltk.org/bugs.php
//

/**
 \file Fl_Wayland_Screen_Driver.H
 \brief Definition of Wayland Screen interface
 */

#ifndef FL_WAYLAND_SCREEN_DRIVER_H
#define FL_WAYLAND_SCREEN_DRIVER_H

#include "../Unix/Fl_Unix_Screen_Driver.H"
#include <wayland-client.h>

class Fl_Window;

class Fl_Wayland_Screen_Driver : public Fl_Unix_Screen_Driver
{
  friend class Fl_Screen_Driver;
private:
  static int insertion_point_x;
  static int insertion_point_y;
  static int insertion_point_width;
  static int insertion_point_height;
  static bool insertion_point_location_is_valid;
public:
// type definitions
  typedef enum {unspecified, MUTTER, WESTON, KDE, OWL} compositor_name;
  struct seat {
    struct wl_seat *wl_seat;
    struct wl_pointer *wl_pointer;
    struct wl_keyboard *wl_keyboard;
    uint32_t keyboard_enter_serial;
    struct wl_surface *keyboard_surface;
    struct wl_list pointer_outputs;
    struct wl_cursor_theme *cursor_theme;
    struct wl_cursor *default_cursor;
    struct wl_surface *cursor_surface;
    struct wl_surface *pointer_focus;
    int pointer_scale;
    uint32_t serial;
    uint32_t pointer_enter_serial;
    struct wl_data_device_manager *data_device_manager;
    struct wl_data_device *data_device;
    struct wl_data_source *data_source;
    struct xkb_state *xkb_state;
    struct xkb_context *xkb_context;
    struct xkb_keymap *xkb_keymap;
    struct xkb_compose_state *xkb_compose_state;
    char *name;
    struct zwp_text_input_v3 *text_input;
  };
  struct output { // one record for each screen
    uint32_t id;
    int x, y; // logical position of screen
    int width; // in pixels
    int height; // in pixels
    float dpi;
    struct wl_output *wl_output;
    int wld_scale; // Wayland scale factor
    float gui_scale; // FLTK scale factor
    struct wl_list link;
  };

// static member variables
  static FL_EXPORT struct wl_display *wl_display;
  static const struct wl_data_device_listener *p_data_device_listener;
  // next length of marked text after current marked text will have been replaced
  static int next_marked_length;
  static compositor_name compositor; // identifies the used Wayland compositor

// static member functions
  static void insertion_point_location(int x, int y, int height);
  static bool insertion_point_location(int *px, int *py, int *pwidth, int *pheight);
  static bool own_output(struct wl_output *output);

// member variables
  struct wl_cursor *xc_arrow;
  struct wl_cursor *xc_ns;
  struct wl_cursor *xc_wait;
  struct wl_cursor *xc_insert;
  struct wl_cursor *xc_hand;
  struct wl_cursor *xc_help;
  struct wl_cursor *xc_cross;
  struct wl_cursor *xc_move;
  struct wl_cursor *xc_north;
  struct wl_cursor *xc_south;
  struct wl_cursor *xc_west;
  struct wl_cursor *xc_east;
  struct wl_cursor *xc_we;
  struct wl_cursor *xc_nesw;
  struct wl_cursor *xc_nwse;
  struct wl_cursor *xc_sw;
  struct wl_cursor *xc_se;
  struct wl_cursor *xc_ne;
  struct wl_cursor *xc_nw;
  struct wl_registry *wl_registry;
  struct wl_compositor *wl_compositor;
  struct wl_subcompositor *wl_subcompositor;
  struct wl_shm *wl_shm;
  struct seat *seat;
  struct wl_list outputs; // linked list of struct output records for all screens in system
  struct libdecor *libdecor_context;
  struct xdg_wm_base *xdg_wm_base;
  struct zwp_text_input_manager_v3 *text_input_base;

// constructor
  Fl_Wayland_Screen_Driver();

// overridden functions from parent class Fl_Screen_Driver
  APP_SCALING_CAPABILITY rescalable() FL_OVERRIDE { return PER_SCREEN_APP_SCALING; }
  float scale(int n) FL_OVERRIDE;
  void scale(int n, float f) FL_OVERRIDE;
  // --- screen configuration
  void init() FL_OVERRIDE;
  int x() FL_OVERRIDE;
  int y() FL_OVERRIDE;
  int w() FL_OVERRIDE;
  int h() FL_OVERRIDE;
  void screen_xywh(int &X, int &Y, int &W, int &H, int n) FL_OVERRIDE;
  void screen_dpi(float &h, float &v, int n=0) FL_OVERRIDE;
  void screen_work_area(int &X, int &Y, int &W, int &H, int n) FL_OVERRIDE;
  // --- audible output
  void beep(int type) FL_OVERRIDE;
  // --- global events
  void flush() FL_OVERRIDE;
  void grab(Fl_Window* win) FL_OVERRIDE;
  // --- global colors
  void get_system_colors() FL_OVERRIDE;
  const char *get_system_scheme() FL_OVERRIDE;
  // this one is in fl_wayland_clipboard_dnd.cxx
  int dnd(int unused) FL_OVERRIDE;
  int compose(int &del) FL_OVERRIDE;
  void compose_reset() FL_OVERRIDE;
  Fl_RGB_Image *read_win_rectangle(int X, int Y, int w, int h, Fl_Window *win, bool may_capture_subwins, bool *did_capture_subwins) FL_OVERRIDE;
  int get_mouse(int &x, int &y) FL_OVERRIDE;
  void open_display_platform() FL_OVERRIDE;
  void close_display() FL_OVERRIDE;
  void display(const char *d) FL_OVERRIDE;
  // --- compute dimensions of an Fl_Offscreen
  void offscreen_size(Fl_Offscreen o, int &width, int &height) FL_OVERRIDE;
  int has_marked_text() const FL_OVERRIDE;
  // --- clipboard operations
  // this one is in fl_wayland_clipboard_dnd.cxx
  void copy(const char *stuff, int len, int clipboard, const char *type) FL_OVERRIDE;
  // this one is in fl_wayland_clipboard_dnd.cxx
  void paste(Fl_Widget &receiver, int clipboard, const char *type) FL_OVERRIDE;
  // this one is in fl_wayland_clipboard_dnd.cxx
  int clipboard_contains(const char *type) FL_OVERRIDE;
  void set_spot(int font, int height, int x, int y, int w, int h, Fl_Window *win) FL_OVERRIDE;
  void reset_spot() FL_OVERRIDE;
  void *control_maximize_button(void *data) FL_OVERRIDE;
  int event_key(int k) FL_OVERRIDE;
  int get_key(int k) FL_OVERRIDE;
  void enable_im() FL_OVERRIDE;
  void disable_im() FL_OVERRIDE;

// Wayland-specific member functions
  void screen_count_set(int count) {num_screens = count;}
  void reset_cursor();
  // this one is in fl_wayland_clipboard_dnd.cxx
  void copy_image(const unsigned char* data, int W, int H);
  void init_workarea();
  void set_cursor();
  struct wl_cursor *default_cursor();
  void default_cursor(struct wl_cursor *cursor);
  struct wl_cursor *cache_cursor(const char *cursor_name);
  uint32_t get_serial();
  struct wl_seat *get_wl_seat();
  char  *get_seat_name();
  struct xkb_keymap *get_xkb_keymap();
};


#endif // FL_WAYLAND_SCREEN_DRIVER_H
