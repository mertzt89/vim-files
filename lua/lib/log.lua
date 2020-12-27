-- log.lua
-- Logging

local log = {}

function log.init()
end

local function output_log(hl,...)
    local entries = {...}
    local str_entries = {}
    for k, v in pairs(entries) do
    str_entries[k] = tostring(v)
    end

    local str = table.concat(str_entries, " ")

    vim.api.nvim_command("echohl " .. hl)
    vim.api.nvim_command("echo '" .. str .. "'")
    vim.api.nvim_command("echohl None")
end

function log.error(...)
    output_log("ErrorMsg", ...)
end

function log.warn(...)
    output_log("WarningMsg", ...)
end

function log.info(...)
    output_log("Normal", ...)
end

function log.debug(...)
    output_log("MoreMsg", ...)
end

return log
