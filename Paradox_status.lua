local ParadoxStatus = 123 -- paradox device 

return {
	on = {  devices = { ParadoxStatus }
	    
	},
	execute = function(dz, Paradox)
	    local ParadoxValue = Paradox.text 
	    dz.log('ParadoxValue' .. Paradox.text, dz.LOG_INFO)
	    
	    dz.log('Security pannel change to  ' .. Paradox.text .. ' value', dz.LOG_INFO)
	    if Paradox.text == 'Armed Away'  then
	        --dz.devices(ParadoxStatus).updateText(Paradox.text)
	        dz.groups('Visos_sviesos').switchOff()
	    elseif Paradox.text == 'Armed Home' then
	        --dz.devices(ParadoxStatus).updateText(Paradox.text)
	    elseif Paradox.text == 'Disarmed' then 
	        --dz.devices(ParadoxStatus).updateText(Paradox.text)
		else
		    dz.log('Kazkoks kitoks statusas' .. Paradox.text, dz.LOG_INFO)
		end
	end
}