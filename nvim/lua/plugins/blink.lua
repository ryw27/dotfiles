-- blink.cmp: completion engine. signature help here is the in-flight
-- popup that appears while you type function arguments (Noice handles
-- the normal-mode <C-s> popup separately).

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
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			accept = { auto_brackets = { enabled = true } },
			menu = {
				border = "rounded",
				draw = {
					columns = {
						{ "kind_icon", gap = 1 },
						{ "label", "label_description", gap = 1 },
						{ "kind" }, -- This shows "Function", "Keyword", etc. on the right
					},
				},
			},
			documentation = {
				auto_show = false,
				window = { border = "rounded" },
			},
			ghost_text = { enabled = true },
		},

		enabled = function()
			return not vim.tbl_contains({ "markdown", "text", "txt" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
		end,

		-- 4. SOURCES & SNIPPETS
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		signature = {
			enabled = true,
			window = { border = "rounded" },
		},
	},
}
