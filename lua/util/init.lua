local M = {}

function M.list_contains(list, element)
	if not list then
		return false
	end

	for _, e in pairs(list) do
		if e == element then
			return true
		end
	end

	return false
end

function M.opts(name)
	local plugin = require("lazy.core.config").plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

function M.fg(name)
	---@type {foreground?:number}?
	---@diagnostic disable-next-line: deprecated
	local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
		or vim.api.nvim_get_hl_by_name(name, true)
	---@diagnostic disable-next-line: undefined-field
	local fg = hl and (hl.fg or hl.foreground)
	return fg and { fg = string.format("#%06x", fg) } or nil
end

return M