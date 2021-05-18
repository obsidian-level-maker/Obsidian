//------------------------------------------------------------------------
//  Remember Choice widget
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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

#ifndef __UI_RCHOICE_H__
#define __UI_RCHOICE_H__

#include <map>

#include "FL/Fl_Check_Button.H"
#include "FL/Fl_Choice.H"
#include "FL/Fl_Hor_Slider.H"
#include "FL/Fl_Repeat_Button.H"

//
// DESCRIPTION:
//   A sub-classed Fl_Choice widget which remembers an 'id'
//   string associated with each selectable value, and allows
//   these ids and labels to be updated at any time.
//

class choice_data_c {
    friend class UI_RChoice; // Don't know if the 'group' for the menu needs to be a friend as well
    friend class UI_RChoiceMenu;

   public:
    const char *id;     // terse identifier
    const char *label;  // description (for the UI)

    bool enabled;  // shown to the user

    // the index in the current list, or -1 if not present
    int mapped;

    Fl_Check_Button *widget;

   public:
    choice_data_c(const char *_id = NULL, const char *_label = NULL);
    ~choice_data_c();
};

class UI_HelpLink : public Fl_Button {
   private:
    // true when mouse is over this widget
    bool hover;

    // area containing the label
    int label_X, label_Y, label_W, label_H;

   public:
    UI_HelpLink(int x, int y, int w, int h, const char *label);
    virtual ~UI_HelpLink();
    
    const char* help_text;

   public:
    // FLTK overrides

    int handle(int event);

    void draw();

   private:
    void checkLink();

};

class UI_CustomMenu : public Fl_Choice {

   private:

   public:
    UI_CustomMenu(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_CustomMenu();
    
   private:
	void draw();
};

class UI_RChoiceMenu : public UI_CustomMenu {
   private:
    std::vector<choice_data_c *> opt_list;

   public:
    UI_RChoiceMenu(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_RChoiceMenu(); 

   public:
    // add a new choice to the list.  If a choice with the same 'id'
    // already exists, it is just replaced instead.
    // The choice will begin disabled (shown == false).
    void AddChoice(const char *id, const char *label);

    // finds the option with the given ID, and update its 'enabled'
    // value.  Returns true if successful, or false if no such
    // option exists.  Any change will call Recreate().
    bool EnableChoice(const char *id, bool enable_it);

    // get the id string for the currently shown value.
    // Returns the string "none" if there are no choices.
    const char *GetID() const;

    // change the currently shown value via the new 'id'.
    // If does not exist, returns false and nothing was changed.
    bool ChangeTo(const char *id);

    const char *GetLabel() const;

    choice_data_c *FindID(const char *id) const;

   private:
    choice_data_c *FindMapped() const;

    // call this to update the available choices to reflect their
    // 'shown' values.  If the previous selected item is still
    // valid, it remains set, otherwise we try and find a shown
    // value with the same label, and failing that: select the
    // first entry.
    void Recreate();

    //	const char *GetLabel() const;  // ????

    void GotoPrevious();
    void GotoNext();
};

class UI_RChoice : public Fl_Group {
   private:

   public:
    UI_RChoice(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_RChoice(); 

   public:
   
    Fl_Box *mod_label;
    
    UI_HelpLink *mod_help;    
    
    UI_RChoiceMenu *mod_menu;    

   private:
   
};

class UI_CustomArrowButton : public Fl_Repeat_Button {

   private:

   public:
    UI_CustomArrowButton(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_CustomArrowButton();
    
   private:
	void draw();
};

class UI_RSlide : public Fl_Group {
   private:

       
   public:
    UI_RSlide(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_RSlide();
    
    Fl_Box *mod_label;
    
    UI_HelpLink *mod_help;
    
    Fl_Hor_Slider *mod_slider;
    
    UI_CustomArrowButton *prev_button;
    
    UI_CustomArrowButton *next_button;
    
    std::string original_label;
    
    std::string units;
    
    std::map<double, std::string> nan_choices;
};

class UI_CustomCheckBox : public Fl_Check_Button {
  
   private:

   public:
    UI_CustomCheckBox(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_CustomCheckBox();
    
   private:
   void draw();
};

class UI_RButton : public Fl_Group {
   private:


   public:
    UI_RButton(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_RButton();
    
    UI_CustomCheckBox *mod_check;
    
    Fl_Box *mod_label;
    
    UI_HelpLink *mod_help;
    
   private:

};

#endif /* __UI_RCHOICE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
