local vMachines = {}
local vendModel = joaat('sf_prop_sf_vend_drink_01a')

RegisterCommand('tabletest', function()
    print(json.encode(vMachines, {indent = true}))
end, false)

local function buyDrink(color)
    local player = cache.ped
    local pCoords = GetEntityCoords(player)
    local machines = lib.getNearbyObjects(pCoords, 5.0)
    for k, v in pairs(machines) do
        for _, i in pairs(vMachines) do
            if v.object == i then
                TriggerServerEvent('r_energydrinks:buyDrink', color)
                return
            end
        end
    end
end

local function openVendingMenu()
    lib.registerContext({
        id = 'vendingmachinemenu',
        title = 'Junk Vending Machine',
        options = {
            {
                title = 'Junk Blue',
                icon = 'nui://r_energydrinks/assets/images/junk_teal.png',
                onSelect = function()
                    buyDrink('blue')
                end,
            },
            {
                title = 'Junk Red',
                icon = 'nui://r_energydrinks/assets/images/junk_red.png',
                onSelect = function()
                    buyDrink('red')
                end,
            },
            {
                title = 'Junk Orange',
                icon = 'nui://r_energydrinks/assets/images/junk_orange.png',
                onSelect = function()
                    buyDrink('orange')
                end,
            },
            {
                title = 'Junk Purple',
                icon = 'nui://r_energydrinks/assets/images/junk_purple.png',
                onSelect = function()
                    buyDrink('purple')
                end,
            },
            {
                title = 'Junk Green',
                icon = 'nui://r_energydrinks/assets/images/junk_green.png',
                onSelect = function()
                    buyDrink('green')
                end,
            },
        }
    })
    lib.showContext('vendingmachinemenu')
end

local function setVendingTargets()
    Target.addModel(vendModel, { {
        label = 'Open Junk Machine',
        name = 'junkvendingmenu',
        icon = 'fas fa-bottle-water',
        distance = 1,
        onSelect = function()
            openVendingMenu()
        end
    } })
end

function SetVendingMachines()
    lib.requestModel(vendModel)
    for i = 1, #Cfg.VendingMachines.Locations do
        local machine = CreateObject(vendModel, Cfg.VendingMachines.Locations[i].x, Cfg.VendingMachines.Locations[i].y, Cfg.VendingMachines.Locations[i].z, false, false, false)
        SetEntityHeading(machine, Cfg.VendingMachines.Locations[i].w)
        FreezeEntityPosition(machine, true)
        table.insert(vMachines, machine)
    end
    setVendingTargets()
    SetModelAsNoLongerNeeded(vendModel)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(vMachines) do
            if not DoesEntityExist(v) then break end
            DeleteEntity(v)
        end
    end
end)