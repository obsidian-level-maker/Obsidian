------------------------------------------------------------------------
--  MODULE: Addon Module Template
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

TEMPLATE_MODULE = {}

TEMPLATE_MODULE.CHOICES =
{
  "yes", _("Yes"),
  "no",  _("No"),
}

function TEMPLATE_MODULE.setup(self)
  -- this loop initializes all the
  -- selected options in the moduloe
  -- by the user to be instantiated
  -- into the PARAM's global table

  -- this is not actually necessary to have
  -- unless some info is expected to be used
  -- in the core level building scripts
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  if PARAM.activate_this and PARAM.activate_this == "yes" then
    -- example things that can be done:

    -- insert a new shape rule into the shape grammars list
    SHAPE_GRAMMAR["GROW_FUNKY_LONG_CORRIDOR"] =
    {
      name = "GROW_FUNKY_LONG_CORRIDOR"
      prob = 2147483647
      use_prob = 2147483647

      structure =
      {
        "....",".11."
        "....",".11."
        "#..#","#11#"
        "#..#","#11#"
        "#..#","#11#"
        "#..#","#11#"
        "#..#","#11#"
        "#..#","#11#"
        "#..#","#11#"
        "x11x","x11x"
        "x11x","x11x"
      }
    }

  end
end


function TEMPLATE_MODULE.do_funky_things() --begin_level
  if PARAM.activate_this and PARAM.activate_this == "yes" then
    -- cause most item closets to become the toilet fab
    PREFABS["Item_closet_toilet_room_small_gz"].rank = 1
    PREFABS["Item_closet_toilet_room_small_gz"].theme = "any"
    gui.printf("All item closets are now toilets! Yay!\n") -- these print statements are found in the LOGS.txt
  end
end


OB_MODULES["template_module"] =
{
  label = _("Template Module") -- Module's GUI display name.

  engine = "zdoom"
  game = "doomish"

  side = "right" -- Horizontal position of the module in the GUI (left or right column)
  priority = -100 -- Vertical position of the module in the GUI, larger number means higher

  tooltip = "This is a template module for custom Oblige addons."

  hooks = -- Hooks are calls from the level generation process that allows you
          -- to attach new functions after the generator reaches certain states
          -- therefore modifying aspects of generator behavior
  {
    --[[ available hooks are:

      setup                   - called before tables are loaded. Initialize your module parameters here.

      get_levels              - called when the initial episode and level list is instantiated.
                              - e.g. Modules such as Armaetus' Textures inserts new data into themes and materials
                              - tables during this stage

      get_levels_after_themes - called when levels have been named and themes assigned but not yet built.
                              - e.g. The Sky Generator module has the option of creating skies based on the first
                              - level of an episode and uses this hook.

      begin_level             - called each time individual map building is about to start.
                              - e.g. Armaetus's Textures overrides outdoor texture themes here to become snow or
                              - desert environments. This 'overwrite' is lost before the next level's building.

      end_level               - called each time individual map building ends.
                              - e.g. The Modded Games Extras module compiles information from the level to generate
                              - Hellscape Navigator markers during this period.

      all_done                - called when all levels have been built.
                              - e.g. The ZDoom MAPINFO is generated during this period and merged into the WAD.
    ]]
    setup = TEMPLATE_MODULE.setup
    begin_level = TEMPLATE_MODULE.do_funky_things
  }

  options =
  {
    activate_this =
    {
      name = "activate_this"
      label = _("Activate Module")
      priority = 7
      tooltip = "This is a description of this option."
      choices = TEMPLATE_MODULE.CHOICES
      default = "yes"
      gap = 1
    }
  }
}
