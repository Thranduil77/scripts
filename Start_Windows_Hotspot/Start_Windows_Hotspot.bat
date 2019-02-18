@echo off 
echo "Starting Windows Hotspot"
netsh wlan set hostednetwork mode=allow ssid=WindowsHotspot key=RandomPassword
netsh wlan start hostednetwork
exit