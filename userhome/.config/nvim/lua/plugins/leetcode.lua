local leetcode_home = vim.fn.expand("~/Code/leetcode")

return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    lang = "golang",
    storage = {
      home = leetcode_home,
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },
    cn = {
      enabled = true,
      translator = true,
      translate_problems = true,
    },
    picker = {
      provider = "telescope",
    },
    injector = {
      golang = {
        before = "package main",
      },
    },
    hooks = {
      enter = {
        function()
          vim.fn.mkdir(leetcode_home, "p")

          local gomod = leetcode_home .. "/go.mod"
          if vim.fn.filereadable(gomod) == 0 then
            vim.fn.writefile({
              "module leetcode",
              "",
              "go 1.24",
            }, gomod)
          end
        end,
      },
    },
  },
  keys = {
    { "<leader>ll", "<cmd>Leet list<cr>", desc = "LeetCode list" },
    { "<leader>ld", "<cmd>Leet daily<cr>", desc = "LeetCode daily" },
    { "<leader>lr", "<cmd>Leet run<cr>", desc = "LeetCode run" },
    { "<leader>ls", "<cmd>Leet submit<cr>", desc = "LeetCode submit" },
    { "<leader>lc", "<cmd>Leet console<cr>", desc = "LeetCode console" },
    { "<leader>li", "<cmd>Leet info<cr>", desc = "LeetCode info" },
    { "<leader>lg", "<cmd>Leet lang<cr>", desc = "LeetCode language" },
  },
}
