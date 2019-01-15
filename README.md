# Domoticz_scripts
Domoticz script for home automotion (Lua, Dzevents)

## Small files descriptions:
* KolidoriusLED.lua - Lobby LED light control, LED turn on from motion sensor.
* Network_devices.lua - 'Ping' is a regular way to detect whether a device is present on a network or not (for PC, NAS and TV).
* Paradox_network.lua - Script to send command to Paradox control unit.
* Paradox_status.lua - Script for Paradox alarm system, if alarm is turn on all lights at home is turn off.
* Thingspeak.lua - uploading temperature/lux sensor data to Thingspeak server.
* VirtuveLED.lua - Kitchin LED light control, works from motion and Lux sensor data. Automatically turns off after 5 mins, at nights after 2 mins.
* get_Public_Transport.lua - Script for getting Vilnius public transport departure times using Trafi.com API.
* WOL_PC.sh - shell script used in device "On action" script trigger to turn on PC.
* shutdown_PC.sh - shell script used in device "Off action" script trigger to turn off PC.
