QBCore = exports['qb-core']:GetCoreObject()

local ChangeInterval = WeatherShared.Configuration.ChangeTime * 60 * 1000
local DebugChangeInterval = WeatherShared.Configuration.DebugChangeTime * 1000

local function ChangeWeather()
    local currentWeather = exports['qb-weathersync']:GetWeather() -- GET CURRENT WEATHER
    local weatherTypes = WeatherShared.Configuration.Types
    local newWeather

    -- FIND THE INDEX OF THE CURRENT WEATHER
    local currentIndex = nil
    for i, weather in ipairs(weatherTypes) do
        if weather == currentWeather then
            currentIndex = i
            break
        end
    end

    -- DETERMINE THE NEXT WEATHER TYPE IN ORDER
    if currentIndex and currentIndex < #weatherTypes then
        newWeather = weatherTypes[currentIndex + 1]
    else
        newWeather = weatherTypes[1] -- LOOP BACK TO THE BEGINNING
    end

    -- SET THE NEW WEATHER
    TriggerEvent('qb-weathersync:server:setWeather', newWeather)

    if WeatherShared.Configuration.Debug == true then --- DEBUG PRINT
        print("[DEBUG] Weather Changed To: " .. newWeather)
    elseif WeatherShared.Configuration.Debug == false then
        return
    end
end

-- START THE WEATHER CYCLE
Citizen.CreateThread(function()
    while true do
        ChangeWeather()
        if WeatherShared.Configuration.Debug == true then -- DEBUG TIME
            Citizen.Wait(DebugChangeInterval)
        elseif WeatherShared.Configuration.Debug == false then -- NORMAL TIME
            Citizen.Wait(ChangeInterval)
        end
    end
end)