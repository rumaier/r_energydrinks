Language = Language or {}

function _L(str, ...)
    if str then
        local string = Language[Cfg.Language][str]
        if string then
            return string.format(string, ...)
        else
            return "ERR_TRANSLATE_"..(str).."_404"
        end
    else
        return "ERR_TRANSLATE_404"
    end
end