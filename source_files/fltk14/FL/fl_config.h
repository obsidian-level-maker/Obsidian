/* FL/fl_config.h.  Generated from fl_config.cmake.in by CMake.  */
/*
 * Build configuration file for the Fast Light Tool Kit (FLTK).
 *
 * Copyright 1998-2021 by Bill Spitzak and others.
 *
 * This library is free software. Distribution and use rights are outlined in
 * the file "COPYING" which should have been included with this file.  If this
 * file is missing or damaged, see the license at:
 *
 *     https://www.fltk.org/COPYING.php
 *
 * Please see the following page on how to report bugs and issues:
 *
 *     https://www.fltk.org/bugs.php
 */

#ifndef _FL_fl_config_h_
#define _FL_fl_config_h_

/*
 * FL_ABI_VERSION (ABI version):
 *
 * define FL_ABI_VERSION: 1xxyy for 1.x.y (xx,yy with leading zero)
*/

/* #undef FL_ABI_VERSION */


/*
 * FLTK_HAVE_CAIRO
 *
 * Do we have the Cairo library available?
*/

/* #undef FLTK_HAVE_CAIRO */


/*
 * FLTK_HAVE_CAIROEXT
 *
 * Do we have the Cairo library available and want extended Cairo use in FLTK ?
 * This implies to link cairo.lib in all FLTK based apps.
*/

/* #undef FLTK_HAVE_CAIROEXT */


/*
 * FLTK_USE_X11
 *
 * Do we use X11 for the current platform?
 *
 */

/* #undef FLTK_USE_X11 */


/*
 * FLTK_USE_WAYLAND
 *
 * Do we use Wayland for the current platform?
 *
 */

/* #undef FLTK_USE_WAYLAND */

#endif /* _FL_fl_config_h_ */
