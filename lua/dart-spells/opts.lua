local M = {
	dart_spells = "dart_spells",
	add_comma_after_index = nil
}

function M.setup(opts)
	for key, value in pairs(opts or {}) do
		M[key] = value
	end
end

return M
