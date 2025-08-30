local machinePoints = {}
local vendingMachine = nil
local effectsActive = false

local props = {
    blue = 'junk_can_1',
    red = 'junk_can_2',
    orange = 'junk_can_3',
    purple = 'junk_can_4',
    green = 'junk_can_5'
}

local function buyDrink(color)
    TaskTurnPedToFaceEntity(cache.ped, vendingMachine, 1000)
    Wait(1000)
    Core.Natives.playAnimation(cache.ped, 'mini@sprunk', 'plyr_buy_drink_pt1', 4150, 0, 0.0)
    local success, reason = lib.callback.await('r_energydrinks:buyDrink', false, color)
    if not success then
        if not reason then
            _debug('[^ERROR^0] - Drink purchase failed, check server console for details')
        else
            Core.Interface.notify(_L('notify_title'), reason, 'error')
        end
        return
    end
    local price = Cfg.Options.VendingMachines.DrinkPrice
    Core.Interface.notify(_L('notify_title'), _L('bought_junk', color, price), 'success')
    _debug('[^6DEBUG^0] - Bought ' .. color .. ' junk for $' .. price)
end

local function boostSprintSpeed()
    CreateThread(function()
        while effectsActive do
            SetPedMoveRateOverride(cache.ped, 1.49)
            Wait(0)
        end
    end)
end

local function resetEffects()
    _debug('[^6DEBUG^0] - Resetting junk effects...')
    local modifierStrength = GetTimecycleModifierStrength()
    for i = modifierStrength, 0.0, -0.01 do
        SetTimecycleModifierStrength(i)
        Wait(0)
    end
    Wait(100)
    ClearTimecycleModifier()
    StatSetInt('MP0_STAMINA', 25, true)
    SetPedMoveRateOverride(cache.ped, 1.0)
    effectsActive = false
    Core.Interface.notify(_L('notify_title'), _L('wore_off'), 'info')
end

local function triggerJunkEffects()
    Core.Interface.notify(_L('notify_title'), _L('feel_junked'), 'success')
    SetTransitionTimecycleModifier('rply_contrast', 1.0)
    effectsActive = true
    for i = 1, 60 do
        SetTimecycleModifierStrength(i * 0.01)
        Wait(0)
    end
    if Cfg.Options.Effects.StaminaBoost then
        StatSetInt(`MP0_STAMINA`, 75, true)
    end
    if Cfg.Options.Effects.SprintBoost then
        boostSprintSpeed()
    end
    _debug('[^6DEBUG^0] - Junk effects applied for ' .. Cfg.Options.Effects.Duration .. ' seconds.')
    SetTimeout((Cfg.Options.Effects.Duration * 1000), function()
        resetEffects()
    end)
end

lib.callback.register('r_energydrinks:drinkJunk', function(color)
    if not color then return end
    if effectsActive then Core.Interface.notify(_L('notify_title'), _L('already_junked'), 'error') return end
    if Core.Interface.isProgressActive() then _debug('[^6DEBUG^0] - Drinking blocked, already in progress...') return end
    _debug('[^6DEBUG^0] - Drinking ' .. color .. ' junk...')
    if Core.Interface.progress({
        duration = 3000,
            label = _L('drinking_junk'),
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
    }) then
        _debug('[^6DEBUG^0] - Finished drinking ' .. color .. ' junk.')
        triggerJunkEffects()
        return true
    else
        _debug('[^6DEBUG^0] - Drinking ' .. color .. ' junk cancelled.')
        return false
    end
end)

local function openVendingMenu()
    local imgPath = Core.Inventory.IconPath
    Core.Interface.registerContext({
        id = 'junk_machine',
        title = _L('junk_machine'),
        options = {
            {
                title = _L('junk_blue'),
                icon = imgPath:format('junk_blue'),
                onSelect = function()
                    buyDrink('blue')
                end,
            },
            {
                title = _L('junk_red'),
                icon = imgPath:format('junk_red'),
                onSelect = function()
                    buyDrink('red')
                end,
            },
            {
                title = _L('junk_orange'),
                icon = imgPath:format('junk_orange'),
                onSelect = function()
                    buyDrink('orange')
                end,
            },
            {
                title = _L('junk_purple'),
                icon = imgPath:format('junk_purple'),
                onSelect = function()
                    buyDrink('purple')
                end,
            },
            {
                title = _L('junk_green'),
                icon = imgPath:format('junk_green'),
                onSelect = function()
                    buyDrink('green')
                end,
            },
        }
    })
    _debug('[^6DEBUG^0] - Opening junk machine menu...')
    Core.Interface.showContext('junk_machine')
end

local function setJunkMachineTarget()
    Core.Target.addModel('sf_prop_sf_vend_drink_01a', {
        {
            label = _L('open_machine'),
            icon = 'fas fa-bottle-water',
            distance = 1.5,
            onSelect = openVendingMenu
        }
    })
    _debug('[^6DEBUG^0] - Vending machine targets set..')
end

local function spawnVendingMachine(coords)
    if vendingMachine and DoesEntityExist(vendingMachine) then return end
    vendingMachine = Core.Natives.createObject('sf_prop_sf_vend_drink_01a', coords.xyz, coords.w, true)
    Core.Natives.setEntityProperties(vendingMachine, true, true, true)
    _debug('[^6DEBUG^0] - Vending machine spawned at ' .. json.encode(coords))
end

local function despawnVendingMachine()
    if not vendingMachine or not DoesEntityExist(vendingMachine) then return end
    DeleteEntity(vendingMachine)
    vendingMachine = nil
    _debug('[^6DEBUG^0] - Vending machine despawned')
end

function InitializeVendingMachines()
    if #machinePoints > 0 then return end
    local locations = Cfg.Options.VendingMachines.Locations
    for _, coords in pairs(locations) do
        table.insert(machinePoints, lib.points.new({
            coords = coords.xyz,
            distance = 100,
            onEnter = function()
                spawnVendingMachine(coords)
            end,
            onExit = function()
                despawnVendingMachine()
            end
        }))
    end
    setJunkMachineTarget()
    _debug('[^6DEBUG^0] - ' .. #locations .. ' vending machine locations initialized.')
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        despawnVendingMachine()
        Core.Target.removeModel('sf_prop_sf_vend_drink_01a')
        for _, point in pairs(machinePoints) do
            point:remove()
        end
    end
end)
