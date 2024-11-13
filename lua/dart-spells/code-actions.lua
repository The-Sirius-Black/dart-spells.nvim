local utils = require("dart-spells.utils")

local api = vim.api

local M = {}

local function merge_custom_actions(actions, custom_actions)
	for _, custom_action in ipairs(custom_actions) do
		local kind = custom_action.kind

		local contains_kind = utils.table_contains(actions, function(_, action)
			if action.kind == kind then
				return true
			end
		end)

		if contains_kind then
			custom_action.custom = true
			custom_action.idx = #actions + 1
			table.insert(actions, custom_action)
		end
	end
end

function M.code_actions(custom_actions)
	local lsp = utils.get_dart_lsp()

	if not lsp then
		return
	end

	local current_bufnr = api.nvim_get_current_buf()

	local req_params = utils.create_req_params(current_bufnr)

	local actions = {}

	lsp.request("textDocument/codeAction", req_params, function(_, result)
		if not result then
			vim.notify("no code actions", vim.log.levels.INFO)
			return
		end

		for idx, code_action in ipairs(result) do
			code_action.idx = idx
			table.insert(actions, code_action)
		end

		merge_custom_actions(actions, custom_actions)

		vim.ui.select(actions, {
			prompt = "Code Actions",
			format_item = function(action)
				return action.idx .. " " .. action.title
			end,
		}, function(choice)
			if choice then
				if choice.custom then
					choice.action()
				else
					vim.lsp.util.apply_workspace_edit(choice.edit, lsp.offset_encoding)
				end
			end
		end)
	end)
end

return M
