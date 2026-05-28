-- Trouble: pretty list for diagnostics, LSP references/defs, qflist, loclist.

return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		focus = true,
		win = { border = "rounded" },
	},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Document symbols (outline)",
		},
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP defs/refs/impls" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODOs" },
	},
}
