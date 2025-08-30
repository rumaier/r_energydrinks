Language = Language or {}

function _L(key, ...)
    local lang = Cfg.Server.Language or "en"
    if not key then return 'ERR_TRANSLATE_404' end
    local str = Language[lang] and Language[lang][key]
    if not str then return 'ERR_TRANSLATE_' .. key .. '' end
    return str:format(...)
end

math.lerp = function(a, b, t)
    return a + (b - a) * t
end

math.round = function(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

math.clamp = function(value, min, max)
    return math.max(min, math.min(max, value))
end
