local M = {}

function M.get_dart_lsp()
	local clients = vim.lsp.get_active_clients()

	local dart_client = nil

	for _, client in ipairs(clients) do
		if client.name == "dartls" then
			dart_client = client
			break
		end
	end

	if not dart_client then
		return
	end

	return dart_client
end

function M.get_first_value(tabl)
	for _, value in pairs(tabl) do
		return value
	end
end

function M.replace_range(bufnr, start_line, start_char, end_line, end_char, lines)
	local cleaned = lines:gsub("\r", "")
	local splited_lines = vim.split(cleaned, "\n", { plain = true })
	vim.api.nvim_buf_set_text(bufnr, start_line, start_char, end_line, end_char, splited_lines)
end

function M.insert_comma_before_closing_brace(input)
	if input:match("%s*[}]%s*[%)]$") or input:match("[}]%s*$") then
		return input:sub(1, -2) .. ", " .. input:sub(-1)
	end

	return input
end

function M.get_exe_path()
	local source = debug.getinfo(1, "S").source:sub(2)
	return vim.fn.fnamemodify(source, ":h:h:h") .. "/bin/dart_spells.exe"
end

function M.move_cursor_after(char)
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_number = cursor_pos[1] - 1

	local line_content = vim.api.nvim_buf_get_lines(bufnr, line_number, line_number + 1, false)[1]

	local char_pos = string.find(line_content, char)

	if char_pos then
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], char_pos })

		vim.cmd("startinsert")
	end
end

return M
