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
			-- Prefer ruff, look for others
			python = function(bufnr)
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local formatter_lookup = {
					ruff = { "ruff_format", "ruff_organize_imports" },
					black = { "isort", "black" },
					pyink = { "isort", "pyink" },
					yapf = { "yapf" },
					autopep8 = { "autopep8" },
				}

				-- Prioritize ruff
				if vim.fs.find({ "ruff.toml", ".ruff.toml" }, { upward = true, path = buf_name, type = "file" })[1] then
					return formatter_lookup.ruff
				end

				local pyproject = vim.fs.find("pyproject.toml", { upward = true, path = buf_name, type = "file" })[1]
				if pyproject then
					-- Read the file and collect all tools present
					local tools_found = {}
					local lines = vim.fn.readfile(pyproject)
					for _, line in ipairs(lines) do
						local tool_name = line:match("%[tool%.([%w_%-]+)")
						if tool_name then
							tools_found[tool_name] = true
						end
					end

					if tools_found.pyink then
						return { "isort", "pyink" }
					elseif tools_found.black then
						return { "isort", "black" }
					elseif tools_found.ruff then
						return { "ruff_format", "ruff_organize_imports" }
					elseif tools_found.yapf then
						return { "yapf" }
					elseif tools_found.autopep8 then
						return { "autopep8" }
					end
				end

				return {}
			end,
			go = { "goimports", "gofumpt" },
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
			-- Rust
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
