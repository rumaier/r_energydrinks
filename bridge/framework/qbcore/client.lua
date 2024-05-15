if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

Framework = {
    Notify = function(msg, type)
        local src = source
        if Cfg.Notification == 'default' then
            TriggerEvent('QBCore:Notify', msg, 'primary', 3000)
        elseif Cfg.Notification == 'ox' then
            lib.notify({ description = msg, type = type, position = 'top' })
        elseif Cfg.Notification == 'custom' then
            -- Insert your notification system here
        end
    end,
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    if Cfg.VendingMachines.Enabled then
        SetVendingMachines()
    end
end)
