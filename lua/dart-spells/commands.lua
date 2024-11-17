local opts = require("dart-spells.opts")

local M = {}

local function gen_class_at_cursor_cmd()
	local buffer_path = vim.api.nvim_buf_get_name(0)

	local path = vim.fn.fnamemodify(buffer_path, ":p")

	local line = vim.api.nvim_win_get_cursor(0)[1]

	return opts.dart_spells .. " --class-at-cursor -r " .. line .. " -p " .. path
end

function M.get_class_at_cursor(on_class_found)
	local command = gen_class_at_cursor_cmd()

	local output_buffer = ""

	vim.cmd("write!")

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
				end

				on_class_found(class)
				vim.cmd("write!")
				return
			end

			local err_msg = "Command exited with code: " .. exit_code
			vim.notify(err_msg, vim.log.levels.ERROR)
		end,
	})
end

function M.filter_func_by_name(name, methods)
	for _, method in ipairs(methods) do
		if method.name == name then
			return method
		end
	end
	return nil
end

return M
