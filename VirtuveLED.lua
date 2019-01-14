-- XMotion
 
local motionDetector = 100              -- device idx of your motion detector
local lightID        = 121            -- device idx of your light  
local luxDevice      = 96
local lightTime = 5
local lightTimeNight = 2
local nightTime = 'between 22:00 and 5:50'
local minLux = 20
 
return {
          on   = { devices = { motionDetector }},          -- your motion detector
  
    execute = function(dz, XMotion)
        local light = dz.devices(lightID)
       
        if XMotion.state == "On" and dz.devices(luxDevice).lux < minLux then
            if light.state ~= "On" then 
                light.cancelQueuedCommands()
                light.switchOn()
            end     
        else
            if (dz.time.matchesRule(nightTime)) then
                light.switchOff().afterMin(lightTimeNight)
            else
                light.switchOff().afterMin(lightTime)
            end
        end   
    end
}