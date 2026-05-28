vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI / theme
vim.opt.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.pumheight = 12
vim.opt.cmdheight = 1
vim.opt.showmode = false -- lualine shows the mode
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.breakindent = true

-- Editing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.showmatch = true
vim.opt.virtualedit = "block"

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split" -- live :s preview

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Persistence / safety
vim.opt.undofile = true
vim.opt.autowrite = true
vim.opt.confirm = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- Selection
vim.opt.selection = "inclusive"

-- Mouse
vim.opt.mouse = "a"

-- Clipboard: Unify 
vim.opt.clipboard = "unnamedplus"

-- Diagnostics defaults (server-specific config lives in lsp-config.lua)
vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
    float = { border = "rounded", source = "if_many" },
    jump = { float = true },
})
