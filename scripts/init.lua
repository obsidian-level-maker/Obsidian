-- DO NOT CHANGE THIS FILE! THESE FUNCTIONS MUST ABSOLUTELY BE THE FIRST FUNCTIONS LOADED WHEN THE LUA VM STARTS UP!

function ob_traceback(msg)

    -- guard against very early errors
    if not gui or not gui.printf then
      return msg
    end
  
    gui.printf("\n")
    gui.printf("@1****** ERROR OCCURRED ******\n\n")
    gui.printf("Stack Trace:\n")
  
    local stack_limit = 40
  
    local function format_source(info)
      if not info.short_src or info.currentline <= 0 then
        return ""
      end
  
      local base_fn = string.match(info.short_src, "[^/]*$")
  
      return string.format("@ %s:%d", base_fn, info.currentline)
    end
  
    for i = 1,stack_limit do
      local info = debug.getinfo(i+1)
      if not info then break end
  
      if i == stack_limit then
        gui.printf("(remaining stack trace omitted)\n")
        break;
      end
  
      if info.what == "Lua" then
  
        local func_name = "???"
  
        if info.namewhat and info.namewhat ~= "" then
          func_name = info.name or "???"
        else
          -- perform our own search of the global namespace,
          -- since the standard LUA code (5.1.2) will not check it
          -- for the topmost function (the one called by C code)
          for k,v in pairs(_G) do
            if v == info.func then
              func_name = k
              break;
            end
          end
        end
  
        gui.printf("  %d: %s() %s\n", i, func_name, format_source(info))
  
      elseif info.what == "main" then
  
        gui.printf("  %d: main body %s\n", i, format_source(info))
  
      elseif info.what == "tail" then
  
        gui.printf("  %d: tail call\n", i)
  
      elseif info.what == "C" then
  
        if info.namewhat and info.namewhat ~= "" then
          gui.printf("  %d: c-function %s()\n", i, info.name or "???")
        end
      end
    end
  
    return msg
  end

  function ob_datetime_string()
    local current_date = os.date("*t")
  
    local formatstring
  
    if current_date.month < 10 then
      formatstring = "0" .. current_date.month
    else
      formatstring = current_date.month
    end
    if current_date.day < 10 then
      formatstring = formatstring .. "-0" .. current_date.day
    else
      formatstring = formatstring .. "-" .. current_date.day
    end
    
    formatstring = current_date.year .. "-" .. formatstring .. "-"
  
    if current_date.hour < 10 then
      formatstring = formatstring .. "0" .. current_date.hour
    else
      formatstring = formatstring .. current_date.hour
    end
  
    if current_date.min < 10 then
      formatstring = formatstring .. "0" .. current_date.min
    else
      formatstring = formatstring .. current_date.min
    end
  
    return formatstring
  end