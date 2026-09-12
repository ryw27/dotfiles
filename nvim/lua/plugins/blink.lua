-- blink.cmp: Completion engine
-- Press <C-h> while the menu is open to show documentation
-- <C-f> and <C-b> to scroll up and down inside of the documentation

return {
	"saghen/blink.cmp",
	version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-h>"] = { "show_documentation", "hide_documentation", "fallback" },
		},
		completion = {
			accept = { auto_brackets = { enabled = true } },
			documentation = {
				auto_show = false,
				window = { border = "rounded" },
			},
			menu = {
				border = "rounded",
				draw = {
					columns = {
						{ "kind_icon", gap = 1 },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
			},
			ghost_text = { enabled = true },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = {
			enabled = true,
			window = { border = "rounded" },
		},

		-- Disable markdown blink autocomplete
		enabled = function()
			return not vim.tbl_contains({ "markdown", "text", "txt" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
		end,

	},
}
