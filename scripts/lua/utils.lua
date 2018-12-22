local M = {}
 
local function includes(val,tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
       last_end = e+1
       s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
       cap = str:sub(last_end)
       table.insert(t, cap)
    end
    return t
end

local function url_encode(str)
    if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w %-%_%.%~])",
          function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
    end
    return str   
end

local function sendSMS(mess, to)
    if mess:len() < 150 then
         os.execute('sudo python /home/pi/domoticz/scripts/python/send_sms.py '..to..' '..mess)
      else
        local spl = split(mess,'%%0D%%0A')
        local out = ""
        for int, txt in pairs(spl) do
          if (out:len() + txt:len()) < 150 then
            if out:len() > 0 then
              out = out.."%0D%0A"..txt
            else
              out = txt
            end
          else
            os.execute('sudo python /home/pi/domoticz/scripts/python/send_sms.py '..to.." "..out)
            out = txt
          end
        end
        os.execute('sudo python /home/pi/domoticz/scripts/python/send_sms.py '..to.." "..out)
    end
end

M.url_encode = url_encode
M.split = split
M.includes = includes
M.sendSMS = sendSMS

return M