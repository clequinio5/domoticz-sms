
commandArray = {}

if (devicechanged['Race']) then
    if (otherdevices['Race']=='On') then
	start_race = os.date("%Y%m%d%H%M%S")
	print("Updating race_start: "..start_race)
        commandArray['Variable:race_start'] = start_race
    end
end

return commandArray