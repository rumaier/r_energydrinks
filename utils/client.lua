Core = exports.r_bridge:returnCoreObject()

local framework = Core.Framework.Current

local onPlayerLoaded = framework == 'es_extended' and 'esx:playerLoaded' or 'QBCore:Client:OnPlayerLoaded'
RegisterNetEvent(onPlayerLoaded, function()
    InitializeVendingMachines()
end)