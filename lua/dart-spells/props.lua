local cmds = require("dart-spells.commands")
local opts = require("dart-spells.opts")

local M = {}

local function remove_existing_props(methods)
	local method = cmds.filter_func_by_name("props", methods)


	if not method then
		return
	end

	vim.api.nvim_buf_set_lines(
		0,
		method.range.start_row,
		method.range.end_row + 1,
		false,
		{}
	)
end

local function create_props_code(vars)
	local props = ""

	for _, var in ipairs(vars) do
		props = #props == 0 and props or props .. ","
		props = props .. var.name
	end

	if opts.add_comma_after_index and #vars > opts.add_comma_after_index then
		props = props .. ","
	end

	return "@override List<Object?> get props => [" .. props .. "];"
end


local function insert_props(class)
	local props = create_props_code(class.variables)

	vim.api.nvim_buf_set_lines(
		0,
		class.range.end_row,
		class.range.end_row,
		false,
		{ "", props }
	)

	remove_existing_props(class.methods)
end


function M.gen_props()
	cmds.get_class_at_cursor(insert_props)
end

return M
