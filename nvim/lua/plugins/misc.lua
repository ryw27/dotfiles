-- Miscellaneous small plugins.
-- Each one is opt-in / load-on-demand wherever possible.

return {
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

	-- Highlights TODO / FIX / NOTE / HACK comments.
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
			spec = {
				{ "<leader>f", group = "Find / Fuzzy" },
				{ "<leader>g", group = "Git" },
				{ "<leader>h", group = "Git Hunk" },
				{ "<leader>d", group = "Delete" },
				{ "<leader>D", group = "Debug" },
				{ "<leader>t", group = "Test" },
				{ "<leader>x", group = "Trouble" },
				{ "<leader>c", group = "Code / LSP" },
				{ "<leader>v", group = "Vim" },
				{ "<leader>i", group = "Inlay / Toggle" },
				{ "<leader>r", group = "Rename / Refactor" },
				{ "<leader>b", group = "Breakpoint / Buffer" },
				{ "<leader>n", group = "Notifications / Notes" },
				{ "<leader>q", group = "Session" },
				{ "[", group = "Prev" },
				{ "]", group = "Next" },
				{ "g", group = "Goto" },
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
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
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
	-- blink.cmp's auto_brackets only inserts () for function completions; it
	-- doesn't pair [, {, ", ' as you type. nvim-autopairs does that.
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

	-- Oil: edit your filesystem like a buffer.
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = { show_hidden = true },
			keymaps = {
				["<C-h>"] = false, -- let tmux-navigator handle it
				["<C-l>"] = false,
				["q"] = "actions.close",
			},
		},
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
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
			ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy" },
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

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon add file" })
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

			-- Ctrl+Shift chords are not reliable in many terminals.
			vim.keymap.set("n", "<leader>ap", function()
				harpoon:list():prev()
			end, { desc = "Harpoon previous" })
			vim.keymap.set("n", "<leader>an", function()
				harpoon:list():next()
			end, { desc = "Harpoon next" })
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
