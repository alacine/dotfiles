return {
  "voldikss/vim-floaterm",
  event = "VeryLazy",
  keys = {
    { "<leader>ff", "<CMD>FloatermNew<CR>", desc = "Open Floaterm" },
    { "<leader>fy", "<CMD>FloatermNew yazi<CR>", desc = "Open Yazi" },
    { "<leader>fl", "<CMD>FloatermNew lazygit<CR>", desc = "Open Lazygit" },
    { "<F7>", "<CMD>FloatermNew<CR>", mode = { "n", "t" }, desc = "Floaterm New" },
    { "<F8>", "<CMD>FloatermPrev<CR>", mode = { "n", "t" }, desc = "Floaterm Prev" },
    { "<F9>", "<CMD>FloatermNext<CR>", mode = { "n", "t" }, desc = "Floaterm Next" },
    { "<F10>", "<CMD>FloatermToggle<CR>", mode = { "n", "t" }, desc = "Floaterm Toggle" },
  },
  config = function()
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
  end,
}
