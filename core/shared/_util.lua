Cfg = Cfg or {}

local LOG = {
    debug = { color = 6, tag = 'DEBUG', enabled = true },
    warn = { color = 3, tag = 'WARN', enabled = true },
    error = { color = 8, tag = 'ERROR', enabled = true },
}

Language = Language or {}

function locale(key, ...)
    if not key then
        return 'ERR_TRANSLATE_NO_KEY'
    end
    local lang = (Cfg and Cfg.Language) or 'en'
    local string = Language[lang] and Language[lang][key]
    if not string then
        return 'ERR_TRANSLATE_' .. lang .. '_' .. key
    end
    return string:format(...)
end

---@param level 'debug' | 'warn' | 'error'
function log(level, ...)
    local cfg = LOG[level]
    if not cfg then return end
    if level == 'debug' and not (Cfg and Cfg.Debug) then return end
    if not cfg.enabled then return end
    print(('[^%d%s^0] %s'):format(cfg.color, cfg.tag, ...))
end
