-- neotest: language-agnostic test runner.
-- Currently wired up for Go via neotest-golang. Add more adapters in the future

return {
	"nvim-neotest/neotest",
	ft = { "go" },
	cmd = { "Neotest" },
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"fredrikaverpil/neotest-golang",
		"nvim-neotest/neotest-python",
		"alfaix/neotest-gtest",
		"leoluz/nvim-dap-go",
	},
	keys = {
		{
			"<leader>tv",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle test summary",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run({ suite = false, testify = true })
			end,
			desc = "Run nearest test",
		},
		{
			"<leader>ts",
			function()
				require("neotest").run.run({ suite = true, testify = true })
			end,
			desc = "Run test suite",
		},
		{
			"<leader>ta",
			function()
				require("neotest").run.run(vim.fn.getcwd())
			end,
			desc = "Run all tests",
		},
		{
			"<leader>td",
			function()
				require("neotest").run.run({ suite = false, testify = true, strategy = "dap" })
			end,
			desc = "Debug nearest test",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Open test output",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop test run",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({ dap = { justMyCode = false } }),
				require("neotest-gtest").setup({}),
				require("neotest-python")({
					-- Extra arguments for nvim-dap configuration
					-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
					dap = { justMyCode = false },
					-- Command line arguments for runner
					-- Can also be a function to return dynamic values
					args = { "--log-level", "DEBUG" },
					-- Runner to use. Will use pytest if available by default.
					-- Can be a function to return dynamic value.
					runner = "pytest",
					-- Custom python path for the runner.
					-- Can be a string or a list of strings.
					-- Can also be a function to return dynamic value.
					-- If not provided, the path will be inferred by checking for
					-- virtual envs in the local directory and for Pipenev/Poetry configs
					python = ".venv/bin/python",
					-- Returns if a given file path is a test file.
					-- NB: This function is called a lot so don't perform any heavy tasks within it.
					-- is_test_file = function(file_path)
					--   ...
					-- end,
					-- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
					-- instances for files containing a parametrize mark (default: false)
					pytest_discover_instances = true,
				}),
			},
			quickfix = { enabled = false },
		})
	end,
}
