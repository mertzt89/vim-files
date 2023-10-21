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

return M
