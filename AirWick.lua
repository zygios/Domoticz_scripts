local AirWickIdx = 149
local AirwickVol = 150
local ParadoxStatus = 123
local SvetPir = 113 
local TimeToOff = 15 //time to check when was last PIR movement

return {
	on = {
		timer = {
		    'every 5 minutes'
		}
	},
	execute = function(dz, item)
	    local rawData = dz.devices(ParadoxStatus).rawData
	    local ParadoxValue = dz.devices(ParadoxStatus).rawData[1]
	    local lastUpdate = dz.devices(SvetPir).lastUpdate.minutesAgo
	    local lastUpdateVolt = dz.devices(AirwickVol).lastUpdate.minutesAgo
	    if ParadoxValue == 'Disarmed' and lastUpdate < TimeToOff then 
	        dz.devices(AirWickIdx).switchOn().checkFirst()
	    else
	        dz.devices(AirWickIdx).switchOff().checkFirst()
	    end
	    
	    if lastUpdateVolt < 60 then
	        commandArray ={["SendEmail"]="Išsikrovė Airwick gaiviklis!#Išsikrovė Airwick gaiviklis!#xxxx@gmail.com"}
	        dz.devices(AirwickVol).updateVoltage(0)
	    end
	end
	
}