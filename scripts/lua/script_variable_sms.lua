package.path = package.path .. ";/home/pi/domoticz/scripts/lua/utils.lua"
local utils = require("utils")

commandArray={}

if (uservariablechanged["sms"]) then

    sms, from = uservariables["sms"]:match("([^;]+);([^;]+)")
    print('SMS - Reçu du '..from..': '..'"'..sms..'"')

    users = {
        ["+33XXXXXXXXX"] = {["nom"] = "Beau Gosse", ["num"] = "XXXXXXXXXX", ["auth"] = {"user","admin"}},
        ["+33XXXXXXXXX"] = {["nom"] = "le Papounet", ["num"] = "XXXXXXXXXX", ["auth"] = {"user"}},
        ["+33XXXXXXXXX"] = {["nom"] = "la Mamounette", ["num"] = "XXXXXXXXXX", ["auth"] = {"user"}},
        ["+33XXXXXXXXX"] = {["nom"] = "la Ttel", ["num"] = "XXXXXXXXXX", ["auth"] = {"user"}}
    }

    --Identify Sender
    sender = ""
    for k, v in pairs(users) do
        if k == from then
            sender = v
        end
    end
    if sender == "" then
        return commandArray
    end
    print("SMS - Identifié: "..sender.nom.." "..sender.num)

    --Help
    if sms == "Help" then
        if utils.includes("user", sender.auth) then
            mess = 'Bienvenue à Wacquemoulin '..sender.nom..'! Commandes disponibles:\n\n'
            if utils.includes("admin", sender.auth) then
                mess = mess..'* Reboot\n'
                mess = mess..'* SetTime {yyyy-mm-dd hh:mm:ss}\n'
                mess = mess..'* Shutdown\n'
            end
            mess = mess..'- @{rfid}/{nom_du_pigeon}\n'
            mess = mess..'- Arrosage {dd/off}\n'
            mess = mess..'- Chauffe {on/off}\n'
            mess = mess..'- Identify {on/off}\n'
            mess = mess..'- Race {on/off}\n'
            mess = mess..'- Radiateur salon ouest {on/off}\n'
            mess = mess..'- Temp\n'
            mess = mess..'\n'
            mess = utils.url_encode(mess)
            print(mess)
            utils.sendSMS(mess, sender.num)
        end

    --Reboot
    elseif sms == "Reboot" then
        if utils.includes("admin", sender.auth) then
            print('SMS - Reboot')
            mess = utils.url_encode('Redémarrage du serveur domotique.\nLe serveur redémarrera dans 5 secondes.')
            for k, v in pairs(users) do
                if utils.includes("admin", v.auth) then
                    utils.sendSMS(mess, v.num)
                end
            end
            os.execute('sh /home/pi/domoticz/scripts/shell/reboot.sh')
        else
            mess = utils.url_encode("Vous n\'avez pas les autorisations requises pour réaliser cette action.")
            utils.sendSMS(mess, sender.num)
        end 

    --SetTime
    elseif sms:match("SetTime %d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d") then
        if utils.includes("admin", sender.auth) then
            newDate = sms:match("SetTime (%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d)")
            print('SMS - SetTime '..newDate..'.')
            mess = utils.url_encode("Le serveur domotique a été mis à l'heure du "..newDate..'.')
            for k, v in pairs(users) do
                if utils.includes("admin", v.auth) then
                    utils.sendSMS(mess, v.num)
                end
            end
            os.execute("sudo date --set '"..newDate.."'")
        else
            mess = utils.url_encode("Vous n\'avez pas les autorisations requises pour réaliser cette action.")
            utils.sendSMS(mess, sender.num)
        end

        else
            mess = utils.url_encode("Hello "..sender.nom.."! La commande n\'a pas été reconnue. Essaye \'Help\'")
            utils.sendSMS(mess, sender.num)
        end

    --Shutdown
    elseif sms == "Shutdown" then
        if utils.includes("admin", sender.auth) then
            print('SMS - Shutdown')
            mess = utils.url_encode("Extinction du serveur domotique.\nVeuillez patienter une 20aine de secondes et attendre que la LED verte s\'éteigne définitivement pour mettre le serveur hors tension.")
            for k, v in pairs(users) do
                if utils.includes("admin", v.auth) then
                    utils.sendSMS(mess, v.num)
                end
            end
            os.execute('sh /home/pi/domoticz/scripts/shell/shutdown.sh')
        else
            mess = utils.url_encode("Vous n\'avez pas les autorisations requises pour réaliser cette action.")
            utils.sendSMS(mess, sender.num)
        end 
        
    --@{rfid}/{nom_du_pigeon}
    elseif sms:match("@%g+/.+") then
        print('SMS - Update ou insertion en base.'..sms)
        os.execute('sudo python3 /home/pi/domoticz/scripts/python/update_bdd.py '..sms)
        mess = utils.url_encode(sms..' a bien été inséré en base.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end

    --Arrosage dd
    elseif sms:match("Arrosage %d+") then
        tp = sms:match("Arrosage (%d+)")
        print('SMS - Arrosage on for '..tp..' minutes')
        mess = utils.url_encode('Arrosage du jardin pendant '..tonumber(tp)..' minute(s)')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Arrosage'] = 'On FOR '..tp}

    --Arrosage off
    elseif sms == "Arrosage off" then
        print('SMS - Arrosage off')
        commandArray[#commandArray+1] = { ['Arrosage'] = 'Off'}

    --Chauffe on
    elseif sms:match("Chauffe on") then
        print('SMS - Chauffe on')
        mess = utils.url_encode('Allumage des radiateurs.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Radiateur salon ouest'] = 'On'}
        commandArray[#commandArray+1] = { ['Radiateur salon est'] = 'On'}
        commandArray[#commandArray+1] = { ['Radiateur chambre Grany'] = 'On'}
        commandArray[#commandArray+1] = { ['Radiateur chambre Moune'] = 'On'}
        commandArray[#commandArray+1] = { ['Radiateur cuisine'] = 'On'}

    --Chauffe off
    elseif sms == "Chauffe off" then
        print('SMS - Chauffe off')
        mess = utils.url_encode('Arret des radiateurs.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Radiateur salon ouest'] = 'Off'}
        commandArray[#commandArray+1] = { ['Radiateur salon est'] = 'Off'}
        commandArray[#commandArray+1] = { ['Radiateur chambre Grany'] = 'Off'}
        commandArray[#commandArray+1] = { ['Radiateur chambre Moune'] = 'Off'}
        commandArray[#commandArray+1] = { ['Radiateur cuisine'] = 'Off'}

    --Identify on
    elseif sms == "Identify on" then
        print('SMS - Identify on')
        mess = utils.url_encode('Le système d\'identification est activé.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Identify'] = 'On'}

    --Identify off
    elseif sms == "Identify off" then
        print('SMS - Identify off')
        mess = utils.url_encode('Le système d\'identification ne vous enverra plus de SMS.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Identify'] = 'Off'}
        commandArray[#commandArray+1] = { ['Race'] = 'Off'}

        --Race on
    elseif sms == "Race on" then
        print('SMS - Race on')
        mess = utils.url_encode('Le système de chronométrage est activé.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Identify'] = 'On'}
        commandArray[#commandArray+1] = { ['Race'] = 'On'}

    --Race off
    elseif sms == "Race off" then
        print('SMS - Race off')
        mess = utils.url_encode('Le système de chronométrage est désactivé.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Race'] = 'Off'}

    --Radiateur salon ouest on
    elseif sms == "Radiateur salon ouest on" then
        print('SMS - Radiateur salon ouest on')
        mess = utils.url_encode('Le radiateur salon ouest est allumé.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Radiateur salon ouest'] = 'On'}

    --Radiateur salon ouest off
    elseif sms == "Radiateur salon ouest off" then
        print('SMS - Radiateur salon ouest off')
        mess = utils.url_encode('Le radiateur salon ouest est éteint.')
        for k, v in pairs(users) do
            if utils.includes("user", v.auth) then
                utils.sendSMS(mess, v.num)
            end
        end
        commandArray[#commandArray+1] = { ['Radiateur salon ouest'] = 'Off'}

    --Temp
    elseif sms == "Temp" then
        print('SMS - Temp')
        th = utils.split(otherdevices_svalues['Temphygro'], ';')
        mess = utils.url_encode('Il fait '..th[1]..' °C.\nL\'hygrométrie est de '..th[2]..' %.')
        utils.sendSMS(mess, sender.num)

end

return commandArray