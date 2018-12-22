pkill ntpd
pkill gpsd
gpsd -b -n -D 2 /dev/gps
sleep 2
GPSDATE=`gpspipe -w | head -10 | grep TPV | sed -r 's/.*"time":"([^"]*)".*/\1/' | head -1`
echo GPSDATE: $GPSDATE
LOCALDATE=$(date --date="$GPSDATE + 2 hour" '+%Y-%m-%dT%T.000Z')
echo LOCALDATE: $LOCALDATE
date -s "$LOCALDATE"
