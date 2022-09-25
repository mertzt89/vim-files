local util = {}

util.get_separator = function()
    if util.is_windows then
        return "\\"
    end
    return "/"
end

util.join_paths = function(...)
    local separator = util.get_separator()
    return table.concat({ ... }, separator)
end

function util.format_table(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. util.format_table(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

function util.print_table(o)
    print(util.format_table(o))
end

return util
