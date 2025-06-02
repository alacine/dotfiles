-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("i", "vv", "<ESC>", { desc = "Swtich to Normal Mode" })
map("i", "<C-l>", "<ESC>", { desc = "Swtich to Normal Mode" })
map("n", "<space>v", ":e ~/.config/nvim/init.lua<CR>", { desc = "Open config file" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus on the window above " })
map("n", "<C-j>", "<C-w>j", { desc = "Focus on the window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus on the left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus on the right window" })
map("n", "<leader>n", "<CMD>bn<CR>", { desc = "Next buffer" })
map("n", "<leader>N", "<CMD>bp<CR>", { desc = "Previous buffer" })
map("n", "<leader>d", "<CMD>bd<CR>", { desc = "Delete buffer" })
map("n", "<leader>w", "<CMD>w<CR>", { desc = "Save" })
map("n", "<ESC>", "<CMD>nohlsearch<CR>")
