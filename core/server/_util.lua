local resource = GetCurrentResourceName()
local version = GetResourceMetadata(resource, 'version', 0)
local rateLimits = {}

function IsRateLimited(src, action, duration)
    local last = rateLimits[('%s:%s'):format(src, action)]
    return last and GetGameTimer() - last < duration
end

function SetRateLimit(src, action)
    rateLimits[('%s:%s'):format(src, action)] = GetGameTimer()
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

local function checkVersion()
    if not Cfg.VersionCheck then return end
    bridge.version.check(resource)
    SetTimeout(3600000, checkVersion)
end

AddEventHandler('onResourceStart', function(name)
    if name ~= resource then return end
    print('------------------------------')
    print(resource .. ' | ' .. version)
    if bridge then
        print('^2' .. locale('bridge_loaded') .. '^0')
    else
        print('^1' .. locale('update_bridge') .. '^0')
    end
    if Cfg and Cfg.Debug then print('^1' .. locale('debug_enabled') .. '^0') end
    print('------------------------------')
    checkVersion()
end)

AddEventHandler('playerDropped', function()
    local src = source
    local prefix = '^' .. src .. ':'
    for key in pairs(rateLimits) do
        if key:match(prefix) then rateLimits[key] = nil end
    end
end)
