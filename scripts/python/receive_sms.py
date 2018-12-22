import os
import sys
import urllib
 
#Mise a jour dans Domoticz
DOMO_IP="localhost" # Addresse IP de Domoticz
DOMO_PORT="8080" # Port de Domoticz
IDX="1" # Index de la variable "sms"
 
urllib.urlopen("http://"+DOMO_IP+":"+DOMO_PORT+"/json.htm?type=command&param=updateuservariable&idx="+IDX+"&vname=sms&vtype=2&vvalue="+urllib.quote(os.environ['SMS_1_TEXT'])+";"+urllib.quote(os.environ['SMS_1_NUMBER']))