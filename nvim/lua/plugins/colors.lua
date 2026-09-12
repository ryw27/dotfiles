-- Colorschemes + Themery picker

return {
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		opts = { filter = "spectrum" },
	},
	{
		"polirritmico/monokai-nightasty.nvim",
		lazy = true,
		opts = {},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
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
	},
	{ "nyngwang/nvimgelion", name = "nvimgelion", lazy = true },
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
		lazy = false,
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NormalFloat",
					"NeoTreeNormal",
					"NeoTreeNormalNC",
					"LineNr",
					"SignColumn",
				},
			})
		end,
	},
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },
	{
		"zaldih/themery.nvim",
		lazy = false,
		cmd = "Themery",
		keys = {
			{ "<leader>vt", "<cmd>Themery<cr>", desc = "Colorscheme picker" },
		},
		opts = {
			livePreview = true,
			themes = {
				{ name = "Monokai Pro Spectrum", colorscheme = "monokai-pro-spectrum" },
				{ name = "Monokai Pro Classic", colorscheme = "monokai-pro-classic" },
				{ name = "Monokai Nightasty", colorscheme = "monokai-nightasty" },
				{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
				{ name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
				{ name = "Gruvbox", colorscheme = "gruvbox" },
				{ name = "Evergarden", colorscheme = "evergarden" },
				{ name = "Oxocarbon", colorscheme = "oxocarbon" },
				{ name = "Nvimgelion", colorscheme = "nvimgelion" },
			},
		},
		config = function(_, opts)
			require("themery").setup(opts)
			if not require("themery").getCurrentTheme() then
				vim.cmd.colorscheme("monokai-pro-spectrum")
			end
		end,
	},
}
