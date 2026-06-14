-- nvim-lint: runs linters that don't ship as LSPs.
-- Triggered after save, after entering a buffer, and when leaving insert mode.

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- cppcheck: second-opinion static analyzer for C / C++. clang-tidy
		-- (run inside clangd via --clang-tidy) catches one set of issues;
		-- cppcheck catches a different set (uninitialized reads, dead pointers,
		-- some leak heuristics, portability). Running both maximizes coverage.
		--
		-- Args:
		--   --enable=...         which check categories to run
		--   --inline-suppr       honor // cppcheck-suppress=... comments
		--   --suppress=missingIncludeSystem  silences noise from system headers
		--   --language=c++       force C++ parsing
		--   --std=c++20          assume C++20 unless a project file overrides
		--   --template=...       parseable diagnostic format
		--   --quiet              skip progress chatter
		lint.linters.cppcheck = vim.tbl_deep_extend("force", lint.linters.cppcheck or {}, {
			args = {
				"--enable=warning,style,performance,portability",
				"--inline-suppr",
				"--suppress=missingIncludeSystem",
				"--language=c++",
				"--std=c++20",
				"--template={file}:{line}:{column}: {severity}: {message} [{id}]",
				"--quiet",
			},
		})

		lint.linters_by_ft = {
			c = { "cppcheck" },
			cpp = { "cppcheck" },
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			zsh = { "shellcheck" },
			yaml = { "yamllint" },
			dockerfile = { "hadolint" },
			markdown = { "markdownlint" },
		}

		local grp = vim.api.nvim_create_augroup("UserLint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = grp,
			callback = function()
				-- pcall guards against missing binaries until mason finishes installs.
				pcall(lint.try_lint)
			end,
		})
	end,
}
