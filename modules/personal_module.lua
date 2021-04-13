------------------------------------------------------------------------
--  MODULE: Personal Module Template
------------------------------------------------------------------------
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

PERSONAL_MODULE = {}

function PERSONAL_MODULE.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end
end


function PERSONAL_MODULE.begin_level()
  --gui.printf("LEVEL: " .. table.tostr(LEVEL, 2) .. "\n")

  for _,I in pairs(GAME.PICKUPS) do
    if I.kind == "ammo" then
      I.closet_prob = 0
      I.secret_prob = 0
    end
  end
end


OB_MODULES["personal_module"] =
{
  label = _("Personal Module"), -- Module's GUI display name.

  engine = "zdoom",
  game = "doomish",

  side = "right",
  priority = -100,

  hooks =
  {
    setup = PERSONAL_MODULE.setup,
    begin_level = PERSONAL_MODULE.begin_level
  }
}
