Language = Language or {}
Cfg = Cfg or {}

function locale(key, ...)
    local language = Cfg.Language or 'en'
    if not key then
        return 'ERR_TRANSLATE_NO_KEY'
    end
    local string = Language[language] and Language[language][key]
    if not string then
        return 'ERR_TRANSLATE_' .. language .. '_' .. key
    end
    return string:format(...)
end

function _debug(...)
    if not Cfg or not Cfg.Debug then return end
    print('[^6DEBUG^0] ' .. ...)
end
