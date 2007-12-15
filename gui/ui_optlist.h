//------------------------------------------------------------------------
//  Option list widget
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#ifndef __UI_OPTLIST_H__
#define __UI_OPTLIST_H__

//
// DESCRIPTION:
//   The widget keeps a list of options, which at any time can
//   be either enabled or disabled (for viewing).
//
//   The list will be converted into a scrolling FL_Pack of
//   checkbox widgets, whose values will be reflected in the
//   actual list of options.
//
//   The option list can be iterated over to change the status
//   (enabled or disabled), as well as reading the values for
//   saving into the config file or setting up the LUA state
//   before a build.
//

class option_data_c
{
friend class UI_OptionList;

public:
  const char *id;     // terse identifier
  const char *label;  // description (for the UI)
 
  int shown;      // 0 = hidden, 1 = shown, -1 = greyed out
  int value;      // 0 or 1

  int priority;   // priority for on-screen ordering
 
protected:
  Fl_Check_Button *widget;
 
public:
   option_data_c() : id(NULL), label(NULL), shown(0), value(-1),
                     priority(50), widget(NULL)
   { }
   
   option_data_c(const char *_id, const char *_label, int _pri = 50, int _val = 0);
 
   ~option_data_c();
};


typedef void (* option_iter_f)(option_data_c *opt, void *data);


class UI_OptionList : public Fl_Scroll
{
private:

  std::vector<option_data_c *> opt_list;
 
public:
  UI_OptionList(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_OptionList();

public:
  void AddOption(const char *id, const char *label, int pri = 50, int val = 0);
  // add a new option to the list.  If an option with the same 'id'
  // already exists, that option is replaced instead.
  // The option will begin as not shown (shown == 0).

  bool SetOption(const char *id, int value);

  bool ShowOption(const char *id, int shown);

  void IterateOptions(option_iter_f func, void *data);

  void Commit();
  // this must be called after any changes to the option list
  // have been made.

private:
  option_data_c *FindOption(const char *id);

};


#endif /* __UI_OPTLIST_H__ */
