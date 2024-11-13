local utils = require("dart-spells.utils")

local api = vim.api

local M = {}

local widget = {
	kind = "refactor.flutter.wrap.generic",
	pattern = "widget%(",
}

local builder = {
	kind = "refactor.flutter.wrap.builder",
	pattern = "Builder%(%s*builder:%s*%b()",
}

local function create_req_params(bufnr)
	local uri = vim.uri_from_bufnr(bufnr)
	local diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)

	local params = {
		textDocument = {
			uri = uri,
		},
		range = vim.lsp.util.make_range_params().range,
		context = {
			diagnostics = diagnostics,
			triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
		},
	}

	return params
end

local function wrap_widget_with(replacement_text, callback, wrap_type)
	local lsp = utils.get_dart_lsp()

	if not lsp then
		return
	end

	local current_bufnr = api.nvim_get_current_buf()

	local req_params = create_req_params(current_bufnr)

	lsp.request("textDocument/codeAction", req_params, function(_, result)
		if not result then
			return
		end

		for _, code_action in ipairs(result) do
			if code_action.kind == wrap_type.kind then
				local file_changes = utils.get_first_value(code_action.edit.changes)

				local range = utils.get_first_value(file_changes).range
				local newText = utils.get_first_value(file_changes).newText

				if wrap_type.kind == builder.kind then
					newText = utils.insert_comma_before_closing_brace(newText)
				end

				local replacedText = newText:gsub(wrap_type.pattern, replacement_text)

				utils.replace_range(
					current_bufnr,
					range["start"].line,
					range["start"].character,
					range["end"].line,
					range["end"].character,
					replacedText
				)

				if callback then
					callback()
				end

				return
			end
		end
	end)
end

function M.wrap_with_builder(replacement_text, callback)
	wrap_widget_with(replacement_text, callback, builder)
end

function M.wrap_with_widget(replacement_text, callback)
	wrap_widget_with(replacement_text, callback, widget)
end

return M
