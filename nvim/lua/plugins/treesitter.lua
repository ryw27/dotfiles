-- Treesitter: syntax-aware highlighting + indentation, plus parsers

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        auto_install = true,
        ensure_installed = {
            -- Languages
            "c", "cpp", "rust", "go", "zig",
            "python", "lua", "vim", "vimdoc", "query",
            "java", "ruby",
            "javascript", "typescript", "tsx", "html", "css", "scss",
            "graphql", "prisma",
            -- Data / config
            "json", "jsonc", "yaml", "toml", "xml",
            -- Build / infra
            "dockerfile", "make", "cmake", "ninja",
            -- Shell
            "bash",
            -- Docs / VCS
            "markdown", "markdown_inline",
            "gitcommit", "gitignore", "git_config", "git_rebase",
            "diff", "regex", "comment",
            -- DB
            "sql",
        },
        highlight = { enable = true },
        indent = { enable = true },
    },
}
