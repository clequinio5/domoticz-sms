import os, sys, time, urllib.request, serial
#from contextlib import suppress

time.sleep(5)

LOG_PATH='/home/pi/domoticz/scripts/cron/rfid_daemon.log'

print('RFID LISTENER STARTING...',file=open(LOG_PATH,'a'))

DOMO_IP="localhost"
DOMO_PORT="8080"
IDX="3"

#Enable Serial Communication
port = serial.Serial(port="/dev/rfid_reader", baudrate=9600, timeout=0.01)
 
# Find a character in a string
def find(str, ch):
    for i, ltr in enumerate(str):
        if ltr == ch:
            yield i
 
fd=''
while True:
    #with suppress(Exception):
        # Read the port
        rcv = port.readline()
        if len(rcv) > 1:
            fd=fd+rcv.decode("utf-8")
            ps=fd.find('\r')
            if ps >= 0:
                code = fd[1:ps]
                fd=''
                formatted_date=time.strftime("%Y%m%d%H%M%S",time.localtime(time.time()))
                not_found=1

                pigeons = open("/home/pi/domoticz/pigeons.csv","r").readlines()
                print(pigeons,file=open(LOG_PATH,'a'))

                for pigeon in pigeons:
                    p_code,p_data = pigeon.replace("\n","").split(";")
                    if code == p_code:
                        print("found " + p_data+" "+p_code+" "+formatted_date,file=open(LOG_PATH,'a'))
                        urllib.request.urlopen("http://"+DOMO_IP+":"+DOMO_PORT+"/json.htm?type=command&param=updateuservariable&idx="+IDX+"&vname=rfid_tag&vtype=2&vvalue="+urllib.request.quote(p_data+"("+p_code+")")+";"+urllib.request.quote(formatted_date))
                        not_found=0
                        break
                if not_found:
                    print("not_found "+code+" "+formatted_date,file=open(LOG_PATH,'a'))
                    urllib.request.urlopen("http://"+DOMO_IP+":"+DOMO_PORT+"/json.htm?type=command&param=updateuservariable&idx="+IDX+"&vname=rfid_tag&vtype=2&vvalue="+urllib.request.quote(code)+";"+urllib.request.quote(formatted_date))
                
