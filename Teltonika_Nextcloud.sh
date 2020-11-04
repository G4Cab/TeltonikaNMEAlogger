#!/bin/sh
# 20191009 - phonetracker.sh created by Martin Loewe
# 20201013 - removed spaces from string after update (W3B)
# 20201102 - added log file for offline (W3B)
# 20201104 - send log file to nextcloud when connection resumes (W3B)


# Put your nextcloud server url in here
URL="https://nextcloud.bla.com"

# Put your Session ID in here
SESSION="132456789abcdefghijkl"

# Put your device name in here
NAME="deviceName"

# Log file name and location
FILE="/root/offline.log"

# Put your update delay in here in seconds
DELAY=5

while :
  do
    FIX=$(/usr/sbin/gpsctl -s) # get GPS fix status
    if [ $FIX = "1" ] # check if GPS fix is ok
        then
                LAT=$(/usr/sbin/gpsctl -i) # get latitude
                if [ "$LAT" != "$LATOLD" ] # check if new latitude is different from old latitude
                then
                        LATOLD=$LAT # set old latitude to new one
                        SPD=$(/usr/sbin/gpsctl -v) # get ground speed
                        LON=$(/usr/sbin/gpsctl -x) # get longitude
                        SAT=$(/usr/sbin/gpsctl -p) # get connected sattelites
                        ALT=$(/usr/sbin/gpsctl -a) # get altitude
                        ACC=$(/usr/sbin/gpsctl -u) # get accuracy
                        TIMESTAMP=$(/usr/sbin/gpsctl -t) # get gps timestamp
                        GPSResults="$URL/index.php/apps/phonetrack/log/gpslogger/$SESSION/$NAME?lat=$LAT&lon=$LON&sat=$SAT&alt=$ALT&acc=$ACC&speed=$SPD&timestamp=$TIMESTAMP"
                        DataCheck=$(ifconfig | awk '/^qmimux0/ { iface = getline; sub("addr:", ""); print $2 }') #Check modem IP
                        ip_full=$(echo $DataCheck | sed -n 's/^\(\(\([1-9][0-9]\?\|[1][0-9]\{0,2\}\|[2][0-4][0-9]\|[2][5][0-4]\)\.\)\{3\}\([1-9][0-9]\?\|[1][0-9]\{0,2\}\|[2][0-4][0-9]\|[2][5][0-4]\)\)$/\1/p') #Validate IP
                        if [ $ip_full != "" ] #If Valid IP
                        then
                                curl ${GPSResults// /} # Send data to nextcloud
                                if [ -f $FILE ] #If File exists
                                then
                                        while IFS= read -r line
                                        do
                                                curl $line
                                        done <"$FILE"
                                        rm $FILE #Remove file
                                fi
                        else
                                echo ${GPSResults// /} >> $FILE  #log GPS data in file
                        fi
                fi
    fi
  sleep $DELAY
 done
