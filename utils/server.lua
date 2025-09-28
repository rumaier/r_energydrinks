Core = exports.r_bridge:returnCoreObject()

local resource = GetCurrentResourceName()
local version = GetResourceMetadata(resource, 'version', 0)
local bridgeStarted = GetResourceState('r_bridge') == 'started'

DatabaseBuilt = false

local function buildDatabase()
    local built = MySQL.query.await('SHOW TABLES LIKE "' .. resource .. '"')
    if #built > 0 then
        DatabaseBuilt = true
        return
    end
    built = MySQL.query.await('CREATE TABLE `' .. resource .. '` ( `unit` tinyint(4) NOT NULL, PRIMARY KEY (`unit`) )')
    if not built then print('[^8ERROR^0] - Failed to create database table for ' .. resource) end
    print('[^2SUCCESS^0] - Database table for ' .. resource .. ' created.')
    DatabaseBuilt = true
end

local function checkResourceVersion()
    if not Cfg.Server.VersionCheck then return end
    Core.VersionCheck(resource)
    SetTimeout(3600000, checkResourceVersion)
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= resource then return end
    print('------------------------------')
    print(_L('resource_version', resource, version))
    if bridgeStarted then
        print(_L('bridge_detected'))
    else
        print(_L('bridge_not_detected'))
    end
    if Cfg.Debug then print(_L('debug_enabled')) end
    print('------------------------------')
    checkResourceVersion()
    -- buildDatabase()
end)
