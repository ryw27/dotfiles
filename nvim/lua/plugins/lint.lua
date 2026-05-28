-- nvim-lint: runs linters that don't ship as LSPs.
-- Triggered after save, after entering a buffer, and when leaving insert mode.

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
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
