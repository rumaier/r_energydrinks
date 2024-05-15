if GetResourceState('qb-inventory') ~= 'started' then return end
print('Current Inventory: qb-inventory')

local QBCore = exports['qb-core']:GetCoreObject()

Inventory = {
    givePlayerItem = function(src, item, qty, metadata)
        local src = src or source
        if metadata then
            local info = metadata
            exports['qb-inventory']:AddItem(src, item, qty, nil, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
        elseif metadata == nil then
            exports['qb-inventory']:AddItem(src, item, qty)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
        end
    end,

    removePlayerItem = function(src, item, qty)
        local src = src or source
        local player = QBCore.Functions.GetPlayer(src)
        player.Functions.RemoveItem(item.name, qty)
    end,

    getPlayerItem = function(src, item, metadata)
        local src = src or source
        local hasItems = exports['qb-inventory']:GetItemsByName(src, item)
        return hasItems.amount
    end,

    registerStash = function(name, label, slots, weight, owner)
        -- Ignore this, QB does it all client side.
    end
}
