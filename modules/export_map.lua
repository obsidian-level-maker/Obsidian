----------------------------------------------------------------
--  MODULE: Export to .MAP format
----------------------------------------------------------------
--
--  Copyright (C) 2011 Andrew Apted
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
----------------------------------------------------------------

EXPORT_MAP = {}


function export_printf(fmt, ...)
  table.insert(EXPORT_MAP.ent_data, string.format(fmt, ...))
end


function EXPORT_MAP.add_brush(coords)
  local file = EXPORT_MAP.file

  if not file then return end  

  -- FIXME !!!!!!

  fprintf(file, "// brush %s %d\n", coords[1].m or "solid", #coords)
end


function EXPORT_MAP.add_entity(ent)
  local file = EXPORT_MAP.file

  if not file then return end  

  export_printf("{\n")

  local origin

  each key, value in ent do

    -- special handling for the origin
    if key == "x" or key == "y" or key == "z" then
      if not origin then origin = {} end
      origin[key] = value
      continue
    end

    local key2 = key

    if key2 == "id" then key2 = "classname" end

    export_printf("\"%s\" \"%s\"\n", tostring(key2), tostring(value))
  end

  if origin then
    export_printf("\"origin\" \"%d %d %d\"\n", origin.x or 0, origin.y or 0, origin.z or 0)
  end

  export_printf("}\n")
end


function EXPORT_MAP.add_model(model)
  local file = EXPORT_MAP.file

  if not file then return end  

  -- FIXME !!!

  export_printf("// model %s\n", model.entity.id)
end


function EXPORT_MAP.setup()
  gui.mkdir("debug")  

  -- clean up any previous run which got cancelled or aborted
  if EXPORT_MAP.file then
    EXPORT_MAP.file:close()
    EXPORT_MAP.file = nil
  end

  -- setup hooks
  GAME.add_brush_func  = EXPORT_MAP.add_brush
  GAME.add_entity_func = EXPORT_MAP.add_entity
  GAME.add_model_func  = EXPORT_MAP.add_model
end


function EXPORT_MAP.begin_level()
  -- pre-built levels cannot be exported
  if LEVEL.prebuilt then return end  

  local filename = string.format("debug/%s.map", LEVEL.name)

  local file, error_msg = io.open(filename, "w")

  if not file then
    gui.printf("Failed to create file: %s\n", tostring(error_msg))
    return
  end

  gui.printf("Started .MAP export to file: %s\n", filename)

  EXPORT_MAP.file = file
  EXPORT_MAP.ent_data = {}

  fprintf(file, "// this MAP file was created by OBLIGE.\n")
  fprintf(file, "// it is only for the purpose of debugging.\n")

  -- write the worldspawn entity
  fprintf(file, "{\n")
  fprintf(file, "\"classname\" \"worldspawn\"\n")
  fprintf(file, "\"worldtype\" \"0\"\n")  -- FIXME
 
  -- TODO: "message" : LEVEL.description
end


function EXPORT_MAP.end_level()
  local file = EXPORT_MAP.file

  if not file then return end  

  -- close off the worldspawn entity
  fprintf(file, "}\n")

  -- write the entity data
  each str in EXPORT_MAP.ent_data do
    fprintf(file, "%s", str)
  end

  fprintf(file, "// The End\n")

  EXPORT_MAP.file:close()
  EXPORT_MAP.file = nil
  EXPORT_MAP.ent_data = nil

  gui.printf("Finished .MAP export\n")
end


----------------------------------------------------------------


OB_MODULES["export_map"] =
{
  label = "Export .MAP for Debugging"

  priority = -75

  tables =
  {
    EXPORT_MAP
  }

  hooks =
  {
    setup       = EXPORT_MAP.setup
    begin_level = EXPORT_MAP.begin_level
    end_level   = EXPORT_MAP.end_level
  }
}

