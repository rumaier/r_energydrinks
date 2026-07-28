local VEND_MODEL = 'sf_prop_sf_vend_drink_01a'
local CAN_MODELS = {
    blue = 'junk_can_1',
    red = 'junk_can_2',
    orange = 'junk_can_3',
    purple = 'junk_can_4',
    green = 'junk_can_5'
}

local spawners = {}
local spawnedMachine = nil
local effectsActive = false
local machinesInitialized = false

local function resetEffects()
    local strength = GetTimecycleModifierStrength()
    for i = strength, 0, -0.01 do
        SetTimecycleModifierStrength(i)
        Wait(0)
    end
    Wait(100)
    ClearTimecycleModifier()
    StatSetInt('MP0_STAMINA', 25, true)
    SetPedMoveRateOverride(cache.ped, 1.0)
    bridge.interface.notify(locale('energy_drinks'), locale('effects_ended'), 'success')
    effectsActive = false
end

local function triggerEffects()
    bridge.interface.notify(locale('energy_drinks'), locale('feel_junked'), 'info')
    SetTransitionTimecycleModifier('rply_contrast', 1.0)
    effectsActive = true
    for i = 1, 60 do
        SetTimecycleModifierStrength(i * 0.01)
        Wait(0)
    end
    if Cfg.GiveStaminaBoost then
        StatSetInt('MP0_STAMINA', 75, true)
    end
    if Cfg.BoostSprintSpeed then
        CreateThread(function()
            while effectsActive do
                SetPedMoveRateOverride(cache.ped, 1.49)
                Wait(0)
            end
        end)
    end
    SetTimeout((Cfg.EffectsDuration or 60) * 1000, function()
        resetEffects()
    end)
end

lib.callback.register('r_energydrinks:drink', function(color)
    if bridge.interface.isProgressActive() then return false end
    if effectsActive then
        bridge.interface.notify(locale('energy_drinks'), locale('effects_active'), 'error')
        return false
    end
    if bridge.interface.progress({
        duration = 3000,
        label = locale('drinking'),
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = CAN_MODELS[color], pos = vec3(0.01, 0.0, 0.06), rot = vec3(4.26, 5.97, 138.47) }
    }) then
        triggerEffects()
        return true
    end
    return false
end)

RegisterNUICallback('purchaseDrink', function(data, cb)
    if not spawnedMachine then
        cb(false)
        return
    end
    local success, err = lib.callback.await('r_energydrinks:purchaseDrink', false, data.color)
    if not success and err then
        bridge.interface.notify(locale('energy_drinks'), locale(err), 'error')
    elseif success then
        SetTimeout(3500, function()
            bridge.interface.notify(locale('energy_drinks'), locale('purchase_success', data.color), 'success')
        end)
    end
    bridge.natives.playAnimation(cache.ped, 'mini@sprunk', 'plyr_buy_drink_pt1', 4150, 0, 0.0)
    cb(success)
end)

local function openVendingInterface()
    if not Cfg.EnableMachines or not spawnedMachine then return end
    TaskTurnPedToFaceEntity(cache.ped, spawnedMachine, -1)
    repeat Wait(100) until bridge.natives.isPedFacingEntity(cache.ped, spawnedMachine)
    ClearPedTasks(cache.ped)
    SendNUIMessage({ action = 'openVendingInterface' })
    SetNuiFocus(true, true)
end

local function despawnMachine()
    if not spawnedMachine then return end
    DeleteEntity(spawnedMachine)
    spawnedMachine = nil
    log('debug','Machine despawned')
end

local function spawnMachine(data)
    if spawnedMachine then despawnMachine() end
    spawnedMachine = bridge.natives.createObject(VEND_MODEL, data.coords, data.heading, false)
    PlaceObjectOnGroundProperly(spawnedMachine)
    FreezeEntityPosition(spawnedMachine, true)
    log('debug','Machine spawned at ' .. data.coords)
end

local function initMachines()
    if machinesInitialized then return end
    if not Cfg.EnableMachines or not Cfg.MachineLocations then return end
    for _, coords in pairs(Cfg.MachineLocations) do
        table.insert(spawners, lib.points.new({
            coords = coords.xyz,
            heading = coords.w,
            distance = 150.0,
            onEnter = spawnMachine,
            onExit = despawnMachine
        }))
    end
    bridge.target.addModel(VEND_MODEL, {
        {
            label = locale('use_machine'),
            icon = 'fas fa-bottle-water',
            distance = 1.0,
            onSelect = openVendingInterface,
            canInteract = function()
                return Cfg.EnableMachines == true
            end
        }
    })
    machinesInitialized = true
    log('debug',#spawners .. ' machine spawners initialized')
end

local function tryInitMachines()
    initMachines()
end

AddEventHandler('r_energydrinks:clientConfigLoaded', tryInitMachines)

AddEventHandler('r_bridge:playerLoaded', function()
    tryInitMachines()
end)

CreateThread(function()
    Wait(500)
    tryInitMachines()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if spawnedMachine then DeleteEntity(spawnedMachine) end
    bridge.target.removeModel(VEND_MODEL)
    for _, spawner in pairs(spawners) do
        spawner:remove()
    end
end)
