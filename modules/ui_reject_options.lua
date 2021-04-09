------------------------------------------------------------------------
--  PANEL: REJECT Builder Options
------------------------------------------------------------------------
--
--  Copyright (C) 2021 Dashodanger
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

UI_REJECT_OPTIONS = { }

UI_REJECT_OPTIONS.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No"),
}

OB_MODULES["ui_reject_options"] =
{
  label = _("Map Build Options"),
  
  engine = { vanilla=0, nolimit=1, boom=1, prboom=1, woof=1, zdoom=0 },

  side = "left",
  priority = 105,

  options =
  {
    {
      name = "build_reject",
      label = _("Build REJECT"),
      choices = UI_REJECT_OPTIONS.YES_NO,
      default = "no",
      tooltip = "Choose to build a proper REJECT lump. WARNING: This can be very time consuming!",
    }
  }
}
