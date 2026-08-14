--                                          _      _       _
-- _ __  ___ _ __   ___ _ __ __ _ _   _  __| |_ __(_)_ __ | | _____
-- | '__|/ _ \ '_ \ / _ \ '__/ _` | | | |/ _` | '__| | '_ \| |/ / __|
-- | |  |  __/ | | |  __/ | | (_| | |_| | (_| | |  | | | | |   <\__ \
-- |_|___\___|_| |_|\___|_|  \__, |\__, |\__,_|_|  |_|_| |_|_|\_\___/
--  |_____|                  |___/ |___/
--
--  Need support? Join our Discord server for help: https://discord.gg/TR38cZFdQk
--
Cfg = {}

Cfg.Language = 'en'     -- Languages: 'en': English, 'es': Spanish, 'fr': French, 'de': German, 'pt': Portuguese, 'zh': Chinese
Cfg.NuiColor = 'violet' -- Colors: 'dark', 'gray', 'red', 'pink', 'grape', 'violet', 'indigo', 'blue', 'cyan', 'teal', 'green', 'lime', 'yellow', 'orange'
Cfg.VersionCheck = true -- Intermittent version checking (boolean)
Cfg.Debug = false       -- Debug prints, not recommended for live servers (boolean)

Cfg.EnableMachines = true                  -- Enable energy drink machines (boolean)
Cfg.MachineLocations = {
    vec4(-47.87, -1090.21, 25.42, 338.36), -- Main PDM
    vec4(324.03, -233.61, 53.22, 249.11),  -- Pinkcage Motel
    vec4(-11.89, -1478.20, 29.50, 138.79), -- Strawberry Liquor Store
}
Cfg.DrinkPrice = 3                         -- Price of a drink (number)

Cfg.GiveStaminaBoost = true                -- Give stamina boost to players (boolean)
Cfg.BoostSprintSpeed = true                -- Boost sprint speed (boolean)
Cfg.EffectsDuration = 60                   -- Duration of the effects in seconds (number)
