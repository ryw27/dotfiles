-- LSP: Mason-managed servers, capabilities wired to blink.cmp, LspAttach
-- bindings (LSP-only keymaps live here so they are buffer-local).

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			require("mason").setup()

			-- 1. Capabilities from blink.cmp (snippetSupport, completion, etc.)
			local has_blink, blink = pcall(require, "blink.cmp")
			local capabilities = has_blink and blink.get_lsp_capabilities()
				or vim.lsp.protocol.make_client_capabilities()

			-- 2. Apply defaults to every server (Neovim 0.11+ API).
			vim.lsp.config("*", { capabilities = capabilities })

			-- 3. Per-server overrides.
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						hint = { enable = true }, -- inlay hints
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--header-insertion-decorators",
					"--completion-style=detailed",
					"--all-scopes-completion",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--limit-references=0",
					"--limit-results=0",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			})

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						gofumpt = true,
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						analyses = { unusedparams = true, shadow = true },
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			})

			vim.lsp.config("pyright", {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						keyOrdering = false,
						format = { enable = true },
						schemaStore = { enable = true, url = "" },
					},
				},
			})

			vim.lsp.config("jsonls", {
				settings = {
					json = { validate = { enable = true } },
				},
			})

			-- 4. Tell mason-lspconfig which servers to install and have it
			--    auto-enable them via vim.lsp.enable() (mason-lspconfig 2.x).
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {
					-- Systems / general
					"lua_ls",
					"clangd",
					"gopls",
					"pyright",
					"rust_analyzer",
					-- Web
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					-- Data / config
					"jsonls",
					"yamlls",
					"taplo", -- TOML
					"dockerls",
					"bashls",
					"sqlls",
					"marksman", -- Markdown
				},
			})

			-- 5. Diagnostic signs (config.virtual_text etc. already in vim-options.lua).
			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = signs.Error,
						[vim.diagnostic.severity.WARN] = signs.Warn,
						[vim.diagnostic.severity.INFO] = signs.Info,
						[vim.diagnostic.severity.HINT] = signs.Hint,
					},
				},
			})

			-- 6. LspAttach: keymaps that only make sense with an LSP attached
			--    + per-server inlay hints / document highlight / code lens.
			local grp = vim.api.nvim_create_augroup("UserLspAttach", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = grp,
				callback = function(ev)
					local bufnr = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end

					local fzf = require("fzf-lua")
					local kmap = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end

					-- Navigation (fzf-lua wraps the LSP request in a picker).
					kmap("n", "gd", fzf.lsp_definitions, "Goto definition")
					kmap("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
					kmap("n", "gi", fzf.lsp_implementations, "Goto implementation")
					kmap("n", "gr", fzf.lsp_references, "Goto references")
					kmap("n", "gy", fzf.lsp_typedefs, "Goto type definition")

					-- Symbols
					kmap("n", "<leader>fs", fzf.lsp_document_symbols, "Document symbols")
					kmap("n", "<leader>fS", fzf.lsp_workspace_symbols, "Workspace symbols")

					-- Info
					kmap("n", "K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "Hover docs")
					kmap("n", "<C-s>", function()
						vim.lsp.buf.signature_help({ border = "rounded" })
					end, "Signature help")

					-- Refactor
					kmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
					kmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

					-- Clangd: switch between source (.cpp/.c) and header (.h/.hpp).
					-- Mirrors `C/C++: Switch Header/Source` from VS Code's cpptools.
					if client.name == "clangd" then
						kmap("n", "<leader>ch", function()
							local params = vim.lsp.util.make_text_document_params(bufnr)
							client:request("textDocument/switchSourceHeader", params, function(err, result)
								if err or not result then
									return
								end
								vim.cmd.edit(vim.uri_to_fname(result))
							end, bufnr)
						end, "Switch source/header")
					end

					-- Inlay hints (toggle).
					if client:supports_method("textDocument/inlayHint") then
						-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
						kmap("n", "<leader>ih", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "Toggle inlay hints (global)")
					end

					-- Code lens (Go, Rust, Java, TS commonly). Transient: press
					-- <leader>cL to show, annotations clear on the next cursor
					-- move (or after 8s as a safety net). No persistent noise.
					if client:supports_method("textDocument/codeLens") then
						kmap("n", "<leader>cL", function()
							vim.lsp.codelens.refresh({ bufnr = bufnr })
							local function clear()
								pcall(vim.lsp.codelens.clear, client.id, bufnr)
							end
							vim.api.nvim_create_autocmd("CursorMoved", {
								buffer = bufnr,
								once = true,
								callback = clear,
							})
							vim.defer_fn(clear, 8000)
						end, "Code lens (transient show)")
					end
				end,
			})
		end,
	},

	-- Auto-install non-LSP tooling (formatters, linters, DAP adapters).
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			run_on_start = true,
			ensure_installed = {
				-- Formatters
				"stylua",
				"shfmt",
				"prettierd",
				"prettier",
				"clang-format",
				"goimports",
				"gofumpt",
				"ruff", -- formatter + linter for Python
				"isort",
				"black",
				"sql-formatter",
				-- Linters
				"shellcheck",
				"yamllint",
				"markdownlint",
				"hadolint",
				"eslint_d",
				"vale",
				"cppcheck", -- C / C++ second-opinion static analyzer (alongside clang-tidy via clangd)
				-- DAP adapters
				"codelldb", -- C / C++ / Rust
				"debugpy", -- Python
				"js-debug-adapter", -- JS / TS
				"delve", -- Go
			},
		},
	},
}
