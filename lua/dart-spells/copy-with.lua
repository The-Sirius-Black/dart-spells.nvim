local utils = require("dart-spells.utils")

local M = {}

local function remove_copy_with(methods)
	for _, method in ipairs(methods) do
		if method.name == "copyWith" then
			vim.api.nvim_buf_set_lines(
				0,
				method.range.start_row,
				method.range.end_row + 1,
				false,
				{}
			)
		end
	end
end

local function parse_vars(vars)
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
		params = params .. var.type .. "? " .. var.name .. ","
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

local function gen_copy_with(class_name, vars)
	local params = gen_params(vars)

	local method_signature = class_name .. " copyWith({"
	method_signature = method_signature .. params .. "}){"

	local args = gen_args(vars)

	local method_body = "return " .. class_name .. "(" .. args .. ");"

	return method_signature .. method_body .. "}"
end

local function gen_command()
	local exePath = utils.get_exe_path()

	local buffer_path = vim.api.nvim_buf_get_name(0)

	local path = vim.fn.fnamemodify(buffer_path, ":p")

	local line = vim.api.nvim_win_get_cursor(0)[1]

	return exePath .. " --class-at-cursor -r " .. line .. " -p " .. path
end

function M.gen_copy_with()
	local command = gen_command()

	local output_buffer = ""

	vim.fn.jobstart(command, {
		on_stdout = function(_, data, _)
			output_buffer = output_buffer .. table.concat(data, "")
		end,
		on_exit = function(_, exit_code, _)
			if exit_code == 0 then
				local success, class = pcall(vim.json.decode, output_buffer)

				if not success then
					local err_msg = "Failed to decode JSON. Raw data: " .. vim.inspect(output_buffer)
					vim.notify(err_msg, vim.log.levels.ERROR)
					return
				else
					vim.cmd("write")

					local vars = parse_vars(class.variables)

					local copy_with = gen_copy_with(class.name, vars)

					vim.api.nvim_buf_set_lines(
						0,
						class.range.end_row,
						class.range.end_row,
						false,
						{ "", copy_with }
					)

					remove_copy_with(class.methods)
				end
			end
		end,
	})
end

return M
