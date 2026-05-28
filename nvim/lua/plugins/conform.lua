-- conform.nvim: format-on-save via a per-filetype formatter chain.
-- Falls back to LSP formatter if no entry exists for a filetype.

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufNewFile" },
	cmd = { "ConformInfo", "ConformFormat" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format buffer/range",
		},
	},
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },

			-- Python: prefer ruff (one tool, fast); fall back to isort+black.
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format", "ruff_organize_imports" }
				end
				return { "isort", "black" }
			end,

			-- Go
			go = { "goimports", "gofumpt" },

			-- C / C++
			c = { "clang-format" },
			cpp = { "clang-format" },

			-- Web / TS / JS family
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			vue = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			less = { "prettierd", "prettier", stop_after_first = true },

			-- Data / config
			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			toml = { "taplo" },
			markdown = { "prettierd", "prettier", stop_after_first = true },

			-- Shell
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },

			-- SQL
			sql = { "sql_formatter" },

			-- Rust (LSP usually handles it, but rustfmt as belt-and-braces)
			rust = { "rustfmt", lsp_format = "fallback" },
		},
		formatters = {
			["clang-format"] = {
				prepend_args = { "-style=file", "-fallback-style=LLVM" },
			},
			shfmt = {
				prepend_args = { "-i", "2", "-ci" }, -- 2-space, case indent
			},
			sql_formatter = {
				prepend_args = { "--language", "postgresql" },
			},
		},
		format_on_save = function(bufnr)
			-- Allow disabling autoformat per-buffer or globally via:
			--   :lua vim.b.disable_autoformat = true
			--   :lua vim.g.disable_autoformat = true
			if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
				return
			end
			return { timeout_ms = 5000, lsp_format = "fallback" }
		end,
	},
}
