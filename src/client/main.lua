local vendingMachine = nil
local energyEffects = false

local function buyDrink(color)
    Core.Natives.SetEntityProperties(cache.ped, true, false, false)
    Core.Natives.PlayAnim(cache.ped, 'mini@sprunk', 'plyr_buy_drink_pt1', 4150, 0, 0.0)
    local bought = lib.callback.await('r_energydrinks:buyDrink', false, color)
    if not bought then return Core.Framework.Notify(_L('not_enough_money'), 'error') end
    Core.Natives.SetEntityProperties(cache.ped, false, false, false)
    Core.Framework.Notify(_L('bought_junk'), 'success')
end

local function boostSprintSpeed()
    CreateThread(function()
        while energyEffects do
            SetPedMoveRateOverride(cache.ped, 1.49)
            Wait(0)
        end
    end)
end

local function resetEffects()
    local currentStrength = GetTimecycleModifierStrength()
    for i = currentStrength, 0, -0.01 do
        SetTimecycleModifierStrength(i)
        Wait(0)
    end
    Wait(100)
    ClearTimecycleModifier()
    StatSetInt(`MP0_STAMINA`, 25, true)
    SetPedMoveRateOverride(cache.ped, 1.0)
    Core.Framework.Notify(_L('wore_off'), 'info')
end

local props = { blue = 'junk_can_1', red = 'junk_can_2', orange = 'junk_can_3', purple = 'junk_can_4', green = 'junk_can_5' }
lib.callback.register('r_energydrinks:drinkJunk', function(color)
    if energyEffects then Core.Framework.Notify(_L('already_junked'), 'error') return false end
    energyEffects = true
    if lib.progressCircle({
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
        Core.Framework.Notify(_L('feel_junked'), 'success')
        SetTransitionTimecycleModifier("rply_contrast", 1)
        for i = 1, 60 do
            SetTimecycleModifierStrength(i * 0.01)
            Wait(0)
        end
        if Cfg.Effects.StaminaBoost then
            StatSetInt(`MP0_STAMINA`, 75, true)
        end
        if Cfg.Effects.SprintBoost then
            boostSprintSpeed()
        end
        SetTimeout((Cfg.Effects.Duration * 1000), function()
            resetEffects()
            energyEffects = false
        end)
        return true
    end
end)

local function openVendingMenu()
    lib.registerContext({
        id = 'vendingmachinemenu',
        title = _L('junk_machine'),
        options = {
            {
                title = _L('junk_blue'),
                icon = 'nui://r_energydrinks/assets/images/junk_teal.png',
                onSelect = function()
                    buyDrink('blue')
                end,
            },
            {
                title = _L('junk_red'),
                icon = 'nui://r_energydrinks/assets/images/junk_red.png',
                onSelect = function()
                    buyDrink('red')
                end,
            },
            {
                title = _L('junk_orange'),
                icon = 'nui://r_energydrinks/assets/images/junk_orange.png',
                onSelect = function()
                    buyDrink('orange')
                end,
            },
            {
                title = _L('junk_purple'),
                icon = 'nui://r_energydrinks/assets/images/junk_purple.png',
                onSelect = function()
                    buyDrink('purple')
                end,
            },
            {
                title = _L('junk_green'),
                icon = 'nui://r_energydrinks/assets/images/junk_green.png',
                onSelect = function()
                    buyDrink('green')
                end,
            },
        }
    })
    lib.showContext('vendingmachinemenu')
end

local function setVendingTarget()
    Core.Target.AddModel('sf_prop_sf_vend_drink_01a', {
        {
            label = _L('open_machine'),
            name = 'junkvendmenu',
            icon = 'fas fa-bottle-water',
            distance = 1,
            onSelect = function()
                openVendingMenu()
            end
        }
    })
end

local machinesSetup = false
function SetVendPoints()
    if machinesSetup then return end
    for i = 1, #Cfg.VendingMachines.Locations do
        local coords = Cfg.VendingMachines.Locations[i]
        lib.points.new({ coords = coords.xyz, distance = 100,
            onEnter = function()
                print('enter')
                vendingMachine = Core.Natives.CreateProp('sf_prop_sf_vend_drink_01a', coords.xyz, coords.w, false)
            end,
            onExit = function()
                print('exit')
                if not vendingMachine then return end
                DeleteEntity(vendingMachine)
                vendingMachine = nil
            end,
        })
    end
    setVendingTarget()
    machinesSetup = true
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if vendingMachine then
            DeleteEntity(vendingMachine)
            vendingMachine = nil
        end
    end
end)
