if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports["es_extended"]:getSharedObject()

Framework = {
    Notify = function(msg, type)
        if Cfg.Notification == 'default' then
            ESX.ShowNotification(msg, type)
        elseif Cfg.Notification == 'ox' then
            lib.notify({ description = msg, type = type, position = 'top' })
        elseif Cfg.Notification == 'custom' then
            -- Insert your notification system here
        end
    end,
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    if Cfg.VendingMachines.Enabled then
        SetVendingMachines()
    end
end)
