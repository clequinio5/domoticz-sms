package.path = package.path .. ";/home/pi/domoticz/scripts/lua/utils.lua"
local utils = require("utils")

commandArray = {}

if (devicechanged['Arrosage']=='Off') then
    print('EXTINCTION DE L\'ARROSAGE AUTOMATIQUE')
    local mess = utils.url_encode('Extinction de l\'arrosage automatique')
    utils.sendSMS(mess,"0645870235")
    utils.sendSMS(mess,"0675496792")
    utils.sendSMS(mess,"0687094952")
end
if (devicechanged['Arrosage']=='On') then
    print('ALLUMAGE DE L\'ARROSAGE AUTOMATIQUE')
end

return commandArray