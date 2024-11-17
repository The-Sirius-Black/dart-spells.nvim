local copy_with = require('dart-spells.copy-with')
local mock = require('luassert.mock')

local class_mock = {
	name = "Test",
	range = { start_row = 5, end_row = 10 },
	variables = { { name = 'foo', type = 'String', is_final = true }, { name = 'bar', type = 'String', is_final = true } },
	methods = { { name = 'copyWith', range = { start_row = 5, end_row = 7 } } }
}

local result_mock =
"Test copyWith({String? foo,String? bar,}){return Test(foo: foo ?? this.foo,bar: bar ?? this.bar,);}"

describe("create_copy_with_code", function()
	it("should create a correct copy_with code string", function()
		local code = copy_with.test_create_copy_with_code(class_mock.name, class_mock.variables)
		assert.is_equal(code, result_mock)
	end)
end)


describe("insert_copy_with", function()
	it("should insert copy_with correctly", function()
		local api = mock(vim.api, true)

		copy_with.test_insert_copy_with(class_mock)

		local refs = api.nvim_buf_set_lines.calls[1].refs

		assert.are.equal(refs[1], 0)
		assert.are.equal(refs[2], 10)
		assert.are.equal(refs[3], 10)
		assert.are.same(refs[5], { "", result_mock })
	end)
end)

describe("remove_existing_copy_with", function()
	it("should be called if copyWith exist in code", function()
		local api = mock(vim.api, true)

		copy_with.test_remove_existing_copy_with(class_mock.methods)

		local refs = api.nvim_buf_set_lines.calls[1].refs

		assert.are.same(refs[5], { "", result_mock })
	end)

	it("should remove existing copyWith from the method", function()
		local api = mock(vim.api, true)

		copy_with.test_remove_existing_copy_with(class_mock.methods)

		local refs = api.nvim_buf_set_lines.calls[2].refs

		assert.are.equal(refs[1], 0)
		assert.are.equal(refs[2], 5)
		assert.are.equal(refs[3], 8)
		assert.are.same(refs[5], {})
	end)
end)
