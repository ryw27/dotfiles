-- conform.nvim: Code formatter
-- You can customize some of the format options for the filetype (:help conform.format)
-- Conform will run the first available formatter
-- Vim sleuth running for tab space choice

return {
  'stevearc/conform.nvim',
  opts = {
	notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_organize_imports", "ruff_format" }, -- manually reconfigure isort, black, yapf, pyink
		c = { "clang-format" },
		cpp = { "clang-format" },
		go = { "goimports", "gofumpt" }, -- gofumpt is a stricter version of gofmt
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Web dev
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		-- Shell
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		-- SQL
		sql = { "sql_formatter" },
		-- Data / config
		json = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		toml = { "taplo" },
		markdown = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 3000,
		lsp_format = "fallback"
	},
	formatters = {
		["clang-format"] = {
			prepend_args = { "-style=file", "-fallback-style=LLVM" },
		},
		ruff_format = {
			-- ONLY run if a ruff configuration file exists
			require_cwd = true, 
		},
		ruff_organize_imports = {
			require_cwd = true,
		},
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
	}
  },
}
