if GetResourceState('qb-inventory') ~= 'started' then return end
print('Current Inventory: qb-inventory')

Inventory = {
    givePlayerItem = function(src, item, qty, metadata)
        local src = src or source
        if metadata then
            local info = metadata
            exports['qb-inventory']:AddItem(src, item, qty, nil, info)
        elseif metadata == nil then
            exports['qb-inventory']:AddItem(src, item, qty, nil)
            TriggerClientEvent('inventory:client:ItemBox', src, item, 'add')
        end
    end,

    removePlayerItem = function(src, item, qty, metadata)
        local src = src or source
        exports['qb-inventory']:RemoveItem(src, item, qty, nil)
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
