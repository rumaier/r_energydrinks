local drinks = {
    'junk_teal',
    'junk_red',
    'junk_orange',
    'junk_purple',
    'junk_green'
}

lib.callback.register('r_energydrinks:checkInven', function(item)
    local src = source
    local count = Inventory.getPlayerItem(src, item, nil)
    if count > 0 then
        Inventory.removePlayerItem(src, item, 1, nil)
        return true
    elseif count < 1 then
        return false
    end
end)

RegisterNetEvent('r_energydrinks:buyDrink', function(color)
    local src = source
    local item = string.format('junk_can_%s', color)
    Inventory.givePlayerItem(src, item, 1, nil)
end)

function RegisterUsableEnergyDrinks()
    for i = 1, #drinks do
        Framework.registerUsableItem(drinks[i], function()
            -- trigger client event to do server callback to check for item and remove item..return true, if true trigger function for drinking
        end)
    end
end

print('ServerSide Is Loaded [r_energydrinks, r_scripts gives you wings.]')
print('I put an energy drink in my coffee this morning.')
print('I got halfway to work and realized I forgot my car.')
