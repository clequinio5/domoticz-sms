# PROJET DOMOTICZ DE PILOTAGE DE MAISON PAR SMS

##PRESENTATION:

Le but du projet présenté ici est de piloter une maison de campagne à distance sans internet (chauffage et arrosage automatique).
Un projet permettant de détecter et d'identifier des pigeons voyageurs préalablement bagués avec des tags RFID a également été intégré.

##MATERIEL:

- Raspberry Pi 3 Model B + alimentation
- RFXCOM 433 MHz
- GPS USB pour permettre la mise à jour de l'heure du raspberry sans internet. Alternative: écouter les signaux 175Hz Heure Pleine/Heure Creuse ERDF.
- Vieux smartphone android (en l'occurence un sony xperia Z3 Compact ayant eu quelques soucis de caméra et d'écran) qui fera office de serveur SMS. Alternative: modem sms usb avec gammu. Neanmoins je n'ai jamais pû obtenir une stabilité suffisante avec ces technos.
- 4 modules domotiques Dio 1000W branchés sur la puissance de 4 radiateurs 1000W (pour puissance supérieure à 1000W se brancher sur le fil pilote avec une diode pour reproduire les différents signaux des modes confort, eco, hors gel,... )
- 1 prise Dio 433MHz avec electrovanne pour l'arrosage
- 1 thermomètre/hygromètre 433MHz Oregon Scientific
- Lecteur RFID USB et bagues rfid pour pigeons voyageurs

##FONCTIONNALITES:

- Commander l'arrosage du jardin pendant xx minutes.
- Controle des radiateurs de la maison avec thermostat d'ambiance (trasmission d'une valeur de consigne)
- Detection de l'entrée/sortie des pigeons voyageurs, chronométrage (mode "race") et gestion de la base de données "pigeons.csv"
- Gestion des differents profils utilisateurs (user/admin)

##APPLICATIF:

- SMS Gateway Android
- RaspAP
- Domoticz
- Gpsd & Ntpd
- (Gammu)

##INSTALLATION:

Variables utilisateurs à créer dans Domoticz:
- sms
- consigne_thermostat
- hysteresis_thermostat