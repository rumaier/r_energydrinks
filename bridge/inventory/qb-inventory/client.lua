if GetResourceState('qb-inventory') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

Inventory = {
    openStash = function(name)
        TriggerEvent("inventory:client:SetCurrentStash", name)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", name, {
            maxweight = 50000,
            slots = 50,
        })
    end
}
