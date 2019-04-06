local checktime = 10				        --updating every 5 minutes
local url = 'http://api.openweathermap.org/data/2.5/'	--Open Weahter URL
local City = "Vilnius,Lt"; 
local APIKEY = "xxxx";
local lang = "lt";
local units = "metric";
local forecast_days = 4;
local curr_weath_IDX = 142;
local forecast_IDX = {143, 144, 145, 146, 147}

function getCurrWeather()
	--  API call
	local API_URL = url .."weather?q=" .. City .. "&units=" .. units .. "&APPID=" .. APIKEY .. "&lang=" .. lang
	--print("API_URL: "..API_URL)
	local config=assert(io.popen('curl "'..API_URL..'"'))
    local RAWjson = config:read('*all')
    config:close()
    local jsonData = json:decode(RAWjson)
    local Jsonweather = ''
    
    if (jsonData ~= nil) then
	    --print('Temp: ' .. jsonData.main.temp)
	    --print('Hum: ' .. jsonData.main.humidity)
	    --print('Press: ' .. jsonData.main.pressure)
	    Jsonweather = #jsonData.weather
        for i = 1, Jsonweather do
            --print("Weather_icon:" ..jsonData.weather[i].icon)
            commandArray['Variable:Today_icon'] = jsonData.weather[i].icon
        end 
        
        updatetext = tostring(curr_weath_IDX).. "|0|" .. jsonData.main.temp .. ";" .. jsonData.main.humidity .. ";0;" .. jsonData.main.pressure .. ";0"
        --print("updatetext: " .. updatetext)
        commandArray['UpdateDevice'] = updatetext
	else
		print ('Json data is empty or unreachable')	
	end
	
end

function getForecastWeather()
   --  API call
   	local API_URL = url .."forecast?q=" .. City .. "&units=" .. units .. "&APPID=" .. APIKEY .. "&lang=" .. lang
	--print("API_URL: "..API_URL)
	local config=assert(io.popen('curl "'..API_URL..'"'))
    local RAWjson = config:read('*all')
    config:close()
    local jsonData = json:decode(RAWjson) 
    local JsonList = ''
    local Jsonweather = ''
    local forcast_date = ''
    local forcast_time = ''
    local forcast_date = {}
    
    for k = 1, forecast_days do
        forcast_time = (math.floor(os.date("%H")/3 + 0.5)*3)+3
        if forcast_time == 24 then forcast_time = 0 end
        forcast_date[k] = tostring(os.date("%Y"))  .. "-" .. tostring(os.date("%m")) .. "-".. string.format("%02d", (os.date("%d") + k)) .. " " .. string.format("%02d",forcast_time) .. ":00:00"
        --print(forcast_date[k])
    end
    
    
    if (jsonData ~= nil) then
        --JsonweatherDays = #jsonData.weather
        JsonList = #jsonData.list
        m = 1;
        for i = 1, JsonList  do
            
            --print("Data: " .. forcast_date)
            if contains(forcast_date, jsonData.list[i].dt_txt) then
                --print("Suradom atitikima: " .. jsonData.list[i].dt_txt)
                --print("dt_txt: " .. jsonData.list[i].dt_txt)
                --print('temp_'.. i .. ': ' .. jsonData.list[i].main.temp)
                updatetext = tostring(forecast_IDX[m]).. "|0|" .. jsonData.list[i].main.temp .. ";" .. jsonData.list[i].main.humidity .. ";0;" .. jsonData.list[i].main.pressure .. ";0"
                --print("updatetext:" .. updatetext)
                table.insert (commandArray, { ['UpdateDevice'] = updatetext } )
                
                Jsonweather = #jsonData.list[i].weather
                for k = 1, Jsonweather do
                    --print("Weather_icon:Variable:Day" .. m .. "_icon" ..jsonData.list[i].weather[k].icon)
                    table.insert (commandArray, { ['Variable:Day'.. m .. '_icon'] = jsonData.list[i].weather[k].icon } )
                end
                m = m +1
            end
        end
    else
    	print ('Json data is empty or unreachable')	
	end

end

function contains(table, val)
   for i=1,#table do
      if table[i] == val then 
         return true
      end
   end
   return false
end

commandArray = {}
    json = (loadfile "/home/domoticz/domoticz/scripts/lua/JSON.lua")() -- For Linux
    
    local m = os.date('%M')
	if (m % checktime == 0) then
        getCurrWeather()
        getForecastWeather()
    end
return commandArray