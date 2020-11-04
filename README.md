# TeltonikaNMEAlogger
Script for GPS tracking of your teltonika device in your nextcloud<br>
<br>
log in via ssh to the router and download the script to your /root/ folder<br>
<br>
curl https://github.com/G4Cab/TeltonikaNMEAlogger/raw/main/Teltonika_Nextcloud.sh --output /root/Teltonika_Nextcloud.sh<br>
<br>
and make it executable<br>
<br>
chmod a+x /root/Teltonika_Nextcloud.sh<br>
<br>
And put this line at the end of your /etc/rc.local<br>
<br>
/root/Teltonika_Nextcloud.sh &<br>
<br>
so it will run on every bootup automatically<br>
<br>
###############################<br>
Tested on following devices:<br>
Teltonika RUT850 (Firmware RUT850_R_00.01.04)
