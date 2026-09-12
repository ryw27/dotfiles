-- Miscellaneous small plugins.
-- Each one is opt-in / load-on-demand wherever possible.

return {
	{ "tpope/vim-sleuth" },
	-- LazyDev: types for nvim Lua API + luvit when editing nvim config.
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- {
	-- 	"NMAC427/guess-indent.nvim",
	-- 	opts = {},
	-- },
	-- Highlights TODO / FIX / NOTE / HACK comments
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next TODO comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Prev TODO comment",
			},
			{ "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Find TODOs" },
		},
	},
	-- Which-key: discoverable keymap popup with named groups.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 200,
			spec = {
				{ "<leader>b", group = "Buffer", icon = { icon = "󰓩 ", color = "cyan" } },
				{ "<leader>c", group = "Code", icon = { icon = "󰘦 ", color = "orange" } },
				{ "<leader>D", group = "Debug", icon = { icon = "󰃤 ", color = "red" } },
				{ "<leader>f", group = "Find", icon = { icon = "󰍉 ", color = "blue" } },
				{ "<leader>g", group = "Git", icon = { icon = "󰊢 ", color = "orange" } },
				{ "<leader>h", group = "Git hunk", icon = { icon = "󰊢 ", color = "yellow" } },
				{ "<leader>i", group = "Toggle", icon = { icon = "󰔡 ", color = "yellow" } },
				{ "<leader>j", group = "Harpoon", icon = { icon = "󰛢 ", color = "azure" } },
				{ "<leader>m", group = "Markdown", icon = { icon = " ", color = "blue" } },
				{ "<leader>n", group = "Messages", icon = { icon = "󰍡 ", color = "purple" } },
				{ "<leader>q", group = "Session", icon = { icon = "󰆓 ", color = "green" } },
				{ "<leader>r", group = "Rename", icon = { icon = "󰑕 ", color = "green" } },
				{ "<leader>t", group = "Test", icon = { icon = "󰙨 ", color = "green" } },
				{ "<leader>v", group = "Vim", icon = { icon = " ", color = "green" } },
				{ "<leader>x", group = "Trouble", icon = { icon = "󰒡 ", color = "red" } },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer-local keymaps",
			},
		},
	},
	-- Restore the buffers/windows you had open per project directory.
	-- Autoload only for `nvim .` / `nvim path/to/proj`. Bare `nvim` → dashboard.
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		init = function()
			local grp = vim.api.nvim_create_augroup("PersistenceAutoLoad", { clear = true })

			-- Don't persist Avante's sidebar windows into the session file.
			vim.api.nvim_create_autocmd("User", {
				group = grp,
				pattern = "PersistenceSavePre",
				callback = function()
					if not package.loaded["avante"] then
						return
					end
					local sidebar = require("avante").get()
					if sidebar and sidebar:is_open() then
						sidebar:close()
					end
				end,
			})

			-- Session :source can race lazy FileType/LSP/lint hooks and leave
			-- buffers stuck as plain text. Re-detect after load settles.
			vim.api.nvim_create_autocmd("User", {
				group = grp,
				pattern = "PersistenceLoadPost",
				callback = function()
					vim.schedule(function()
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if
								vim.api.nvim_buf_is_loaded(buf)
								and vim.bo[buf].buflisted
								and vim.bo[buf].buftype == ""
								and vim.api.nvim_buf_get_name(buf) ~= ""
							then
								vim.api.nvim_buf_call(buf, function()
									vim.cmd("filetype detect")
								end)
							end
						end
					end)
				end,
			})

			vim.api.nvim_create_autocmd("VimEnter", {
				group = grp,
				nested = true,
				callback = function()
					if vim.fn.argc() ~= 1 or vim.g.started_with_stdin then
						return
					end
					local arg = vim.fn.argv(0)
					if vim.fn.isdirectory(arg) == 0 then
						return
					end

					vim.cmd.cd(arg)
					local persistence = require("persistence")
					local session = persistence.current()
					if vim.fn.filereadable(session) == 0 then
						session = persistence.current({ branch = false })
					end

					if vim.fn.filereadable(session) == 1 then
						persistence.load()
						return
					end

					-- No session: clear the directory buffer so the dashboard can own startup.
					vim.api.nvim_buf_set_name(0, "")
					vim.api.nvim_buf_set_lines(0, 0, -1, true, {})
				end,
			})
		end,
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore project session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Stop saving session",
			},
		},
	},
	-- Color preview for #rrggbb / rgb() / hsl() / named colours.
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	-- Auto-pair brackets/quotes.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	-- Undotree: visualise the undo history.
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Undotree" },
		},
	},
	-- Zen mode: distraction-free writing.
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
		},
		opts = {
			window = { width = 0.85 },
			plugins = {
				gitsigns = { enabled = true },
				tmux = { enabled = true },
			},
		},
	},
	-- Bufferline: Line at the top with buffers
	-- { "akinsho/bufferline.nvim", opts = {} },
	-- Highlight-Undo: Highlights undo/redo changes
	{
		"tzachar/highlight-undo.nvim",
		opts = {
			hlgroup = "HighlightUndo",
			duration = 300,
			pattern = { "*" },
			ignored_filetypes = { "neo-tree", "oil", "mason", "lazy", "snacks_dashboard" },
			-- ignore_cb is in comma as there is a default implementation. Setting
			-- to nil will mean no default os called.
			-- ignore_cb = nil,
		},
	},
	-- nvim-surround: Quicker keybinds for surrounding
	{
		"kylechui/nvim-surround",
		version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
		-- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
		-- config = function()
		--     require("nvim-surround").setup({
		--         -- Put your configuration here
		--     })
		-- end
	},
	-- Harpoon: Quick navigation of common files
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			-- <leader>j* = jump/harpoon (keeps <leader>a* free for Avante)
			vim.keymap.set("n", "<leader>ja", function()
				harpoon:list():add()
			end, { desc = "Harpoon add file" })
			vim.keymap.set("n", "<leader>jp", function()
				harpoon:list():prev()
			end, { desc = "Harpoon previous" })
			vim.keymap.set("n", "<leader>jn", function()
				harpoon:list():next()
			end, { desc = "Harpoon next" })
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon menu" })

			vim.keymap.set("n", "<M-1>", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon file 1" })
			vim.keymap.set("n", "<M-2>", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon file 2" })
			vim.keymap.set("n", "<M-3>", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon file 3" })
			vim.keymap.set("n", "<M-4>", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon file 4" })
		end,
	},
	-- Attaches notes to certain project files (made by me)
	{
		"ryw27/projectnotes.nvim",
		branch = "test",
		opts = {},
	},
	-- Nvim-treesitter: Uses treesitter for easier highlighting
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	branch = "main",
	-- 	init = function()
	-- 		-- Disable entire built-in ftplugin mappings to avoid conflicts.
	-- 		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
	-- 		vim.g.no_plugin_maps = true
	--
	-- 		-- Or, disable per filetype (add as you like)
	-- 		-- vim.g.no_python_maps = true
	-- 		-- vim.g.no_ruby_maps = true
	-- 		-- vim.g.no_rust_maps = true
	-- 		-- vim.g.no_go_maps = true
	-- 	end,
	-- 	config = function()
	-- 		-- put your config here
	-- 	end,
	-- },
}
