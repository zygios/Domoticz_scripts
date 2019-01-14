-- XMotion
local motionDetector = 110
local motionDetector1 = 109 --doors
local lightID = 122 
local lighTime = 2
 
return {
          on   = { devices = { motionDetector, motionDetector1  }},          -- your motion detector
  
    execute = function(dz, XMotion)
        local light = dz.devices(lightID)
       
        if XMotion.state == "On" or  XMotion.state == "Open" then
            if light.state ~= "On" then 
                light.cancelQueuedCommands()
                light.switchOn()
            end     
        else
           light.switchOff().afterMin(lighTime)
        end   
    end
}