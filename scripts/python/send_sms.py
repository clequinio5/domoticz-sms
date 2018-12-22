import sys
import urllib

SMS_GATEWAY="http://admin:58599092@10.3.141.239:60763"
SMS_TO=sys.argv[1]
SMS_MESS=sys.argv[2]

urllib.urlopen(SMS_GATEWAY + "/send.html?smsto="+SMS_TO+"&smsbody="+SMS_MESS+"&smstype=sms")