local MACHINE_RADIUS = 5.0
local PURCHASE_COOLDOWN_MS = 1000

local cooldowns = {}

local function getCooldownKey(src, action)
    return ('%s:%s'):format(src, action)
end

local function isOnCooldown(src, action, duration)
    local last = cooldowns[getCooldownKey(src, action)]
    return last and GetGameTimer() - last < duration
end

local function setCooldown(src, action)
    cooldowns[getCooldownKey(src, action)] = GetGameTimer()
end

local function isPlayerNearMachine(src)
    if not Cfg.MachineLocations then return false end
    local player = GetPlayerPed(src)
    if not player or player == 0 then return false end
    local coords = GetEntityCoords(player)
    local nearest = math.huge
    for _, machine in pairs(Cfg.MachineLocations) do
        local distance = #(coords - machine.xyz)
        if distance < nearest then
            nearest = distance
        end
    end
    return nearest <= MACHINE_RADIUS
end

local function removeMoney(src, amount)
    local before = bridge.framework.getBalance(src, 'money')
    if before < amount then return false end
    bridge.framework.removeBalance(src, 'money', amount)
    return bridge.framework.getBalance(src, 'money') <= before - amount
end

local function refundMoney(src, amount)
    local before = bridge.framework.getBalance(src, 'money')
    bridge.framework.addBalance(src, 'money', amount)
    return bridge.framework.getBalance(src, 'money') >= before + amount
end

lib.callback.register('r_energydrinks:getClientConfig', function()
    return {
        Language = Cfg.Language,
        NuiColor = Cfg.NuiColor,
        Debug = Cfg.Debug,
        EnableMachines = Cfg.EnableMachines,
        MachineLocations = Cfg.MachineLocations,
        GiveStaminaBoost = Cfg.GiveStaminaBoost,
        BoostSprintSpeed = Cfg.BoostSprintSpeed,
        EffectsDuration = Cfg.EffectsDuration,
    }
end)

lib.callback.register('r_energydrinks:purchaseDrink', function(src, color)
    if isOnCooldown(src, 'purchase', PURCHASE_COOLDOWN_MS) then
        log('warn', ('Player %s %s'):format(src, 'rate limited purchaseDrink'))
        return false
    end
    if not Cfg.EnableMachines then
        log('warn', ('Player %s %s'):format(src, 'blocked purchaseDrink while machines disabled'))
        return false
    end
    if type(color) ~= 'string' then
        log('warn', ('Player %s %s'):format(src, 'invalid color type for purchaseDrink'))
        return false
    end
    if not isPlayerNearMachine(src) then
        log('warn', ('Player %s %s'):format(src, 'attempted purchaseDrink away from machine'))
        return false
    end

    local itemName = 'junk_' .. color
    if not bridge.inventory.canCarry(src, itemName, 1) then
        log('warn', ('Player %s %s'):format(src, 'cannot carry purchased drink'))
        return false
    end

    local price = Cfg.DrinkPrice
    if bridge.framework.getBalance(src, 'money') < price then
        return false, 'insufficient_funds'
    end

    if not removeMoney(src, price) then
        log('warn', ('Player %s %s'):format(src, 'failed to remove money for purchaseDrink'))
        return false
    end

    if not bridge.inventory.addItem(src, itemName, 1) then
        log('warn', ('Player %s %s'):format(src, 'failed to add drink after purchase'))
        refundMoney(src, price)
        return false
    end

    setCooldown(src, 'purchase')
    return true
end)

local function registerDrinkItems()
    local colors = { 'blue', 'red', 'orange', 'purple', 'green' }
    for _, color in pairs(colors) do
        bridge.framework.registerUsableItem('junk_' .. color, function(src, item, data)
            item = data or item
            if not item or not item.name then return end
            if (bridge.inventory.getItemCount(src, item.name) or 0) < 1 then
                log('warn', ('Player %s %s'):format(src, 'attempted to drink without item'))
                return
            end
            if lib.callback.await('r_energydrinks:drink', src, color) then
                if not bridge.inventory.removeItem(src, item.name, 1) then
                    log('warn', ('Player %s %s'):format(src, 'failed to remove drink item after use'))
                end
            end
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    registerDrinkItems()
end)
