-- Colorschemes. Catppuccin is the active default; the others are kept
-- as on-demand alternates and only load when you :colorscheme to them.

return {
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
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
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
	{ "xiyaowong/transparent.nvim", opts = {} },
	{ "nyoom-engineering/oxocarbon.nvim" },
}
