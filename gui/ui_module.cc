//----------------------------------------------------------------
//  Custom Mod list
//----------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_util.h"

#include "g_lua.h"


#define MY_PURPLE  fl_rgb_color(208,0,208)


class My_ClipGroup : public Fl_Group
{
public:
  My_ClipGroup(int X, int Y, int W, int H, const char *L = NULL) :
      Fl_Group(X, Y, W, H, L)
  {
    clip_children(1);
  }

  virtual ~My_ClipGroup()
  { }
};


//-----------------------------------------------------------------


UI_Module::UI_Module(int x, int y, int w, int h,
                     const char *id, const char *label) :
    Fl_Group(x, y, w, h),
    id_name(id),
    choice_map()
{
  end(); // cancel begin() in Fl_Group constructor
 
//  box(FL_SHADOW_BOX);
//  box(FL_BORDER_BOX);
  box(FL_FLAT_BOX);
  color(FL_RED);
  resizable(NULL);


  enabler = new Fl_Check_Button(x, y+4, w, 24, label);

  add(enabler);

 

//!!!!!!  hide();
}


UI_Module::~UI_Module()
{
}


void UI_Module::AddOption(const char *id, const char *label, const char *choices)
{
return; //!!!!!

  int nw = 120;
  int nh = 28;

  int nx = x() + parent()->w()/2;
  int ny = y() + children() * nh;

  // FIXME: make label with ': ' suffixed

fprintf(stderr, "AddOption: x, y = %d,%d\n", x(), y());
  UI_RChoice *rch = new UI_RChoice(nx, ny, nw, nh-4, label);

  rch->align(FL_ALIGN_LEFT);
  rch->selection_color(MY_PURPLE);

  add(rch);

  choice_map[id] = rch;
  

  rch->AddPair("foo", "Foo");
  rch->AddPair("bar", "Bar");
  rch->AddPair("jim", "Jimmy");

  rch->ShowOrHide("foo", 1);
  rch->ShowOrHide("bar", 1);
  rch->ShowOrHide("jim", 1);

  rch->redraw();

  redraw();
}



//----------------------------------------------------------------


UI_ModBox::UI_ModBox(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);



  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Custom Mods");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;



  // area for module list
  mx = x+4;
  my = cy;
  mw = w-4 - Fl::scrollbar_size();
  mh = y+h-cy;

fprintf(stderr, "MLIST AREA: (%d,%d)  %dx%d\n", mx, my, mw, mh);

  sbar = new Fl_Scrollbar(mx+mw, my, Fl::scrollbar_size(), mh);
//!!!  sbar->callback(callback_Scroll);

  add(sbar);


  mod_pack = new My_ClipGroup(mx, my, mw, mh);
  mod_pack->end();

  mod_pack->box(FL_FLAT_BOX);
  mod_pack->color(FL_BLUE);
  mod_pack->resizable(NULL);


  add(mod_pack);
}


UI_ModBox::~UI_ModBox()
{
}


#if 0
void UI_ModBox::callback_Module(option_data_c *opt, void *data)
{
//  UI_ModBox *that = (UI_ModBox *)data;

  DebugPrintf("UI_ModBox: callback for %s\n", opt->id);

  // TODO: make a method in option_data_c
  Script_SetConfig(opt->id, opt->widget->value() ? "true" : "false");
}
#endif


void UI_ModBox::AddModule(const char *id, const char *label)
{
  UI_Module *M = new UI_Module(mx, my, mw, 130, id, label);

  mod_pack->add(M);


  M->AddOption("a", "Dead Cacodemons: ", "Bleh");
  M->AddOption("b", "Lots of Cyberdemons: ", "Bleh");
  M->AddOption("c", "Do not add crates: ", "Bleh");
//  M->AddOption("d", "Foundation: ", "Bleh");


  PositionAll(my);

  M->redraw();
  mod_pack->redraw();
}


bool UI_ModBox::ShowOrHide(const char *id, bool new_shown)
{
  SYS_ASSERT(id);

  UI_Module *M = FindID(id);

  if (! M)
    return false;

  if (1) //!!!! M->visible() != (new_shown ? 1:0))
  {
    if (new_shown)
      M->show();
    else
      M->hide();

    PositionAll(my);

    M->redraw();
    mod_pack->redraw();
  }

  return true;
}


int UI_ModBox::PositionAll(int start_y)
{
fprintf(stderr, "PositionAll:\n");

  for (int j = 0; j < mod_pack->children(); j++)
  {
    UI_Module *M = (UI_Module *) mod_pack->child(j);
    SYS_ASSERT(M);

    int ny = start_y;
    int nh = M->visible() ? 30 : 0; //!!!!!!!
  
    if (ny != M->y() || nh != M->h())
    {
fprintf(stderr, "  SETTING WIDGET TO: (%d,%d) %dx%d\n", M->x(), ny, M->w(), MAX(1, nh));
      M->resize(M->x(), ny, M->w(), MAX(1, nh));


///      M->redraw();
    }
fprintf(stderr, "  %p : %s (%d,%d) %dx%d\n", M, M->visible() ? "SHOW" : "hide", M->x(), M->y(), M->w(), M->h());

    start_y += nh + (nh ? 4 : 0);
  }

  mod_pack->init_sizes();

fprintf(stderr, "  end_y = %d\n", start_y);
  return start_y; // end_y now
}


UI_Module * UI_ModBox::FindID(const char *id) const
{
  // this is awful
  for (int j = 0; j < mod_pack->children(); j++)
  {
    UI_Module *M = (UI_Module *) mod_pack->child(j);
    SYS_ASSERT(M);

    if (strcmp(M->id_name.c_str(), id) == 0)
      return M;
  }

  return NULL;
}


void UI_ModBox::Locked(bool value)
{
  if (value)
  {
    mod_pack->deactivate();
  }
  else
  {
    mod_pack->activate();
  }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
