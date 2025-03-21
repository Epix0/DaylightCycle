local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local heartbeatSignal = RunService.Heartbeat
local heartbeatConnection = nil

local GAME_DAY_LEN_SECONDS = 10 -- configurable total clock duration
local TWENTY_FOUR_HOUR_SECONDS = 86_400
local CLOCK_TICK_ALPHA = TWENTY_FOUR_HOUR_SECONDS / GAME_DAY_LEN_SECONDS / 60 / 60 -- value is scaled with hearbeat deltas then added to the clock  
local ATT_DAYLIGHT_CYCLE_TOGGLE = "DoDaylightCycle"

local function progressClockTime(frameDeltaTime)
	Lighting.ClockTime += (CLOCK_TICK_ALPHA * frameDeltaTime) % 24
end

local function shouldDaylightCycle()
	--return workspace:GetAttribute(ATT_DAYLIGHT_CYCLE_TOGGLE) -- modified below line to work independent from current game
	return workspace:GetAttribute(ATT_DAYLIGHT_CYCLE_TOGGLE) == nil or workspace:GetAttribute(ATT_DAYLIGHT_CYCLE_TOGGLE)
end

local function disconnectHeartbeatConnection()
	heartbeatConnection:Disconnect()
	heartbeatConnection = nil
end

local function connectHeartbeatConnection()
	if heartbeatConnection ~= nil then
		disconnectHeartbeatConnection()
	end
	
	heartbeatConnection = heartbeatSignal:Connect(progressClockTime)
end

-- allows debug tools to toggle during runtime
workspace:GetAttributeChangedSignal(ATT_DAYLIGHT_CYCLE_TOGGLE):Connect(function()
	if shouldDaylightCycle() then
		connectHeartbeatConnection()
	else
		disconnectHeartbeatConnection()
	end
end)

-- kickstart 
if shouldDaylightCycle() then
	connectHeartbeatConnection()
end
