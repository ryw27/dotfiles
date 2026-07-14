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
		-- nvim-lint already ships sensible defaults (auto-detects C vs C++,
		-- caches in build/, uses a parser-matched --template, sets
		-- --enable=warning,style,performance,information). We only append the
		-- portability check group and silence system-header noise. cppcheck
		-- accepts multiple --enable / --suppress flags additively.
		do
			local cppcheck = lint.linters.cppcheck
			table.insert(cppcheck.args, "--enable=portability")
			table.insert(cppcheck.args, "--suppress=missingIncludeSystem")
		end

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
