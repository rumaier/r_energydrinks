local isDrinking = {}
local drinks = {
    'junk_blue',
    'junk_red',
    'junk_orange',
    'junk_purple',
    'junk_green'
}

lib.callback.register('r_energydrinks:buyDrink', function(src, color)
    local src = src or source
    local item = string.format('junk_%s', color)
    local balance = Core.Framework.GetAccountBalance(src, 'money')
    if balance < Cfg.VendingMachines.DrinkPrice then return false end
    Core.Framework.RemoveAccountBalance(src, 'money', Cfg.VendingMachines.DrinkPrice)
    Wait(3500)
    Core.Inventory.AddItem(src, item, 1)
    return true
end)

local function registerDrinks()
    for i = 1, #drinks do
        Core.Framework.RegisterUsableItem(drinks[i], function(src, item)
            if isDrinking[src] then return false end
            isDrinking[src] = true
            SetTimeout(3000, function()
                isDrinking[src] = nil
            end)
            if type(item) == 'table' then
                item = item.name
            end
            Core.Inventory.RemoveItem(src, item, 1)
            local hasDrank = lib.callback.await('r_energydrinks:drinkJunk', src, drinks[i]:gsub("junk_", ""))
            if not hasDrank then
                Core.Inventory.AddItem(src, item, 1)
            end
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        registerDrinks()
    end
end)