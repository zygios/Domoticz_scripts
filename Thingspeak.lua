local thingspeak_URL = '184.106.153.149:80' --ip and port of the otmonitor webinterface
local Write_KEY = 'xxxx'
local Virtuve = 97
local Svetaine = 6
local Miegamas = 1
local Vonia = 4

return {
	on = {
      timer = {
         'every 5 minutes'
         }
    },
   
    execute = function(dz, timer)
        local Virtuve_temp = dz.utils.round(dz.devices(Virtuve).temperature,1)
        local Virtuve_lux = dz.utils.round(dz.devices('VirtuveLux').lux,0)
        local Svetaine_temp = dz.utils.round(dz.devices(Svetaine).temperature,1)
        local Svetaine_lux = dz.utils.round(dz.devices('SvetaineLux').lux,0)
        local Miegamas_temp = dz.utils.round(dz.devices(Miegamas).temperature,1)
        local Lauko_temp = dz.utils.round(dz.devices('Lauko').temperature,1)
        local Vonia_temp = dz.utils.round(dz.devices(Vonia).temperature,1)
        --dz.log('Lauko_temp ' ..Lauko_temp)
        dz.openURL('http://'.. thingspeak_URL ..'/update?api_key='..Write_KEY..'&field1=' .. Miegamas_temp..'&field2=' .. Svetaine_temp..'&field3=' .. Lauko_temp..'&field5=' ..Vonia_temp .. '&field6=' .. Virtuve_temp.. '&field7=' .. Svetaine_lux.. '&field8=' .. Virtuve_lux)
   end
}