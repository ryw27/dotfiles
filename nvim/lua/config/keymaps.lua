-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Force Space + e to open the floating Neotree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle float<cr>", { desc = "Toggle Floating Explorer" })
