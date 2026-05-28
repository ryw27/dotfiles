-- Lualine: status bar.

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		return {
			options = {
				theme = "catppuccin-mocha",
				globalstatus = true,
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {
						"alpha",
						"dashboard",
						"help",
						"lazy",
						"mason",
						"neo-tree",
						"oil",
						"qf",
						"snacks_dashboard",
					},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ "branch", icon = "" },
					"diff",
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = { modified = " ●", readonly = " 󰌾", unnamed = "[No Name]" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
					},
				},
				lualine_x = {
					{
						function()
							local reg = vim.fn.reg_recording()
							return reg ~= "" and ("recording @" .. reg) or ""
						end,
						color = { fg = "#f38ba8", gui = "bold" },
					},
					{ "searchcount", maxcount = 999, timeout = 500 },
					{ "filetype", icon_only = false },
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		}
	end,
}
