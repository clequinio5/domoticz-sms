package.path = package.path .. ";/home/pi/domoticz/scripts/lua/utils.lua"
local utils = require("utils")

local pattern = "(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)"

commandArray={}

if (uservariablechanged["rfid_tag"]) then
	if (otherdevices['Identify'] == 'On') then
		rfid_tag = utils.split(uservariables["rfid_tag"],";")
		rfid_data = rfid_tag[1]
		rfid_time = rfid_tag[2]
		print("RFID - "..rfid_data.." "..rfid_time)
		if (otherdevices["Race"] == 'On') then
			local t1_year, t1_month, t1_day, t1_hour, t1_min, t1_sec = uservariables["race_start"]:match(pattern)
			local t2_year, t2_month, t2_day, t2_hour, t2_min, t2_sec = rfid_time:match(pattern)
			
			local t1 = os.time({day=t1_day,month=t1_month,year=t1_year,hour=t1_hour,min=t1_min,sec=t1_sec})
			local t2 = os.time({day=t2_day,month=t2_month,year=t2_year,hour=t2_hour,min=t2_min,sec=t2_sec})

			local diff = t2-t1
			
			local heure = math.floor(diff/3600)
			local minute = math.floor(math.fmod(diff,3600)/60)
			local seconde = diff-3600*heure-60*minute
			local str_diff = heure.."h "..minute.."min "..seconde.."s"

			print("RACE ON - "..uservariables["race_start"].." "..t1.." "..rfid_time.." "..t2.." "..diff.." "..str_diff)
			local mess = utils.url_encode(rfid_data..' est rentré en '..str_diff)
			utils.sendSMS(mess,"0645870235")
		else
			print("RACE OFF")
			local t_year, t_month, t_day, t_hour, t_min, t_sec = rfid_time:match(pattern)
			local mess = utils.url_encode(rfid_data..' détecté à '..t_hour..':'..t_min..':'..t_sec..' le '..t_day..'/'..t_month..'/'..t_year..'.')
			utils.sendSMS(mess,"0645870235")
		end
	end
end

return commandArray