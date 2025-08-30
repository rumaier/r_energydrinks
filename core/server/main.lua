local drinks = { 'junk_blue', 'junk_red', 'junk_orange', 'junk_purple', 'junk_green' }

local function isPlayerNearVendingMachine(src)
    local player = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(player)
    local locations = Cfg.Options.VendingMachines.Locations
    local distance = math.huge
    for _, coords in pairs(locations) do
        local dist = #(playerCoords - coords.xyz)
        if dist < distance then distance = dist end
    end
    return distance <= 5.0
end

lib.callback.register('r_energydrinks:buyDrink', function(src, color)
    local nearMachine = isPlayerNearVendingMachine(src)
    if not nearMachine then _debug('[^ERROR^0] - Player ' .. src .. ' tried to buy drink but is not near a vending machine.') return false end
    local price = Cfg.Options.VendingMachines.DrinkPrice
    local balance = Core.Framework.getAccountBalance(src, 'money')
    if balance < price then return false, _L('not_enough_money') end
    Core.Framework.removeAccountBalance(src, 'money', price)
    local newBalance = Core.Framework.getAccountBalance(src, 'money')
    if newBalance ~= (balance - price) then _debug('[^ERROR^0] - Player ' .. src .. ' balance mismatch after drink purchase. Expected: ' .. (balance - price) .. ', Actual: ' .. newBalance) return false end
    SetTimeout(3500, function()
        local item = ('junk_%s'):format(color)
        Core.Inventory.addItem(src, item, 1)
    end)
    return true
end)

local function registerUsableDrinkItems()
    for index, item in ipairs(drinks) do
        Core.Framework.registerUsableItem(item, function(src, item, data)
            item = data or item
            Core.Inventory.removeItem(src, item, 1)
            local drank = lib.callback.await('r_energydrinks:drinkJunk', src, drinks[index]:gsub('junk_', ''))
            if not drank then Core.Inventory.addItem(src, item, 1) end
        end)
    end
    _debug('[^6DEBUG^0] - Registered ' .. #drinks .. ' usable drink items')
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        registerUsableDrinkItems()
    end
end)