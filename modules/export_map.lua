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


function EXPORT_MAP.setup()
  gui.mkdir("debug")  

  -- clean up any previous run which got cancelled or aborted
  if EXPORT_MAP.file then
    EXPORT_MAP.file:close()
    EXPORT_MAP.file = nil
  end
end


function EXPORT_MAP.begin_level()
  -- pre-built levels cannot be exported
  if LEVEL.prebuilt then return end  

  local filename = string.format("debug/%s.map", LEVEL.name)
  local error_msg

  gui.printf("Creating new file: %s\n", filename)

  local file, error_msg = io.open(filename, "w")

  if not file then
    gui.printf("Failed to create file: %s\n", tostring(error_msg))
    return
  end

  EXPORT_MAP.file = file

  file:write("// this MAP file was created by OBLIGE.\n")
  file:write("// it is only for the purpose of debugging.\n")
end


function EXPORT_MAP.end_level()
  local file = EXPORT_MAP.file

  if not file then return end  

  file:write("// The End\n")

  EXPORT_MAP.file:close()
  EXPORT_MAP.file = nil
end


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

