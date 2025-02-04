QBCore = exports['qb-core']:GetCoreObject()

local currentWeatherIndex = 1

local ChangeInterval = WeatherShared.Configuration.ChangeTime * 60 * 1000

local function ChangeWeather()
    currentWeatherIndex = currentWeatherIndex + 1
    if currentWeatherIndex > #WeatherShared.Configuration.Types then
        currentWeatherIndex = 1
    end

    local newWeather = WeatherShared.Configuration.Types[currentWeatherIndex]
    TriggerEvent('qb-weathersync:server:setWeather', newWeather)

    if WeatherShared.Configuration.Debug then
        print("Weather Changed To: " .. newWeather)
    end
end

-- Start the weather cycle
Citizen.CreateThread(function()
    while true do
        ChangeWeather()
        Citizen.Wait(ChangeInterval)
    end
end)