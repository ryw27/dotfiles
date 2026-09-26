-- Treesitter: syntax-aware highlighting + indentation, plus parsers

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"c", "cpp", "rust", "go", "zig",
				"python", "lua", "java", "ruby",
				"javascript", "javascriptreact", "typescript", "typescriptreact",
				"html", "css", "scss", "graphql", "prisma",
				"json", "jsonc", "yaml", "toml", "xml",
				"dockerfile", "make", "cmake", "ninja",
				"sh", "bash", "zsh",
				"vim", "help", "query", "markdown",
				"gitcommit", "gitignore", "gitconfig", "gitrebase", "diff",
				"sql",
			},
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
