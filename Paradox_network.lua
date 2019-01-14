local Paradox = 120

return {
	on = {
		devices = { Paradox	}
	},
	execute = function(dz, device)
	    local ParadoxIntStatus;
	    local ParadoxJson;
		dz.log('Device ' .. device.name .. ' was changed ' .. device.state, dz.LOG_INFO)
		if device.state == 'On'  then
	        ParadoxIntStatus = 10
	        ParadoxJson = '{"DomParadox_Status":"'..tostring(ParadoxIntStatus)..'"}';
	        os.execute('mosquitto_pub -h 192.16x.x.xx -t paradox/in -m '..ParadoxJson);
	    elseif device.state == 'On_stay_mode' then
	        ParadoxIntStatus = 50
	        ParadoxJson = '{"DomParadox_Status":"'..tostring(ParadoxIntStatus)..'"}';
	        os.execute('mosquitto_pub -h 192.16x.x.xx -t paradox/in -m '..ParadoxJson);
	    elseif device.state == 'Off' then 
	        ParadoxIntStatus = 0
	        ParadoxJson = '{"DomParadox_Status":"'..tostring(ParadoxIntStatus)..'"}';
	        os.execute('mosquitto_pub -h 192.16x.x.xx -t paradox/in -m '..ParadoxJson);
		end
	end
}