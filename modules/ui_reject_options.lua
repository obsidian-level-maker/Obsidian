------------------------------------------------------------------------
--  PANEL: REJECT Builder Options
------------------------------------------------------------------------
--
--  Copyright (C) 2021-2022 Dashodanger
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

function UI_REJECT_OPTIONS.setup(self)
  -- these parameters have to be instantiated in this hook
  -- because begin_level happens *after* level size decisions
  for name,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          if opt.increment < 1 then
            PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
          else
            PARAM[opt.name] = int(tonumber(OB_CONFIG[opt.name]))
          end
        elseif opt.valuator == "button" then
          PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
        end
      else
        PARAM[opt.name] = OB_CONFIG[opt.name]
      end
      if RANDOMIZE_GROUPS then
        for _,group in pairs(RANDOMIZE_GROUPS) do
          if opt.randomize_group and opt.randomize_group == group then
            if opt.valuator then
              if opt.valuator == "button" then
                  PARAM[opt.name] = rand.sel(50, 1, 0)
                  goto done
              elseif opt.valuator == "slider" then
                  if opt.increment < 1 then
                    PARAM[opt.name] = rand.range(opt.min, opt.max)
                  else
                    PARAM[opt.name] = rand.irange(opt.min, opt.max)
                  end
                  goto done
              end
            else
              local index
              repeat
                index = rand.irange(1, #opt.choices)
              until (index % 2 == 1)
              PARAM[opt.name] = opt.choices[index]
              goto done
            end
          end
        end
      end
      ::done::
    else
	    if opt.valuator then
		    if opt.valuator == "button" then
		        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
		    elseif opt.valuator == "slider" then
		        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
		    end
      else
        PARAM[opt.name] = opt.value
	    end
	  end
  end
end

OB_MODULES["ui_reject_options"] =
{

  name = "ui_reject_options",

  label = _("Map Build Options"),
  
  engine = "!advanced",

  side = "left",
  priority = 105,

  hooks = 
  {
    pre_setup = UI_REJECT_OPTIONS.setup,
  },

  options =
  {
    {
      name = "bool_build_reject",
      label = _("Build REJECT"),
      valuator = "button",
      default = 0,
      tooltip = "Choose to build a proper REJECT lump.",
      longtip = "If this option is not selected, a blank REJECT lump with the proper size will be inserted into the map instead." ..
      "\n\nThis is to prevent errors with some engines that are expecting a \"full\" REJECT lump to be present."
    }
  }
}

UI_EDGE_MAP_OPTIONS = { }

function UI_EDGE_MAP_OPTIONS.setup(self)
  -- these parameters have to be instantiated in this hook
  -- because begin_level happens *after* level size decisions
  for name,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          if opt.increment < 1 then
            PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
          else
            PARAM[opt.name] = int(tonumber(OB_CONFIG[opt.name]))
          end
        elseif opt.valuator == "button" then
          PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
        end
      else
        PARAM[opt.name] = OB_CONFIG[opt.name]
      end
      if RANDOMIZE_GROUPS then
        for _,group in pairs(RANDOMIZE_GROUPS) do
          if opt.randomize_group and opt.randomize_group == group then
            if opt.valuator then
              if opt.valuator == "button" then
                  PARAM[opt.name] = rand.sel(50, 1, 0)
                  goto done
              elseif opt.valuator == "slider" then
                  if opt.increment < 1 then
                    PARAM[opt.name] = rand.range(opt.min, opt.max)
                  else
                    PARAM[opt.name] = rand.irange(opt.min, opt.max)
                  end
                  goto done
              end
            else
              local index
              repeat
                index = rand.irange(1, #opt.choices)
              until (index % 2 == 1)
              PARAM[opt.name] = opt.choices[index]
              goto done
            end
          end
        end
      end
      ::done::
    else
	    if opt.valuator then
		    if opt.valuator == "button" then
		        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
		    elseif opt.valuator == "slider" then
		        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
		    end
	    else
        PARAM[name] = self.options[name].value
      end
	  end
  end
end

OB_MODULES["ui_edge_map_options"] =
{

  name = "ui_edge_map_options",

  label = _("Map Build Options"),
  
  engine = "edge",

  side = "left",
  priority = 105,

  hooks = 
  {
    pre_setup = UI_EDGE_MAP_OPTIONS.setup,
  },

  options =
  {
    {
      name = "bool_build_nodes_edge",
      label = _("Build Nodes"),
      valuator = "button",
      default = 0,
      tooltip = "Choose to either build nodes or allow the engine itself to do so " ..
      "upon loading the map.",
      longtip = "Warning! If GL v5 nodes are needed due to map size/complexity, it is best to leave this unchecked as ZDBSP currently " ..
      "creates v5 nodes that are out of spec and will likely crash EDGE."
    }
  }
}

UI_UDMF_MAP_OPTIONS = { }

function UI_UDMF_MAP_OPTIONS.setup(self)
  -- these parameters have to be instantiated in this hook
  -- because begin_level happens *after* level size decisions
  for name,opt in pairs(self.options) do
    if OB_CONFIG.batch == "yes" then
      if opt.valuator then
        if opt.valuator == "slider" then 
          if opt.increment < 1 then
            PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
          else
            PARAM[opt.name] = int(tonumber(OB_CONFIG[opt.name]))
          end
        elseif opt.valuator == "button" then
          PARAM[opt.name] = tonumber(OB_CONFIG[opt.name])
        end
      else
        PARAM[opt.name] = OB_CONFIG[opt.name]
      end
      if RANDOMIZE_GROUPS then
        for _,group in pairs(RANDOMIZE_GROUPS) do
          if opt.randomize_group and opt.randomize_group == group then
            if opt.valuator then
              if opt.valuator == "button" then
                  PARAM[opt.name] = rand.sel(50, 1, 0)
                  goto done
              elseif opt.valuator == "slider" then
                  if opt.increment < 1 then
                    PARAM[opt.name] = rand.range(opt.min, opt.max)
                  else
                    PARAM[opt.name] = rand.irange(opt.min, opt.max)
                  end
                  goto done
              end
            else
              local index
              repeat
                index = rand.irange(1, #opt.choices)
              until (index % 2 == 1)
              PARAM[opt.name] = opt.choices[index]
              goto done
            end
          end
        end
      end
      ::done::
    else
	    if opt.valuator then
		    if opt.valuator == "button" then
		        PARAM[opt.name] = gui.get_module_button_value(self.name, opt.name)
		    elseif opt.valuator == "slider" then
		        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name)      
		    end
	    else
        PARAM[opt.name] = self.options[name].value
      end
	  end
  end
end

UI_UDMF_MAP_OPTIONS.MAP_FORMAT_CHOICES = 
{
  "binary",  _("Binary"),
  "udmf", _("UDMF"),
}

OB_MODULES["ui_udmf_map_options"] =
{

  name = "ui_udmf_map_options",

  label = _("Map Build Options"),
  
  engine = "advanced",
  engine2 = "!edge",

  side = "left",
  priority = 105,

  hooks = 
  {
    pre_setup = UI_UDMF_MAP_OPTIONS.setup,
  },

  options =
  {
    {
      name = "bool_build_nodes_udmf",
      label = _("Build Nodes"),
      valuator = "button",
      default = 0,
      tooltip = "Choose to either build nodes or allow the engine itself to do so " ..
      "upon loading the map.",
      longtip = "ZDoom is capable of building its own nodes in either Binary or UDMF.\n\n" ..
        "If Eternity is selected, nodes will always be built."
    },
    {
      name = "map_format",
      label = _("Map Format"),
      choices = UI_UDMF_MAP_OPTIONS.MAP_FORMAT_CHOICES,
      default = "udmf",
      tooltip = "Choose between UDMF and binary map format.",
    }
  }
}
