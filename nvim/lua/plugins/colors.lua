-- Colorschemes. Catppuccin is the active default; the others are kept
-- as on-demand alternates and only load when you :colorscheme to them.

return {
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				filter = "spectrum",
			})
			vim.cmd.colorscheme("monokai-pro-spectrum")
		end,
	},
	{
		"polirritmico/monokai-nightasty.nvim",
		opts = {},
		-- config = function(_, opts)
		-- 	requre("monokai-nightasty").setup(opts)
		-- 	vim.cmd.colorscheme("monokai-nightasty")
		-- end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = false,
			integrations = {
				blink_cmp = true,
				gitsigns = true,
				lsp_trouble = true,
				mason = true,
				native_lsp = { enabled = true, inlay_hints = { background = true } },
				noice = true,
				notify = true,
				neotree = true,
				snacks = true,
				treesitter = true,
				which_key = true,
				dap = true,
				dap_ui = true,
				render_markdown = true,
			},
		},
		-- config = function(_, opts)
		-- 	require("catppuccin").setup(opts)
		-- 	vim.cmd.colorscheme("catppuccin-mocha")
		-- end,
	},
	{ "nyngwang/nvimgelion", name = "nvimgelion" },
	{ "ellisonleao/gruvbox.nvim", name = "gruvbox", lazy = true },
	{ "folke/tokyonight.nvim", lazy = true, opts = { style = "storm" } },
	{
		"everviolet/nvim",
		name = "evergarden",
		lazy = true,
		opts = {
			theme = { variant = "fall", accent = "green" },
			editor = {
				transparent_background = false,
				sign = { color = "none" },
				float = { color = "mantle", solid_border = false },
				completion = { color = "surface0" },
			},
		},
	},
	{
		"xiyaowong/transparent.nvim",
		lazy = false, -- Load immediately at boot
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NormalFloat", -- Clear floating window backgrounds
					"NemoTree", -- Clear file tree backgrounds if you use Neo-tree
					"LineNr", -- Clear line numbers background
					"SignColumn", -- Clear git signs column background
				},
			})
		end,
	},
	{ "nyoom-engineering/oxocarbon.nvim" },
}
