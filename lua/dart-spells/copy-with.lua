local cmds = require("dart-spells.commands")

local M = {}

local function remove_existing_copy_with(methods)
	local copy_with = cmds.filter_func_by_name("copyWith", methods)

	if not copy_with then
		return
	end

	vim.api.nvim_buf_set_lines(
		0,
		copy_with.range.start_row,
		copy_with.range.end_row + 1,
		false,
		{}
	)
end

local function filter_final_vars(vars)
	local parsed_vars = {}

	for _, var in ipairs(vars) do
		if var.is_final then
			table.insert(parsed_vars, var)
		end
	end

	return parsed_vars
end

local function gen_params(vars)
	local params = ""

	for _, var in ipairs(vars) do
		local type = string.gsub(var.type, "?", "")
		params = params .. type .. "? " .. var.name .. ","
	end

	return params
end

local function gen_args(vars)
	local args = ""

	for _, var in ipairs(vars) do
		args = args .. var.name .. ": " .. var.name .. " ?? " .. "this." .. var.name .. ","
	end

	return args
end

local function create_copy_with_code(class_name, vars)
	local params = gen_params(vars)

	local method_signature = class_name .. " copyWith({"
	method_signature = method_signature .. params .. "}){"

	local args = gen_args(vars)

	local method_body = "return " .. class_name .. "(" .. args .. ");"

	return method_signature .. method_body .. "}"
end


local function insert_copy_with(class)
	local vars = filter_final_vars(class.variables)

	local copy_with = create_copy_with_code(class.name, vars)

	vim.api.nvim_buf_set_lines(
		0,
		class.range.end_row,
		class.range.end_row,
		false,
		{ "", copy_with }
	)


	remove_existing_copy_with(class.methods)
end

function M.gen_copy_with()
	cmds.get_class_at_cursor(insert_copy_with)
end

-- For testing purposes
M.test_remove_existing_copy_with = remove_existing_copy_with
M.test_create_copy_with_code = create_copy_with_code
M.test_insert_copy_with = insert_copy_with

return M
