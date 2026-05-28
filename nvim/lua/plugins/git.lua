-- Git: lazygit popup + inline hunk navigation/staging via gitsigns. Diffs with diffview

return {
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			{ "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (current file's repo)" },
			{ "<leader>gl", "<cmd>LazyGitFilter<cr>", desc = "LazyGit log" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Hunk navigation
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next git hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev git hunk")

				-- Hunk actions
				map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
				-- map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>hd", gs.diffthis, "Diff this")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Diff this (against ~)")

				-- Blame
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle inline blame")

				-- Text-objects
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = {},
	},
	-- {
	--     "tpope/vim-fugitive", opts = {}
	-- }
}
