local vMachines = {}
local energyEffects = false
local vendModel = joaat('sf_prop_sf_vend_drink_01a')

local function buyDrink(color)
    local player = cache.ped
    local pCoords = GetEntityCoords(player)
    local machines = lib.getNearbyObjects(pCoords, 5.0)
    local balance = lib.callback('r_energydrinks:checkBalance', false)
    if not balance then
        Framework.Notify('You can not afford this!', 'error')
        return
    end
    for k, v in pairs(machines) do
        for _, i in pairs(vMachines) do
            if (v.object == i) then
                local mCoords = vec3(v.coords.x, v.coords.y, v.coords.z)
                local dist = (#pCoords - #mCoords)
                local animDict1 = 'anim@mp_radio@high_life_apment'
                local animDict2 = 'random@domestic'
                local anim1 = 'button_press_living_room'
                local anim2 = 'pickup_low'
                lib.requestAnimDict(animDict1)
                lib.requestAnimDict(animDict2)
                FreezeEntityPosition(player, true)
                TaskPlayAnim(player, animDict1, anim1, 8.0, 4.0, 1500, 0, 0.0, false, false, false)
                TriggerServerEvent('r_energydrinks:buyDrink', color, dist)
                Wait(1500)
                TaskPlayAnim(player, animDict2, anim2, 8.0, 4.0, 1500, 0, 0.0, false, false, false)
                Wait(1500)
                FreezeEntityPosition(player, false)
                RemoveAnimDict(animDict1)
                RemoveAnimDict(animDict2)
                return
            end
        end
    end
end

local function sprintBoost()
    local player = cache.ped
    CreateThread(function()
        while energyEffects do
            SetPedMoveRateOverride(player, 1.5)
            if not energyEffects then return end
            Wait(0)
        end
    end)
end

local function resetEffects()
    local player = cache.ped
    StatSetInt(`MP0_STAMINA`, 25, true)
    SetPedMoveRateOverride(player, 1.0)
    SetRunSprintMultiplierForPlayer(player, 1.0)
    Framework.Notify('The energy drink has worn off..', 'info')
end

local props = { blue = 'junk_can_1', red = 'junk_can_2', orange = 'junk_can_3', purple = 'junk_can_4', green = 'junk_can_5' }
lib.callback.register('r_energydrinks:drinkJunk', function(color)
    if energyEffects then Framework.Notify('You are already hyped up on Junk!', 'info') return false; end
    energyEffects = true
    lib.requestModel(props[color])
    lib.progressCircle({
        duration = 3000,
        label = 'Chugging Junk...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = false,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'mp_player_intdrink',
            clip = 'loop_bottle'
        },
        prop = {
            model = props[color],
            pos = vec3(0.01, 0.0, 0.06),
            rot = vec3(4.26, 5.97, 138.47)
        },
    })
    SetModelAsNoLongerNeeded(props[color])
    Framework.Notify('You feel the Junk coursing through your veins!', 'info')
    if Cfg.Effects.StaminaBoost then
        StatSetInt(`MP0_STAMINA`, 75, true)
    end
    if Cfg.Effects.SprintBoost then
        sprintBoost()
    end
    SetTimeout((Cfg.Effects.Duration * 1000), function()
        resetEffects()
        energyEffects = false
    end)
    return true
end)

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
