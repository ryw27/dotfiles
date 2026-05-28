-- Markdown stack:
--   * render-markdown.nvim -> pretty in-buffer rendering
--   * autolist.nvim        -> bullet/number/checkbox continuation + recalc
-- Both lazy-load on markdown/text/gitcommit so other buffers are untouched.

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
			heading = {
				sign = false,
				width = "block",
				position = "inline",
			},
			code = {
				sign = false,
				width = "block",
				border = "thin",
				min_width = 60,
			},
			bullet = { icons = { "●", "○", "◆", "◇" } },
			checkbox = {
				unchecked = { icon = " 󰄱 " },
				checked = { icon = " 󰱒 " },
			},
			pipe_table = { preset = "round" },
		},
	},

	{
		"gaoDean/autolist.nvim",
		ft = { "markdown", "text", "gitcommit" },
		config = function()
			require("autolist").setup()

			-- Buffer-local maps only — avoids hijacking <CR>/<Tab> elsewhere.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("autolist_keys", { clear = true }),
				pattern = { "markdown", "text", "gitcommit" },
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local map = vim.keymap.set

					-- Insert: new bullet on <CR>, indent in/out with <Tab>/<S-Tab>.
					map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", opts)
					map("i", "<Tab>", "<cmd>AutolistTab<cr>", opts)
					map("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>", opts)

					-- Normal: open new bullet lines, toggle checkbox, recalc on delete.
					map("n", "o", "o<cmd>AutolistNewBullet<cr>", opts)
					map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", opts)
					map("n", "<C-r>", "<cmd>AutolistRecalculate<cr>", opts)
					map("n", "<leader>x", "<cmd>AutolistToggleCheckbox<cr>", opts)
					map("n", "dd", "dd<cmd>AutolistRecalculate<cr>", opts)
					map("x", "d", "d<cmd>AutolistRecalculate<cr>", opts)
				end,
			})
		end,
	},
	-- {
	-- 	"toppair/peek.nvim",
	-- 	event = { "VeryLazy" },
	-- 	build = "deno task --quiet build:fast",
	-- 	config = function()
	-- 		require("peek").setup()
	-- 		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
	-- 		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	-- 	end,
	-- },
}
