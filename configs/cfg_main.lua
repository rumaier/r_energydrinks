--                                          _      _       _
-- _ __  ___ _ __   ___ _ __ __ _ _   _  __| |_ __(_)_ __ | | _____
-- | '__|/ _ \ '_ \ / _ \ '__/ _` | | | |/ _` | '__| | '_ \| |/ / __|
-- | |  |  __/ | | |  __/ | | (_| | |_| | (_| | |  | | | | |   <\__ \
-- |_|___\___|_| |_|\___|_|  \__, |\__, |\__,_|_|  |_|_| |_|_|\_\___/
--  |_____|                  |___/ |___/
--
--  Need support? Join our Discord server for help: https://discord.gg/rscripts
--
Cfg = {
    --  ___  ___ _ ____   _____ _ __
    -- / __|/ _ \ '__\ \ / / _ \ '__|
    -- \__ \  __/ |   \ V /  __/ |
    -- |___/\___|_|    \_/ \___|_|
    Server = {
        Language = 'en',     -- Resource language ('en': English, 'es': Spanish, 'fr': French, 'de': German, 'pt': Portuguese, 'zh': Chinese)
        VersionCheck = true, -- Version check (true: enabled, false: disabled)
    },
    --              _   _
    --   ___  _ __ | |_(_) ___  _ __  ___
    --  / _ \| '_ \| __| |/ _ \| '_ \/ __|
    -- | (_) | |_) | |_| | (_) | | | \__ \
    --  \___/| .__/ \__|_|\___/|_| |_|___/
    --       |_|
    Options = {
        VendingMachines = {
            Enabled = true,                        -- Determines if Junk Vending Machines spawn in the defined locations below.
            DrinkPrice = 3,                        -- Determines the price of a Junk Energy Drink from the machines.
            Locations = {
                vec4(-47.87, -1090.21, 25.42, 338.36), -- Main PDM
                vec4(324.03, -233.61, 53.22, 249.11), -- Pinkcage Motel
                vec4(-11.89, -1478.20, 29.50, 138.79), -- Strawberry Liquor Store
            },
        },

        Effects = {
            StaminaBoost = true, -- Determines if energy drinks give a Stamina Boost.
            SprintBoost = true, -- Determines if energy drinks give a Sprint Boost.
            Duration = 60    -- Determines how long the above effects will last on a player.
        },
    },
    --      _      _
    --   __| | ___| |__  _   _  __ _
    --  / _` |/ _ \ '_ \| | | |/ _` |
    -- | (_| |  __/ |_) | |_| | (_| |
    --  \__,_|\___|_.__/ \__,_|\__, |
    --                         |___/
    Debug = false -- Enable debug prints (true: enabled, false: disabled)
}
