local opts = require('dart-spells.opts')
local props = require('dart-spells.props')
local mock = require('luassert.mock')


local class_mock = {
	range = { start_row = 5, end_row = 10 },
	variables = { { name = 'foo' }, { name = 'bar' } },
	methods = { { name = 'props', range = { start_row = 5, end_row = 7 } } }
}

local vars_mock = { { name = 'foo' }, { name = 'bar' } }
local vars_mock_with_extra = { { name = 'foo' }, { name = 'bar' }, { name = 'baz' } }

local props_definition_mock = '@override List<Object?> get props => [foo,bar];'
local props_definition_with_extra_mock = '@override List<Object?> get props => [foo,bar,baz];'
local props_definition_with_extra_comma = '@override List<Object?> get props => [foo,bar,baz,];'

describe("create_props_code", function()
	it("should create a correct props code string", function()
		local code = props.test_create_props_code(vars_mock)
		assert.is_equal(code, props_definition_mock)
	end)

	it("it should not add a comma if add_comma_after_index is not set", function()
		local code = props.test_create_props_code(vars_mock_with_extra)
		assert.is_equal(code, props_definition_with_extra_mock)
	end)

	it("should add a comma if add_comma_after_index is set", function()
		opts.add_comma_after_index = 2
		local code = props.test_create_props_code(vars_mock_with_extra)
		assert.is_equal(code, props_definition_with_extra_comma)
	end)
end)


describe("insert_props", function()
	it("should insert props correctly", function()
		local api = mock(vim.api, true)

		props.test_insert_props(class_mock)

		local refs = api.nvim_buf_set_lines.calls[1].refs

		assert.are.equal(refs[1], 0)
		assert.are.equal(refs[2], 10)
		assert.are.equal(refs[3], 10)
		assert.are.same(refs[5], { "", props_definition_mock })
	end)
end)

describe("remove_existing_props", function()
	it("should be called if props exist in code", function()
		local api = mock(vim.api, true)

		props.test_remove_existing_props(class_mock.methods)

		local refs = api.nvim_buf_set_lines.calls[1].refs

		assert.are.same(refs[5], { "", props_definition_mock })
	end)

	it("should remove existing props from the method", function()
		local api = mock(vim.api, true)

		props.test_remove_existing_props(class_mock.methods)

		local refs = api.nvim_buf_set_lines.calls[2].refs

		assert.are.equal(refs[1], 0)
		assert.are.equal(refs[2], 5)
		assert.are.equal(refs[3], 8)
		assert.are.same(refs[5], {})
	end)
end)
