-- fzf-lua: fuzzy finder for files, grep, LSP, diagnostics, help, keymaps.
-- live in lsp-config.lua's LspAttach handler so they are
-- buffer-local to LSP-attached buffers.

return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "FzfLua",
	opts = {
		winopts = {
			border = "rounded",
			preview = { default = "bat" },
		},
		keymap = {
			fzf = {
				["ctrl-d"] = "preview-page-down",
				["ctrl-u"] = "preview-page-up", -- was duplicated as page-down
				["ctrl-q"] = "select-all+accept",
			},
			builtin = {
				["<C-d>"] = "preview-page-down",
				["<C-u>"] = "preview-page-up",
			},
		},
	},
	keys = {
		-- Files
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fp",
			function()
				require("fzf-lua").git_files()
			end,
			desc = "Find project files (git)",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "Find recent files",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find config files",
		},

		-- Grepping
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Grep word under cursor",
		},
		{
			"<leader>fW",
			function()
				require("fzf-lua").grep_cWORD()
			end,
			desc = "Grep WORD under cursor",
		},
		{
			"<leader>/",
			function()
				require("fzf-lua").blines()
			end,
			desc = "Fuzzy search current buffer",
		},
		{
			"<leader>fR",
			function()
				require("fzf-lua").resume()
			end,
			desc = "Resume last picker",
		},
		{
			"<leader>fC",
			function()
				require("fzf-lua").live_grep({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Grep config files",
		},

		-- Diagnostics
		{
			"<leader>fx",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "Document diagnostics",
		},
		{
			"<leader>fX",
			function()
				require("fzf-lua").diagnostics_workspace()
			end,
			desc = "Workspace diagnostics",
		},

		-- Vim
		{
			"<leader>vh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "Vim+Plugin Documentation Help (How features/plugins work)",
		},
		{
			"<leader>vk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "Vim Keymaps",
		},
		{
			"<leader>vc",
			function()
				require("fzf-lua").commands()
			end,
			desc = "Vim Commands (How to do something)",
		},
		{
			"<leader>vC",
			function()
				require("fzf-lua").command_history()
			end,
			desc = "Command history",
		},
		{
			"<leader>vs",
			function()
				require("fzf-lua").spell_suggest()
			end,
			desc = "Spell Suggestions",
		},
	},
}
