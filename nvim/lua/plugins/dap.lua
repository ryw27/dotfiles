-- DAP
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				desc = "Debug: Conditional Breakpoint",
			},
			{
				"<leader>Du",
				function()
					require("dapui").toggle()
				end,
				desc = "Debug: Toggle UI",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = { "python", "codelldb", "delve" },
				handlers = {
					-- Default handler for Python and any other out-of-the-box adapters
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,

					-- C/C++ Handler
					codelldb = function(config)
						config.configurations = {
							{
								name = "Launch executable",
								type = "codelldb",
								request = "launch",
								program = function()
									return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
								end,
								cwd = "${workspaceFolder}",
								stopOnEntry = false,
							},
						}
						require("mason-nvim-dap").default_setup(config)
					end,

					-- Go (Delve) Handler
					delve = function(config)
						config.configurations = {
							{
								type = "delve",
								name = "Debug file",
								request = "launch",
								program = "${file}",
							},
							{
								type = "delve",
								name = "Debug file (args)",
								request = "launch",
								program = "${file}",
								args = function()
									local raw = vim.fn.input("args> ")
									return vim.split(raw, " ", { trimempty = true })
								end,
							},
						}
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
}
