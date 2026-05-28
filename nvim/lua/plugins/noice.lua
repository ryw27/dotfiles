-- Noice: replaces cmdline, popupmenu, and (optionally) message UI.

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim" },
	keys = {
		{ "<leader>nl", "<cmd>NoiceLast<cr>", desc = "Noice: last message" },
		{ "<leader>na", "<cmd>Noice<cr>", desc = "Noice: all messages" },
		{ "<leader>ne", "<cmd>NoiceErrors<cr>", desc = "Noice: errors" },
	},
	opts = {
		cmdline = { enabled = true, view = "cmdline_popup" },
		messages = { enabled = true },
		popupmenu = { enabled = true },
		notify = { enabled = false }, -- snacks.notifier handles vim.notify
		lsp = {
			progress = { enabled = false }, -- snacks shows progress; avoid duplicates
			signature = { enabled = false }, -- blink.cmp handles signature help
			hover = { enabled = true, silent = true },
			message = { enabled = true },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
	},
}
