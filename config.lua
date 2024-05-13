--                                          _      _       _        
-- _ __  ___ _ __   ___ _ __ __ _ _   _  __| |_ __(_)_ __ | | _____ 
-- | '__|/ _ \ '_ \ / _ \ '__/ _` | | | |/ _` | '__| | '_ \| |/ / __|
-- | |  |  __/ | | |  __/ | | (_| | |_| | (_| | |  | | | | |   <\__ \
-- |_|___\___|_| |_|\___|_|  \__, |\__, |\__,_|_|  |_|_| |_|_|\_\___/
--  |_____|                  |___/ |___/                             

Cfg = {
    -- Server Options
    Language = 'en',          -- Determines the language. ('en': English)
    Notification = 'default', -- Determines the notification system. ('default', 'ox', 'custom': can be customized in bridge/framework/YOURFRAMEWORK)

    -- Vending Machine Options
    VendingMachines = {
        Enabled = true,
        Locations = {
            vec4(-47.87, -1090.21, 25.42, 338.36), -- Main PDM
            vec4(324.03, -233.61, 53.22, 249.11), -- Pinkcage Motel
            vec4(-11.89, -1478.20, 29.50, 138.79), -- Strawberry Liquor Store
        },
    },

    -- Debug
    Debug = true
}