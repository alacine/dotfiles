return {
  "voldikss/vim-floaterm",
  keys = {
    { "<leader>ff", "<CMD>FloatermNew<CR>", desc = "Open Floaterm" },
    { "<leader>fy", "<CMD>FloatermNew yazi<CR>", desc = "Open Yazi" },
    { "<leader>fl", "<CMD>FloatermNew lazygit<CR>", desc = "Open Lazygit" },
  },
  config = function()
    vim.g.floaterm_keymap_new = "<F7>"
    vim.g.floaterm_keymap_prev = "<F8>"
    vim.g.floaterm_keymap_next = "<F9>"
    vim.g.floaterm_keymap_toggle = "<F10>"
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
  end,
}
