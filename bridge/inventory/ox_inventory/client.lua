if GetResourceState('ox_inventory') ~= 'started' then return end

local ox_inventory = exports.ox_inventory

Inventory = {
    openStash = function(name)
        ox_inventory:openInventory('stash', name)
    end,
}