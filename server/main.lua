local drinks = {
    'junk_blue',
    'junk_red',
    'junk_orange',
    'junk_purple',
    'junk_green'
}

lib.callback.register('r_energydrinks:checkBalance', function()
    local src = source
    local balance = Framework.getAccountBalance(src, 'money')
    if balance >= Cfg.VendingMachines.DrinkPrice then
        return true
    elseif balance < Cfg.VendingMachines.DrinkPrice then
        return false
    end
end)

RegisterNetEvent('r_energydrinks:buyDrink', function(color, dist)
    local src = source
    if dist > 5 then print(''.. src ..' is a filthy boi. [Cheater]') return end
    local item = string.format('junk_%s', color)
    Framework.removeAccountMoney(src, 'money', Cfg.VendingMachines.DrinkPrice)
    Wait(3500)
    Inventory.givePlayerItem(src, item, 1, nil)
end)

local isDrinking = {}
function RegisterUsableEnergyDrinks()
    for i = 1, #drinks do
        Framework.registerUsableItem(drinks[i], function(src, item)
            if isDrinking[src] then return false end
            isDrinking[src] = true
            SetTimeout(3000, function()
                isDrinking[src] = nil
            end)
            Inventory.removePlayerItem(src, item, 1)
            local hasDrunk = lib.callback.await('r_energydrinks:drinkJunk', src, drinks[i]:gsub("junk_", ""))
            if not hasDrunk then
                Inventory.givePlayerItem(src, item, 1, nil)
            end
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        RegisterUsableEnergyDrinks()
    end
end)

print('ServerSide Is Loaded [r_energydrinks, r_scripts gives you wings.]')
