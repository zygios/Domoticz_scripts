local checktime = 5							        --updating every 5 minutes
local StartTime = '06:20'							--Hour then to start updating 
local EndTime = '19:00'								--Hour then to stop updating
local url = 'http://api-ext.trafi.com/departures?'	--Public transport API URL
local APIKey = 'xxxx'	--API key
local busIdToWork = 'vln_expressbus_3G' 			--Bus id from https://developer.trafi.com/
local busIdFromWork = 'vln_expressbus_3G'  			--Bus id from https://developer.trafi.com/
local stopIdToWork = 'vln_0503' 					--Stop id from https://developer.trafi.com/
local stopIdFromWork = 'vln_0103' 					--Stop id from https://developer.trafi.com/
local numOfDepDispl = 3								--Number of departures to display in text sensor
local ToWorkDeviceId = 127							--text device ID
local FromWorkDeviceId = 128						--text device ID

function getDepartureTimes(STOP_ID, BUS_ID, DEVICE_ID, DISPL_NUM)
	--  API call
	local API_URL = url .."stop_id=" .. STOP_ID.."&region=vilnius&api_key="..APIKey
	--print("API_URL: "..API_URL)
    local config=assert(io.popen('curl "'..API_URL..'"'))
    local RAWjson = config:read('*all')
    config:close()
    local jsonData = json:decode(RAWjson)
    local JsonSched = ''
    local jsonBusID = ''
    local jsonDepTime = ''
	
	if (jsonData ~= nil) then
        --print('Decoding JSON data')
        JsonSched = #jsonData.Schedules
        for i = 1, JsonSched do
	        jsonBusID = jsonData.Schedules[i].ScheduleId
	        --print('transport_id: '..jsonBusID )
	        if jsonBusID == BUS_ID then
	            jsonDepTime = #jsonData.Schedules[i].Departures
	            --print('Depart'..Depart)
	            for k = 1, jsonDepTime do
	                if k <= numOfDepDispl then
	                    departime = jsonData.Schedules[i].Departures[k].TimeLocal
	                    --print(departime)
	                    if k == 1 then
	                        departimestext = departime ..';\r\n'
	                    else
	                        departimestext = departimestext .. ' '..departime ..';\r\n'
	                    end
	                end
	            end
	       end
            
        end
	    commandArray["UpdateDevice"] =  DEVICE_ID.."|0|".. departimestext ..""
	else
        --print ('Json data is empty or unreachable')
    end
end

function timebetween(s,e)
	timenow = os.date("*t")
	year = timenow.year
	month = timenow.month
	day = timenow.day
	s = s .. ":00"  -- add seconds in case only hh:mm is supplied
	e = e .. ":00"
	shour = string.sub(s, 1, 2)
	sminutes = string.sub(s, 4, 5)
	sseconds = string.sub(s, 7, 8)
	ehour = string.sub(e, 1, 2)
	eminutes = string.sub(e, 4, 5)
	eseconds = string.sub(e, 7, 8)
	t1 = os.time()
	t2 = os.time{year=year, month=month, day=day, hour=shour, min=sminutes, sec=sseconds}
	t3 = os.time{year=year, month=month, day=day, hour=ehour, min=eminutes, sec=eseconds}
	sdifference = os.difftime (t1, t2)
	edifference = os.difftime (t1, t3)
	isbetween = false
	if sdifference >= 0 and edifference <= 0 then
		isbetween = true
	end
--~ 	print(" s:" .. s  .. "  e:" .. e .. "  sdifference:" .. sdifference.. "  edifference:" .. edifference)
	return isbetween
end

commandArray = {}

	json = (loadfile "/home/domoticz/domoticz/scripts/lua/JSON.lua")()  -- For Linux
	
	if timebetween(StartTime,EndTime) then
		local m = os.date('%M')
		if (m % checktime == 0) then
			getDepartureTimes(stopIdToWork, busIdToWork, ToWorkDeviceId, numOfDepDispl)
			getDepartureTimes(stopIdFromWork, busIdFromWork, FromWorkDeviceId, numOfDepDispl)
		end
	end
return commandArray