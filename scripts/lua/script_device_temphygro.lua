-- Ce script permet de maintenir la température de salon entre 19°C et 21°C quand l'interrupteur
-- virtuel 'Thermostat salon' est activé.
 
local consigne = uservariables['thermostat_consigne']  --Température de consigne
local hysteresis = uservariables['thermostat_hysteresis'] --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
local sonde = 'Temphygro' --Nom de la sonde de température
local thermostat = 'Thermostat' --Nom de l'interrupteur virtuel du thermostat

commandArray = {}
--La sonde Oregon 'Salon' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
-- d'exécution de ce script.
if (devicechanged[sonde]) then
	local temperature = devicechanged[string.format('%s_Temperature', sonde)] --Temperature relevée dans le salon
    --On n'agit que si le "Thermostat" est actif
    if (otherdevices[thermostat]=='On') then
        print('-- Gestion du thermostat --')
 
        print('Temperature: '..string.sub(temperature,1,4)..' °C' )
        print('Consigne: '..consigne..' °C' )
        print('Hysteresis: '..hysteresis..' °C' )

    	if (temperature < (consigne - hysteresis)) then
            print('ALLUMAGE DU CHAUFFAGE')
            commandArray['Radiateur chambre rue']='On'
            commandArray['Radiateur chambre jardin']='On'
            commandArray['Radiateurs salon']='On'
            commandArray['Radiateur cuisine']='On'
            commandArray['Radiateur sdbwc']='On'
 
	    elseif (temperature > (consigne + hysteresis)) then
            print('EXTINCTION DU CHAUFFAGE')
            commandArray['Radiateur chambre rue']='Off'
            commandArray['Radiateur chambre jardin']='Off'
            commandArray['Radiateurs salon']='Off'
            commandArray['Radiateur cuisine']='Off'
            commandArray['Radiateur sdbwc']='Off'
 
	    end
    end
end

return commandArray