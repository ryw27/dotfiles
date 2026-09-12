vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- UI
vim.opt.termguicolors = true -- TUI usually detects this; keep so WSL/tmux cannot drop truecolor
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.pumheight = 12
vim.opt.showmode = false -- lualine shows the mode
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.breakindent = true

-- Editing (defaults are tabstop/shiftwidth 8, no expandtab)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.virtualedit = "block"

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Persistence / safety
vim.opt.undofile = true
vim.opt.autowrite = true
vim.opt.confirm = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
-- vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
	float = { border = "rounded", source = "if_many" },
	jump = { float = true },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
})
