local wrap = require("dart-spells.widget_wrapper")
local utils = require("dart-spells.utils")
local constants = require("dart-spells.constants")
local copy_with = require("dart-spells.copy-with")

local M = {}

function M.copy_with()
	copy_with.gen_copy_with()
end

local function move_cursor_after_angle()
	utils.move_cursor_after("<")
end

function M.wrap_with_bloc_builder()
	wrap.wrap_with_builder(constants.bloc_builder, move_cursor_after_angle)
end

function M.wrap_with_bloc_consumer()
	wrap.wrap_with_builder(constants.bloc_consumer, move_cursor_after_angle)
end

function M.wrap_with_bloc_listener()
	wrap.wrap_with_widget(constants.bloc_listener, move_cursor_after_angle)
end

function M.wrap_with_bloc_provider()
	wrap.wrap_with_widget(constants.bloc_provider, move_cursor_after_angle)
end

function M.wrap_with_multi_bloc_provider()
	wrap.wrap_with_widget(constants.multi_bloc_provider)
end

function M.wrap_with_builder(replacment_text, callback)
	wrap.wrap_with_builder(replacment_text, callback)
end

function M.wrap_with_widget(replacment_text, callback)
	wrap.wrap_with_widget(replacment_text, callback)
end

return M
