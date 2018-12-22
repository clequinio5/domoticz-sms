import sys

LOG_PATH='/home/pi/domoticz/scripts/python/update_bdd.py.log'

print("UPDATE DE LA BDD",file=open(LOG_PATH,'a'))
sms = sys.argv[1]
print(sms,file=open(LOG_PATH,'a'))
code, data = sms.replace("@","").split("/")

pigeons = open("/home/pi/domoticz/pigeons.csv","r").read().split("\n")
not_exist=1
if pigeons==['']:
    pigeons = []
for index, pigeon in enumerate(pigeons):
    p_code,p_data = pigeon.replace("\n","").split(";")
    if p_code == code:
        print("Pigeon trouve! Update de: "+pigeons[index]+" avec "+code+";"+data,file=open(LOG_PATH,'a'))
        pigeons[index]= code + ";" + data
        not_exist=0
        break
if not_exist:
    print("Pigeon non trouve! Ajout de: "+code + ";" + data,file=open(LOG_PATH,'a'))
    pigeons.append(code + ";" + data)
open("/home/pi/domoticz/pigeons.csv","w").write("\n".join(pigeons))
print("BDD mise a jour!",file=open(LOG_PATH,'a'))




