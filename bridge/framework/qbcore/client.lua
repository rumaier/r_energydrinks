if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

Framework = {
    Notify = function(msg, type)
        local src = source
        if Cfg.Notification == 'default' then
            TriggerClientEvent('QBCore:Notify', src, msg, type)
        elseif Cfg.Notification == 'ox' then
            TriggerClientEvent('ox_lib:notify', src, { description = msg, type = type, position = 'top' })
        elseif Cfg.Notification == 'custom' then
            -- Insert your notification system here
        end
    end,
}
