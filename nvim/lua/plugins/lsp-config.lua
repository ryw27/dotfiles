-- LSP
-- mason: installs the binaries
-- nvim-lspconfig: default server configs (how to start clangd, gopls, …)
-- vim.lsp.config: my overrides + blink completion
-- mason-lspconfig: enable the right server for the filetype
-- LspAttach: buffer keymaps (fzf jumps, rename, clangd header)
-- venv-selector: pick a Python venv
-- mason-tool-installer: formatters and linters


return {
	{ "mason-org/mason.nvim", opts = {} },
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--fallback-style=llvm",
				},
			})
			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = { analysis = { diagnosticMode = "openFilesOnly" } },
				},
			})
			vim.lsp.config("gopls", {
				settings = { gopls = { gofumpt = true, staticcheck = true } },
			})
			vim.lsp.config("yamlls", {
				settings = { yaml = { keyOrdering = false } },
			})

			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {
					"lua_ls",
					"clangd",
					"gopls",
					"basedpyright",
					"rust_analyzer",
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					"jsonls",
					"yamlls",
					"taplo",
					"dockerls",
					"bashls",
					"sqlls",
					"marksman",
				},
			})

			-- K / insert <C-s> / grn / gra / grr are Neovim defaults.
			-- These replace the defaults that benefit from a picker.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(ev)
					local buf = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end

					local fzf = require("fzf-lua")
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
					end

					map("n", "gd", fzf.lsp_definitions, "Goto definition")
					map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
					map("n", "gi", fzf.lsp_implementations, "Goto implementation")
					map("n", "gr", fzf.lsp_references, "Goto references")
					map("n", "gy", fzf.lsp_typedefs, "Goto type definition")
					map("n", "<leader>fs", fzf.lsp_document_symbols, "Document symbols")
					map("n", "<leader>fS", fzf.lsp_workspace_symbols, "Workspace symbols")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

					if client:supports_method("textDocument/inlayHint") then
						map("n", "<leader>ih", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "Toggle inlay hints")
					end

					if client.name == "clangd" then
						map("n", "<leader>ch", function()
							client:request(
								"textDocument/switchSourceHeader",
								vim.lsp.util.make_text_document_params(buf),
								function(err, result)
									if not err and result then
										vim.cmd.edit(vim.uri_to_fname(result))
									end
								end,
								buf
							)
						end, "Switch source/header")
					end
				end,
			})
		end,
	},

	{
		"linux-cultist/venv-selector.nvim",
		ft = "python",
		dependencies = { "ibhagwan/fzf-lua" },
		opts = {
			options = {
				picker = "fzf-lua",
				cached_venv_automatic_activation = true,
			},
		},
		keys = {
			{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Virtual Env" },
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"prettierd",
				"prettier",
				"clang-format",
				"goimports",
				"gofumpt",
				"ruff",
				"sql-formatter",
				"shellcheck",
				"yamllint",
				"hadolint",
				"eslint_d",
			},
		},
	},
}
