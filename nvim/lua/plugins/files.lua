-- Neo-tree: floating sidebar file explorer.
-- Oil: edit filesystem like a buffer ("-" keymap).

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree float focus toggle=true<CR>", desc = "Neo-tree (float)" },
			{ "<leader>E", "<cmd>Neotree left focus toggle=true<CR>", desc = "Neo-tree (left)" },
		},
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					hide_gitignored = false,
				},
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			window = { position = "float" },
		},
	},
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = false,
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
}
