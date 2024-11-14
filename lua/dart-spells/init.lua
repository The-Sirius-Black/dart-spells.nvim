local wrap = require("dart-spells.widget-wrapper")
local utils = require("dart-spells.utils")
local constants = require("dart-spells.constants")
local ca = require("dart-spells.code-actions")

local M = {}

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

function M.code_actions()
  ca.code_actions(M.bloc_code_actions())
end

function M.bloc_code_actions()
  return {
    {
      title = "Wrap with Bloc Builder",
      action = M.wrap_with_bloc_builder,
      kind = constants.builder_kind,
    },
    {
      title = "Wrap with Bloc Listener",
      action = M.wrap_with_bloc_listener,
      kind = constants.widget_kind,
    },
    {
      title = "Wrap with Bloc Consumer",
      action = M.wrap_with_bloc_consumer,
      kind = constants.builder_kind,
    },
    {
      title = "Wrap with Bloc Provider",
      action = M.wrap_with_bloc_provider,
      kind = constants.widget_kind,
    },
    {
      title = "Wrap with Multi Bloc Provider",
      action = M.wrap_with_multi_bloc_provider,
      kind = constants.widget_kind,
    },
  }
end

return M
