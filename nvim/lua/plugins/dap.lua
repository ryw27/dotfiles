-- =============================================================================
-- DAP: debugger UI + adapters.
--
-- Keymap layout. <leader>d is the delete-blackhole operator (see
-- vim-keymaps.lua), so the debug namespace lives under capital <leader>D.
-- Stepping stays on F-keys (no leader latency during active debugging).
--
--   F5  / F8  Continue           <leader>b  Toggle breakpoint
--   F10       Step over          <leader>B  Conditional breakpoint
--   F11       Step into          <leader>Dl Run last
--   F12       Step out           <leader>Dt Terminate
--                                <leader>De Eval (expression / selection)
--   <leader>Dr REPL UI           <leader>Dw Watches UI
--   <leader>DT Stack trace UI    <leader>Db Breakpoints UI
--   <leader>Dv Variables/Scopes  <leader>Dc Console UI
--   <leader>Du Toggle all UI
-- =============================================================================

vim.api.nvim_create_augroup("DapGroup", { clear = true })

-- Auto-focus dap-repl / Watches windows when they open.
local function focus_buffer(args)
	local bufnr = args.buf
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_set_current_win(win)
				end
			end)
			return
		end
	end
end

local function on_buf_pattern(pat)
	return {
		group = "DapGroup",
		pattern = string.format("*%s*", pat),
		callback = focus_buffer,
	}
end

return {
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		config = function()
			local dap = require("dap")

			-- ── Step / breakpoint keymaps ──────────────────────────────────
			local function map(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { desc = desc })
			end
			map("<F5>", dap.continue, "Debug: Continue")
			map("<F8>", dap.continue, "Debug: Continue")
			map("<F10>", dap.step_over, "Debug: Step over")
			map("<F11>", dap.step_into, "Debug: Step into")
			map("<F12>", dap.step_out, "Debug: Step out")
			map("<leader>b", dap.toggle_breakpoint, "Debug: Toggle breakpoint")
			map("<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, "Debug: Conditional breakpoint")
			map("<leader>Dl", dap.run_last, "Debug: Run last")
			map("<leader>Dt", dap.terminate, "Debug: Terminate")

			-- ── Adapters not covered by mason-nvim-dap ────────────────────
			-- codelldb: C / C++ / Rust. Mason installs it; we only need
			-- to wire the adapter and a sensible default configuration.
			local mason_registry = require("mason-registry")
			local function mason_pkg(name)
				return vim.fn.stdpath("data") .. "/mason/packages/" .. name
			end
			if mason_registry.is_installed("codelldb") then
				local codelldb_root = mason_pkg("codelldb") .. "/extension"
				local codelldb_path = codelldb_root .. "/adapter/codelldb"
				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb_path,
						args = { "--port", "${port}" },
					},
				}
				local c_cfg = {
					{
						name = "Launch file (codelldb)",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = function()
							local raw = vim.fn.input("Args: ")
							if raw == "" then
								return {}
							end
							return vim.split(raw, " ", { trimempty = true })
						end,
					},
				}
				dap.configurations.c = c_cfg
				dap.configurations.cpp = c_cfg
				dap.configurations.rust = c_cfg
			end

			-- debugpy for python (mason-nvim-dap also covers this, but make
			-- sure a configuration exists even if its handler doesn't fire).
			if mason_registry.is_installed("debugpy") then
				local python_path = mason_pkg("debugpy") .. "/venv/bin/python"
				dap.adapters.python = {
					type = "executable",
					command = python_path,
					args = { "-m", "debugpy.adapter" },
				}
				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						pythonPath = function()
							return "python"
						end,
					},
				}
			end
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			local function layout(name)
				return {
					elements = { { id = name } },
					enter = true,
					size = 40,
					position = "right",
				}
			end

			local name_to_layout = {
				repl = { layout = layout("repl"), index = 0 },
				stacks = { layout = layout("stacks"), index = 0 },
				scopes = { layout = layout("scopes"), index = 0 },
				console = { layout = layout("console"), index = 0 },
				watches = { layout = layout("watches"), index = 0 },
				breakpoints = { layout = layout("breakpoints"), index = 0 },
			}

			local layouts = {}
			for name, cfg in pairs(name_to_layout) do
				table.insert(layouts, cfg.layout)
				name_to_layout[name].index = #layouts
			end

			local function toggle_panel(name)
				dapui.close()
				local layout_config = name_to_layout[name]
				if not layout_config then
					error(("dap-ui: bad layout name %q"):format(name))
				end
				local uis = vim.api.nvim_list_uis()[1]
				if uis then
					layout_config.size = uis.width
				end
				pcall(dapui.toggle, layout_config.index)
			end

			-- ── UI panel toggles ───────────────────────────────────────────
			local function map(lhs, name, desc)
				vim.keymap.set("n", lhs, function()
					toggle_panel(name)
				end, { desc = desc })
			end
			map("<leader>Dr", "repl", "Debug: REPL UI")
			map("<leader>DT", "stacks", "Debug: Stack trace UI")
			map("<leader>Dw", "watches", "Debug: Watches UI")
			map("<leader>Db", "breakpoints", "Debug: Breakpoints UI")
			map("<leader>Dv", "scopes", "Debug: Variables/Scopes UI")
			map("<leader>Dc", "console", "Debug: Console UI")

			-- Toggle the most recent UI / eval expression.
			vim.keymap.set("n", "<leader>Du", function()
				dapui.toggle()
			end, { desc = "Debug: Toggle UI" })
			vim.keymap.set({ "n", "v" }, "<leader>De", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "Debug: Eval expression" })

			-- ── REPL niceties ──────────────────────────────────────────────
			vim.api.nvim_create_autocmd("BufEnter", {
				group = "DapGroup",
				pattern = "*dap-repl*",
				callback = function()
					vim.wo.wrap = true
				end,
			})
			vim.api.nvim_create_autocmd("BufWinEnter", on_buf_pattern("dap-repl"))
			vim.api.nvim_create_autocmd("BufWinEnter", on_buf_pattern("DAP Watches"))

			dapui.setup({ layouts = layouts, enter = true })

			-- Tear down UI on session end; route stdout/stderr into Console.
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			dap.listeners.after.event_output.dapui_config = function(_, body)
				if body.category == "console" then
					dapui.eval(body.output)
				end
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = { "delve", "python", "codelldb", "js" },
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
					delve = function(config)
						table.insert(config.configurations, 1, {
							type = "delve",
							name = "Debug file (args)",
							request = "launch",
							program = "${file}",
							outputMode = "remote",
							args = function()
								local raw = vim.fn.input("args> ")
								return vim.split(raw, " ", { trimempty = true })
							end,
						})
						table.insert(config.configurations, 1, {
							type = "delve",
							name = "Debug file",
							request = "launch",
							program = "${file}",
							outputMode = "remote",
						})
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
}
