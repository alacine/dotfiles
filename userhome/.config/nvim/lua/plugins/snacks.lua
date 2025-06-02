return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = "colorscript -e square",
          height = 5,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      lsp_config = {
        finder = "lsp.config#find",
        format = "lsp.config#format",
        preview = "lsp.config#preview",
        confirm = "close",
        sort = { fields = { "score:desc", "attached_buf", "attached", "enabled", "installed", "name" } },
        matcher = { sort_empty = true },
      },
      win = {
        input = {
          keys = {
            ["<esc>"] = { "close", mode = { "n", "i" } },
            ["<C-[>"] = { "close", mode = { "n", "i" } },
            ["<C-d>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    lazygit = {},
    blame_line = {
      width = 0.6,
      height = 0.6,
      border = "rounded",
      title = " Git Blame ",
      title_pos = "center",
      ft = "git",
    },
    log_line = {
      width = 0.6,
      height = 0.6,
      border = "rounded",
      title = " Git Blame ",
      title_pos = "center",
      ft = "git",
    },
  },
  -- stylua: ignore
  keys = {
    { "<space>gb", function() Snacks.git.blame_line() end, desc = "Git blame line" },
    { "<space>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<space>gL", function() Snacks.picker.git_log_line() end, desc = "Git log line" },
    { "<space>gS", function() Snacks.picker.git_stash() end, desc = "Git stash" },
    { "<space>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
  },
}
