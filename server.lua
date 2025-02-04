QBCore = exports['qb-core']:GetCoreObject()

local ChangeInterval = WeatherShared.Configuration.ChangeTime * 60 * 1000
local DebugChangeInterval = WeatherShared.Configuration.DebugChangeTime * 1000

local function ChangeWeather()
    local newWeather = WeatherShared.Configuration.Types[math.random(#WeatherShared.Configuration.Types)]
    TriggerEvent('qb-weathersync:server:setWeather', newWeather)

    if WeatherShared.Configuration.Debug == true then
        print("Weather Changed To: " .. newWeather)
    elseif WeatherShared.Configuration.Debug == false then
        return
    end
end

-- Start the weather cycle
Citizen.CreateThread(function()
    while true do
        ChangeWeather()
        if WeatherShared.Configuration.Debug == true then
            Citizen.Wait(DebugChangeInterval)
        elseif WeatherShared.Configuration.Debug == false then
            Citizen.Wait(ChangeInterval)
        end
    end
end)