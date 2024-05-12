if GetResourceState('ox_inventory') ~= 'started' then return end
print('Current Inventory: ox_inventory')

local ox_inventory = exports.ox_inventory

Inventory = {
    givePlayerItem = function(src, item, qty, metadata)
        local src = src or source
        if metadata then
            ox_inventory:AddItem(src, item, qty, metadata)
        elseif metadata == nil then
            ox_inventory:AddItem(src, item, qty)
        end 
    end,

    removePlayerItem = function(src, item, qty, metadata)
        local src = src or source
        ox_inventory:RemoveItem(src, item, qty, metadata)
    end,

    getPlayerItem = function(src, item, metadata)
        local src = src or source
        return ox_inventory:GetItem(src, item, metadata, false).count
    end,

    registerStash = function(name, label, slots, weight, owner)
        ox_inventory:RegisterStash(name, label, slots, weight, owner)
    end
}