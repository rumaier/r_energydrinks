local function isPlayerNearMachine(src)
    local nearest = math.huge
    local player = GetPlayerPed(src)
    local coords = GetEntityCoords(player)
    for _, machine in pairs(Cfg.MachineLocations) do
        local distance = #(coords - machine.xyz)
        if distance < nearest then
            nearest = distance
        end
    end
    return nearest <= 5.0
end

lib.callback.register('r_energydrinks:purchaseDrink', function(src, color)
    if not isPlayerNearMachine(src) then
        print('^1[r_energydrinks]^0 Player ' .. src .. ' is not near a vending machine')
        return false
    end
    if bridge.framework.getBalance(src, 'cash') < Cfg.DrinkPrice then
        return false, 'insufficient_funds'
    end
    bridge.framework.removeBalance(src, 'cash', Cfg.DrinkPrice)
    SetTimeout(3500, function()
        bridge.inventory.addItem(src, 'junk_' .. color, 1)
    end)
    return true
end)

local function registerDrinkItems()
    local colors = { 'blue', 'red', 'orange', 'purple', 'green' }
    for _, color in pairs(colors) do
        bridge.framework.registerUsableItem('junk_' .. color, function(src, item, data)
            item = data or item
            if lib.callback.await('r_energydrinks:drink', src, color) then
                bridge.inventory.removeItem(src, item.name, 1)
            end
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    registerDrinkItems()
end)